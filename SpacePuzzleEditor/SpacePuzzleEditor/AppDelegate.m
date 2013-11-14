//
//  GViewAppDelegate.m
//  SpacePuzzleEditor

#import "AppDelegate.h"
#import "BoardScene.h"
#import "XMLParser.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize skView = _skView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
 //   _window.acceptsMouseMovedEvents = YES;
   // [_window makeFirstResponder:self.skView.scene];
 
    /* Pick a size for the scene */
    _scene = [BoardScene sceneWithSize:CGSizeMake(360, 480)]; //480, 360
    
    /* Set the scale mode to scale to fit the window */
    _scene.scaleMode = SKSceneScaleModeAspectFit;

    [_skView presentScene:_scene];

    [self setupBoard];
    [self observeText:@"BoardEdited" Selector:@selector(boardEdited:)];
    [[self window] setTitle:@"Untitled.splvl"];
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

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
                [self refreshBoard];
            } else {
                NSAlert *alert = [NSAlert alertWithMessageText: @"File is not a valid level!\n\nLevel files must be of .splvl type."
                                                 defaultButton:@"OK"
                                               alternateButton:@""
                                                   otherButton:nil
                                     informativeTextWithFormat:@""];
                [alert runModal];
            }
        }
    }
}

/*
 *  Should be called when a new board has been loaded. This function updates the view of the changes. */
-(void)refreshBoard {
    NSInteger boardSizeX = [_board boardSizeX];
    NSInteger boardSizeY = [_board boardSizeY];
    
    for(int i = 0; i < boardSizeY; i++) {
        for(int j = 0; j < boardSizeX; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:boardSizeX*i + j];
            
            [_scene refreshBoardX:[bc x] Y:[bc y] Status:[bc status]];
        }
    }
}

-(IBAction)saveLevel:(id)sender {
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
        path = [path stringByAppendingString:@".splvl"];
        [_board saveBoard:path];
    }
}

- (IBAction)saveAsLevel:(id)sender {
    [self saveLevel:sender];
}


-(void)boardEdited:(NSNotification *) notification {

    NSDictionary *userInfo = notification.userInfo;
    NSSet *objectSent = [userInfo objectForKey:@"BoardEdited"];
    NSArray *data = [objectSent allObjects];
    NSValue *val = [data objectAtIndex:0];
   
    BoardCoord *bc = [[_board board] objectAtIndex:val.pointValue.y * BOARD_SIZE_X + val.pointValue.x];
    bc.status = [[data objectAtIndex:1] integerValue];
}

-(void)setupBoard {
    _board = [[Board alloc] init];
    // TEMP CODE.
    NSInteger boardSizeX = [_board boardSizeX];
    NSInteger boardSizeY = [_board boardSizeY];

    [_board createDefaultBoard];
    
    for(int i = 0; i < boardSizeY; i++) {
        for(int j = 0; j < boardSizeX; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:boardSizeX*i + j];
            //[[_scene setupBoardX:[bc x] Y:[bc y]];]
            [_scene setupBoardX:[bc x] Y:[bc y] TileSize:[_board tilesize] BeginPoint:[_board boardBegin] Status:[bc status]];
        }
    }
}

-(void)observeText:(NSString *)text Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:text object:nil];
}

@end
