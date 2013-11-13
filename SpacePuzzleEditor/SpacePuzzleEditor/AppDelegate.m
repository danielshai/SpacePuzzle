//
//  GViewAppDelegate.m
//  SpacePuzzleEditor
//
//  Created by IxD on 11/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "AppDelegate.h"
#import "BoardScene.h"
#import "XMLParser.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize skView = _skView;
@synthesize parser = _parser;
/*
 @synthesize solidPalette = _solidPalette;
 @synthesize crackedPalette = _crackedPalette;
 @synthesize voidPalette = _voidPalette;
 */

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
 //   _window.acceptsMouseMovedEvents = YES;
   // [_window makeFirstResponder:self.skView.scene];
 
    /* Pick a size for the scene */
    _scene = [BoardScene sceneWithSize:CGSizeMake(360, 480)]; //480, 360
    
    /* Set the scale mode to scale to fit the window */
    _scene.scaleMode = SKSceneScaleModeAspectFit;

    [_skView presentScene:_scene];
    
    NSURL *path = [[NSURL alloc] initFileURLWithPath:@"/Users/IxD/SpacePuzzle/SpacePuzzleEditor/SpacePuzzleEditor/test.xml"];
    NSLog(@"%@",path.path);
    _parser = [[XMLParser alloc] initWithContentsOfURL:path];
    [self setupBoard];
    [self observeText:@"BoardEdited" Selector:@selector(boardEdited:)];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (IBAction)openLevel:(id)sender {
    int i; // Loop counter.
    
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg filenames];
        
        // Loop through all the files and process them.
        for( i = 0; i < [files count]; i++ )
        {
            NSString* fileName = [files objectAtIndex:i];
            
            // Do something with the filename.
        }
    }
}

- (IBAction)saveLevel:(id)sender {
    NSLog(@"saved");
    
}

-(void)boardEdited:(NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    NSSet *objectSent = [userInfo objectForKey:@"MouseDown"];
    NSArray *touchList = [objectSent allObjects];
    NSValue *val = [touchList objectAtIndex:0];
   
    BoardCoord *bc = [[_board board] objectAtIndex:val.pointValue.y * BOARD_SIZE_X + val.pointValue.x];
    bc.status = 0;
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
