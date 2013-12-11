//
//  GViewAppDelegate.m
//  SpacePuzzleEditor
// REMOVE CONNECTION VAFAN??
#import "AppDelegate.h"
#import "BoardScene.h"
#import "XMLParser.h"
#import "Element.h"
#import "StarButton.h"
#import "Star.h"
#import "Connections.h"
#import "Bridge.h"
#import "BridgeButton.h"
#import "PlatformLever.h"
#import "Path.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize skView = _skView;
@synthesize recentMenu = _recentMenu;
@synthesize controlPanel = _controlPanel;
@synthesize connections = _connections;
@synthesize palette = _palette;

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
 //   _window.acceptsMouseMovedEvents = YES;
   // [_window makeFirstResponder:self.skView.scene];
 
    /* Pick a size for the scene */
    _scene = [BoardScene sceneWithSize:CGSizeMake(WIN_SIZE_X, WIN_SIZE_Y)];
    
    /* Set the scale mode to scale to fit the window */
    currentFilePath = @"";
    edited = NO;
    _scene.scaleMode = SKSceneScaleModeAspectFit;
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [_skView presentScene:_scene];
    _connections = [[Connections alloc] init];
    
    [self setupBoard];
    [self observeText:@"BoardEdited" Selector:@selector(boardEdited:)];
    [self observeText:@"ControlDrag" Selector:@selector(controlDragged:)];
    [self observeText:@"ControlDragUp" Selector:@selector(controlDragUp:)];
    [self observeText:@"PathDrag" Selector:@selector(pathDrag:)];
    [[self window] setTitle:@"Untitled.splvl"];
    [_palette setFloatingPanel:YES];
    //[_palette setWorksWhenModal:YES];
    [_palette setBecomesKeyOnlyIfNeeded:YES];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(void)pathDrag:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSSet *objectSent = [userInfo objectForKey:@"PathDrag"];
    NSArray *data = [objectSent allObjects];
    NSValue *startPoint = [data objectAtIndex:0];
    NSValue *endPoint = [data objectAtIndex:1];
    
    NSNumber *indexStart = [NSNumber numberWithInteger:startPoint.pointValue.y*BOARD_SIZE_X + startPoint.pointValue.x];
    NSInteger indexStartInt = [indexStart integerValue];
    BoardCoord *bc = [[_board board] objectAtIndex:indexStartInt];
    // Since, in the editor, you can only place one element at a position, always take index:0.
    if(bc.elements.count > 0) {
        Element *eStart = [bc.elements objectAtIndex:0];
        //  Element *eEnd = [[_board elementDictionary] objectForKey:indexEnd];
    
        CGPoint pStart = CGPointMake(startPoint.pointValue.x, startPoint.pointValue.y);
        CGPoint pEnd = CGPointMake(endPoint.pointValue.x, endPoint.pointValue.y);

        if(eStart && [_board isPointWithinBoard:pStart] && [_board isPointWithinBoard:pEnd]) {
            if([eStart isKindOfClass:[MovingPlatform class]]) {
                MovingPlatform *mp = (MovingPlatform*)eStart;
                NSMutableArray *points = [[mp path] points];
                Position *p = [points objectAtIndex:[points count]-1];
                CGPoint pp = CGPointMake(p.x, p.y);
                if((p.x != pEnd.x || p.y != pEnd.y) && ![Converter isPoint:pp DiagonallyAdjacentWithPoint:pEnd]) {
                    [[mp path] addPoint:pEnd];
                    [self refreshPathView:pEnd];
                }
            }
        }
    }
}

-(void)refreshPathView:(CGPoint)p {
    [_scene removeAllPaths];
    
    for (int i = 0; i < [[_board board] count]; i++) {
        BoardCoord *bc = [[_board board] objectAtIndex:i];
        
        for (int j = 0; j < bc.elements.count; j++) {
            Element *e = [bc.elements objectAtIndex:j];
            
            if([e isKindOfClass:[MovingPlatform class]]) {
                MovingPlatform *mp = (MovingPlatform*)e;
                NSMutableArray *vals = [[NSMutableArray alloc] init];
                for(int j = 0; j < mp.path.points.count; j++ ) {
                    Position *p = [mp.path.points objectAtIndex:j];
                    NSPoint pp;
                    pp.x = p.x;
                    pp.y = p.y;
                    
                    NSValue *v = [NSValue valueWithPoint:pp];
                    [vals insertObject:v atIndex:j];
                }
                [_scene addAPath:vals];
            }
        }
    }
    [_scene pathHighlight:p];
}

