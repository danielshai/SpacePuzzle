//
//  GViewAppDelegate.m
//  SpacePuzzleEditor

#import "AppDelegate.h"
#import "BoardScene.h"
#import "XMLParser.h"
#import "Element.h"
#import "StarButton.h"
#import "Connections.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize skView = _skView;
@synthesize recentMenu = _recentMenu;
@synthesize controlPanel = _controlPanel;
@synthesize connections = _connections;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
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
    [[self window] setTitle:@"Untitled.splvl"];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
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
    
    Element *eStart = [[_board elementDictionary] objectForKey:indexStart];
    Element *eEnd = [[_board elementDictionary] objectForKey:indexEnd];
    
    if(eStart && eEnd) {
        if([NSStringFromClass([eStart class]) isEqualToString:CLASS_STARBUTTON] &&
           [NSStringFromClass([eEnd class]) isEqualToString:CLASS_STAR]) {
            // A |StarButton| connecting to a |Star|.
            // Tell the scene to highlight star.
            CGPoint p = CGPointMake(endPoint.pointValue.x, endPoint.pointValue.y);
            [_scene highlightElement:p];
        } else {
            // No highlight should be presented, since the elements cannot be connected.
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
    
    Element *eStart = [[_board elementDictionary] objectForKey:indexStart];
    Element *eEnd = [[_board elementDictionary] objectForKey:indexEnd];
    
    if(eStart && eEnd) {
        // Check class for highlighting purpose.
        if([NSStringFromClass([eStart class]) isEqualToString:CLASS_STARBUTTON] &&
           [NSStringFromClass([eEnd class]) isEqualToString:CLASS_STAR]) {
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

-(void)showControlPanel:(NSNotification *) notification {
    // Get the data (location of click).
    NSDictionary *userInfo = notification.userInfo;
    NSSet *objectSent = [userInfo objectForKey:@"ControlPanel"];
    NSArray *data = [objectSent allObjects];
    // Edited at coordinate.
    NSValue *val = [data objectAtIndex:0];
    NSNumber *index = [NSNumber numberWithInteger:val.pointValue.y*BOARD_SIZE_X + val.pointValue.x];
    
    Element *e = [[_board elementDictionary] objectForKey:index];
 
    if([NSStringFromClass([e class]) isEqualToString:@"StarButton"]) {
        // Open properties window. Set some size and position.
        [_controlPanel makeKeyAndOrderFront:self];
        NSRect frame = [[self window] frame];
        CGPoint p = frame.origin;
        CGSize s = frame.size;
        s.height -= 200;
        s.width -= 10;
        p.x += 5;
        p.y += 100;
        frame.size = s;
        frame.origin = p;
        [_controlPanel setFrame:frame display:YES animate:YES];
    }
}

- (IBAction)newLevel:(id)sender {
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
}

-(void)cleanView {
    [self refreshBoardView];
    [self refreshElementView];
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

-(void)refreshElementView {
    CGPoint s = CGPointMake(_board.startPos.x, _board.startPos.y);
    CGPoint f = CGPointMake(_board.finishPos.x, _board.finishPos.y);
    [_scene refreshElementsStart:s Finish:f];
    
    [_scene cleanElements];
    for(id key in [_board elementDictionary]) {
        Element *e = [[_board elementDictionary] objectForKey:key];
        CGPoint pos = CGPointMake(e.x, e.y);
        [_scene addElement:e.className Position:pos];
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
    NSNumber *flatIndex = [NSNumber numberWithInt:val.pointValue.y * BOARD_SIZE_X + val.pointValue.x];
    // If the change was on a tile, the |BoardCoord| status should change. Otherwise elements should change.
    if(stat == MAPSTATUS_SOLID || stat== MAPSTATUS_CRACKED || stat == MAPSTATUS_VOID) {
        BoardCoord *bc = [[_board board] objectAtIndex:val.pointValue.y * BOARD_SIZE_X + val.pointValue.x];
        bc.status = stat;
    } else {
        CGPoint newPos = CGPointMake(val.pointValue.x, val.pointValue.y);

        if(stat == BRUSH_START) {
            // Update position of start element.
            _board.startPos.x = newPos.x;
            _board.startPos.y = newPos.y;
        } else if (stat == BRUSH_FINISH) {
            // Update position of finish element.
            _board.finishPos.x = newPos.x;
            _board.finishPos.y = newPos.y;
        } else if (stat == BRUSH_ERASER) {
            // If a connection is on the position, first remove that one.
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
        } else if (stat == BRUSH_ROCK) {
            [_board addElementNamed:CLASS_BOX AtPosition:newPos IsBlocking:YES];
        } else if (stat == BRUSH_STAR) {
            [_board addElementNamed:CLASS_STAR AtPosition:newPos IsBlocking:NO];
        } else if (stat == BRUSH_STARBUTTON) {
            [_board addElementNamed:CLASS_STARBUTTON AtPosition:newPos IsBlocking:NO];
        } else if(stat == BRUSH_BRIDGE) {
            [_board addElementNamed:CLASS_BRIDGE AtPosition:newPos IsBlocking:YES];
        }
    }
    
    // Adds feedback to the user if the board has been edited (adds a * at the end of the file name).
    if(edited == NO) {
        edited = YES;
        if([currentFilePath isEqualToString:@""]) {
            [[self window] setTitle:@"Untitled.splvl*"];
        } else {
            [[self window] setTitle: [[currentFilePath lastPathComponent] stringByAppendingString:@"*"]];
        }
    }
}

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
 *  Loads connections from the element collection. Typically used when a level is loaded. */
-(void)loadConnections {
    [_connections removeAllConnections];
    for(id key in [_board elementDictionary]) {
        Element *e = [[_board elementDictionary] objectForKey:key];
        
        if([e isKindOfClass: [StarButton class]]) {
            StarButton *sb = (StarButton*)e;
            Element *to = (Element*)sb.star;
            if(sb.star) {
                [_connections addConnectionFrom:e To:to];
            }
        }
    }
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
                [self refreshView];
                // Updates the window's title.
                [[self window] setTitle:[path lastPathComponent]];
                // A newly opened file cannot be edited.
                [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:path]];
            } else {
                NSAlert *alert = [NSAlert alertWithMessageText: @"File is not a valid level!"
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