-(void)controlDragged:(NSNotification*) notification {
    // Get the data.
    NSDictionary *userInfo = notification.userInfo;
    NSSet *objectSent = [userInfo objectForKey:@"ControlDrag"];
    NSArray *data = [objectSent allObjects];
    NSValue *startPoint = [data objectAtIndex:0];
    NSValue *endPoint = [data objectAtIndex:1];
    NSNumber *indexStart = [NSNumber numberWithInteger:startPoint.pointValue.y*BOARD_SIZE_X + startPoint.pointValue.x];
    NSNumber *indexEnd = [NSNumber numberWithInteger:endPoint.pointValue.y*BOARD_SIZE_X + endPoint.pointValue.x];
    NSInteger indexStartInt = [indexStart integerValue];
    NSInteger indexEndInt = [indexEnd integerValue];
    
    BoardCoord *bcStart = [[_board board] objectAtIndex:indexStartInt];
    BoardCoord *bcEnd = [[_board board] objectAtIndex:indexEndInt];
    
    if(bcStart.elements.count > 0 && bcEnd.elements.count > 0) {
        Element *eStart = [bcStart.elements objectAtIndex:0];
        Element *eEnd = [bcEnd.elements objectAtIndex:0];
    
        CGPoint pStart = CGPointMake(startPoint.pointValue.x, startPoint.pointValue.y);
        CGPoint pEnd = CGPointMake(endPoint.pointValue.x, endPoint.pointValue.y);

        if(eStart && eEnd && [_board isPointWithinBoard:pStart] && [_board isPointWithinBoard:pEnd]) {
            if([Connections isValidConnection:eStart To:eEnd]) {
                // Tell the scene to highlight element.
                CGPoint p = CGPointMake(endPoint.pointValue.x, endPoint.pointValue.y);
                [_scene highlightElement:p];
            } else {
                // No highlight should be presented, since the elements cannot be connected.
                [_scene noHighlight];
            }
        } else {
            [_scene noHighlight];
        }
    } else {
        [_scene noHighlight];
    }
}

-(void)controlDragUp:(NSNotification *)notification {
    // Get the data.
    NSDictionary *userInfo = notification.userInfo;
    NSSet *objectSent = [userInfo objectForKey:@"ControlDragUp"];
    NSArray *data = [objectSent allObjects];
    NSValue *startPoint = [data objectAtIndex:0];
    NSValue *endPoint = [data objectAtIndex:1];
    NSNumber *indexStart = [NSNumber numberWithInteger:startPoint.pointValue.y*BOARD_SIZE_X + startPoint.pointValue.x];
    NSNumber *indexEnd = [NSNumber numberWithInteger:endPoint.pointValue.y*BOARD_SIZE_X + endPoint.pointValue.x];
    NSInteger indexStartInt = [indexStart integerValue];
    NSInteger indexEndInt = [indexEnd integerValue];
    
    BoardCoord *bcStart = [[_board board] objectAtIndex:indexStartInt];
    BoardCoord *bcEnd = [[_board board] objectAtIndex:indexEndInt];
    
    if(bcStart.elements.count > 0 && bcEnd.elements.count > 0) {
        Element *eStart = [bcStart.elements objectAtIndex:0];
        Element *eEnd = [bcEnd.elements objectAtIndex:0];
    
        if(eStart && eEnd) {
            // Check class for highlighting purpose.
            if([Connections isValidConnection:eStart To:eEnd]) {
                [_connections addConnectionFrom:eStart To:eEnd];
                [self updateConnectionsView];
            } else {
                // No highlight should be presented, since the elements cannot be connected.
                [_scene noHighlight];
            }
        } else {
            [_scene noHighlight];
        }
    }
}

-(BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {
    [_board loadBoard:filename];
    currentFilePath = filename;
    [[self window] setTitle:[filename lastPathComponent]];
    [self refreshView];
    return YES;
}

-(void)refreshView {
    [self refreshBoardView];
    [self refreshElementView];
    [self updateConnectionsView];
    [self refreshPathView:CGPointMake(-10, -10)];
}

-(void)cleanView {
    [self refreshBoardView];
    [self refreshElementView];
    [self refreshPathView:CGPointMake(-10, -10)];
    [_scene cleanView];
}

/*
 *  Should be called when a new board has been loaded. This function updates the view of the changes. */
-(void)refreshBoardView {
    edited = NO;
    NSInteger boardSizeX = [_board boardSizeX];
    NSInteger boardSizeY = [_board boardSizeY];
    
    for(int i = 0; i < boardSizeY; i++) {
        for(int j = 0; j < boardSizeX; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:boardSizeX*i + j];
            
            [_scene refreshBoardX:[bc x] Y:[bc y] Status:[bc status]];
        }
    }
}

/*
 *  Updated the view with every element present in the data model. */
-(void)refreshElementView {
    CGPoint sAs = CGPointMake(_board.startPosAstronaut.x, _board.startPosAstronaut.y);
    CGPoint sAl = CGPointMake(_board.startPosAlien.x, _board.startPosAlien.y);
    CGPoint f = CGPointMake(_board.finishPos.x, _board.finishPos.y);
    [_scene refreshStartAstro:sAs StartAlien:sAl Finish:f];
    
    [_scene cleanElements];
    for(int i = 0; i < [_board board].count; i++) {
        BoardCoord *bc = [[_board board] objectAtIndex:i];
      
        for(int j = 0; j < bc.elements.count; j++) {
            Element *e = [[bc elements] objectAtIndex:j];
            CGPoint pos = CGPointMake(e.x, e.y);
            [_scene addElement:[_scene classToBrush:e.className] Position:pos];
        }
    }
}

/*
 *  Called when the board has been edited in the |BoardScene|. Updates the data model according to the 
 *  change. */
-(void)boardEdited:(NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    NSSet *objectSent = [userInfo objectForKey:@"BoardEdited"];
    NSArray *data = [objectSent allObjects];
    // Edited at coordinate.
    NSValue *val = [data objectAtIndex:0];
    CGPoint point = CGPointMake(val.pointValue.x, val.pointValue.y);
    // The used brush.
    NSInteger stat = [[data objectAtIndex:1] integerValue];
    NSNumber *flatIndex = [NSNumber numberWithInt:point.y * BOARD_SIZE_X + point.x];
    // If the change was on a tile, the |BoardCoord| status should change. Otherwise elements should change.
    if(stat == MAPSTATUS_SOLID || stat == MAPSTATUS_CRACKED || stat == MAPSTATUS_VOID) {
        BoardCoord *bc = [[_board board] objectAtIndex:point.y * BOARD_SIZE_X + point.x];
        bc.status = stat;
    } else {
        // newPos == point, no??
        CGPoint newPos = CGPointMake(val.pointValue.x, val.pointValue.y);

        if(stat == BRUSH_START_ASTRO) {
            // Update position of start element.
            _board.startPosAstronaut.x = newPos.x;
            _board.startPosAstronaut.y = newPos.y;
            _scene.startAstronautSprite.hidden = NO;
        } else if(stat == BRUSH_START_ALIEN) {
            _board.startPosAlien.x = newPos.x;
            _board.startPosAlien.y = newPos.y;
            _scene.startAlienSprite.hidden = NO;
        } else if (stat == BRUSH_FINISH) {
            // Update position of finish element.
            _board.finishPos.x = newPos.x;
            _board.finishPos.y = newPos.y;
        } else if (stat == BRUSH_ERASER) {
            // If a connection is on the position, first remove that one.
            NSLog(@"%f %f", point.x,point.y);
            BOOL removeConnection = [_scene removeAConnectionFrom:point];
            BOOL removeConnectionEndPoint = [_scene removeAConnectionBasedOnEndPoint:point];
            if(!removeConnection && !removeConnectionEndPoint) {
                [[_board elementDictionary] removeObjectForKey: flatIndex];
                [_scene removeOneSprite:flatIndex];
            }
            // If a connection was removed, update data model.
            if(removeConnection || removeConnectionEndPoint) {
                //Element *e = [[_board elementDictionary] objectForKey:flatIndex];
                [_connections removeConnection:point];
                [self updateConnectionsView];
            }
            
            // Remove starting positions.
            if(newPos.x == _board.startPosAlien.x && newPos.y == _board.startPosAlien.y) {
                _board.startPosAlien.x = -2;
                _board.startPosAlien.y = -2;

                [_scene setStartAlienPosition:CGPointMake(-2, -2)];
            }
            if(newPos.x == _board.startPosAstronaut.x && newPos.y == _board.startPosAstronaut.y) {
                _board.startPosAstronaut.x = -2;
                _board.startPosAstronaut.y = -2;
                [_scene setStartAstronautPosition:CGPointMake(-2, -2)];
            }
        } else if (stat == BRUSH_ROCK) {
            [_board addElementNamed:CLASS_BOX AtPosition:newPos IsBlocking:YES];
        } else if (stat == BRUSH_STAR) {
            [_board addElementNamed:CLASS_STAR AtPosition:newPos IsBlocking:NO];
        } else if (stat == BRUSH_STARBUTTON) {
            [_board addElementNamed:CLASS_STARBUTTON AtPosition:newPos IsBlocking:NO];
        } else if (stat == BRUSH_BRIDGE) {
            [_board addElementNamed:CLASS_BRIDGE AtPosition:newPos IsBlocking:YES];
        } else if (stat == BRUSH_BRIDGEBUTTON) {
            [_board addElementNamed:CLASS_BRIDGEBUTTON AtPosition:newPos IsBlocking:NO];
        } else if (stat == BRUSH_MOVING_PLATFORM) {
            [_board addElementNamed:CLASS_MOVING_PLATFORM AtPosition:newPos IsBlocking:NO];
        } else if (stat == BRUSH_LEVER) {
            [_board addElementNamed:CLASS_LEVER AtPosition:newPos IsBlocking:NO];
        }
    }
    
    // Adds feedback to the user if the board has been edited (adds a "*" at the end of the file name).
    if(edited == NO) {
        edited = YES;
        if([currentFilePath isEqualToString:@""]) {
            [[self window] setTitle:@"Untitled.splvl*"];
        } else {
            [[self window] setTitle: [[currentFilePath lastPathComponent] stringByAppendingString:@"*"]];
        }
    }
}

/* 
 *  Shows the connections in the view. */
-(void)updateConnectionsView {
    [_scene removeAllConnections];
    
    for(int i = 0; i < _connections.connections.count; i++) {
        Element *fr = [[[_connections connections] objectAtIndex:i] objectAtIndex:0];
        Element *t = [[[_connections connections] objectAtIndex:i] objectAtIndex:1];
        CGPoint from = CGPointMake(fr.x, fr.y);
        CGPoint to = CGPointMake(t.x, t.y);
        [_scene setAConnectionFrom:from To:to];
    }
}

/*
 *  Loads connections from the element collection (cleaning up before loading). Typically used when 
 *  a level is loaded. */
-(void)loadConnections {
    [_connections removeAllConnections];
    
    for (int i = 0; i < [[_board board] count]; i++) {
        BoardCoord *bc = [[_board board] objectAtIndex:i];
        for (int j = 0; j < bc.elements.count; j++) {
            Element *e = [bc.elements objectAtIndex:j];
            if([e isKindOfClass: [StarButton class]]) {
                StarButton *sb = (StarButton*)e;
                Element *to = (Element*)sb.star;
                if(sb.star) {
                    [_connections addConnectionFrom:e To:to];
                }
            } else if([e isKindOfClass:[BridgeButton class]]) {
                BridgeButton *bb = (BridgeButton*)e;
                Element *to = (Element*)bb.bridge;
                if(bb.bridge) {
                    [_connections addConnectionFrom:bb To:to];
                }
            } else if([e isKindOfClass:[PlatformLever class]]) {
                PlatformLever *pl = (PlatformLever*)e;
                Element *to = (Element*)pl.movingPlatform;
                if(pl.movingPlatform) {
                    [_connections addConnectionFrom:pl To:to];
                }
            }
        }
    }
}

-(void)loadPaths {
    
}

-(void)setupBoard {
    _board = [[Board alloc] init];
    // TEMP CODE.
    NSInteger boardSizeX = [_board boardSizeX];
    NSInteger boardSizeY = [_board boardSizeY];

    [_board createEmptyBoard];
    
    for(int i = 0; i < boardSizeY; i++) {
        for(int j = 0; j < boardSizeX; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:boardSizeX*i + j];
            //[[_scene setupBoardX:[bc x] Y:[bc y]];]
            [_scene setupBoardX:[bc x] Y:[bc y] TileSize:[_board tilesize] Status:[bc status]];
        }
    }
}

/*
 *  Loads a level. */
- (IBAction)openLevel:(id)sender {
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        
        // Loop through all the files and process them.
        for(int i = 0; i < [files count]; i++ )
        {
            NSURL* fileName = [files objectAtIndex:i];
            NSString *path = [fileName absoluteString];
            
            // Removes "file://" from the string, otherwise not valid path.
            path = [path substringFromIndex:7];
            // Get the extension of the file.
            NSString *extension = [path substringFromIndex:path.length-6];
            extension = [extension lowercaseString];
            // Only open .xml files.
            if([extension isEqualToString:@".splvl"]) {
                [_board loadBoard:path];
                currentFilePath = path;
                [self loadConnections];
                [self loadPaths];
                [self refreshView];
                // Updates the window's title.
                [[self window] setTitle:[path lastPathComponent]];
                // A newly opened file cannot be edited.
                [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:path]];
            } else {
                NSAlert *alert = [NSAlert alertWithMessageText:@"File is not a valid level!"
                                                 defaultButton:@"OK"
                                               alternateButton:@""
                                                   otherButton:nil
                                     informativeTextWithFormat:@"Level files must be of .splvl type."];
                [alert runModal];
            }
        }
    }
}

/*
 *  Called when "Save" is selected in the file menu. */
-(IBAction)saveLevel:(id)sender {
    // If the file that is worked on hasn't been saved before, open save panel.
    if([currentFilePath isEqualToString:@""]) {
        [self saveAsLevel:sender];
    }
    else {
        [_board saveBoard:currentFilePath];
        [[self window] setTitle:[currentFilePath lastPathComponent]];
        edited = NO;
    }
}

-(IBAction)newLevel:(id)sender {
    NSAlert *alert = [NSAlert alertWithMessageText:@"Are you sure you want to create a new level?"
                                     defaultButton:@"Yes"
                                   alternateButton:@"No"
                                       otherButton:nil
                         informativeTextWithFormat:@"Unsaved work will be lost."];
    if([alert runModal] == NSOKButton) {
        [_board createEmptyBoard];
        [self loadConnections];
        [self cleanView];
        currentFilePath = @"";
        [[self window] setTitle:@"Untitled.splvl"];
    }
}

/*
 *  Called when "Save as" is selected in the file menu. */
- (IBAction)saveAsLevel:(id)sender {
    // Create the File Open Dialog class.
    NSSavePanel* saveDlg = [NSSavePanel savePanel];
    
    // Enable the selection of files in the dialog.
    [saveDlg setCanCreateDirectories:YES];
    
    // Enable the selection of directories in the dialog.
    [saveDlg setCanSelectHiddenExtension:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ([saveDlg runModal] == NSOKButton) {
        NSURL *fileName = [saveDlg URL];
        NSString *path = [fileName absoluteString];
        
        // Removes "file://" from the string, otherwise not valid path.
        path = [path substringFromIndex:7];
        // Adds correct extension.
        
        NSString *extension = [path substringFromIndex:path.length-6];
        extension = [extension lowercaseString];
        // Only open .xml files.
        if([extension isEqualToString:@".splvl"]) {
            // Updates the window's title.
            [[self window] setTitle:[path lastPathComponent]];
            
        } else {
            // Updates the window's title.
            [[self window] setTitle:[[path lastPathComponent] stringByAppendingString:@".splvl"]];
            path = [path stringByAppendingString:@".splvl"];
        }
        [_board saveBoard:path];
        currentFilePath = path;
        edited = NO;
    }
}

-(void)observeText:(NSString *)text Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:text object:nil];
}

-(void)notifyText:(NSString *)text Object: (NSObject*)object Key: (NSString*)key {
    if(object) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:object forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:text object:nil
                                                          userInfo:userInfo];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:text object:nil];
    }
}

@end
