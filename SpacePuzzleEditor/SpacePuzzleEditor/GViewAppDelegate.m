//
//  GViewAppDelegate.m
//  SpacePuzzleEditor
//
//  Created by IxD on 11/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "GViewAppDelegate.h"
#import "BoardScene.h"

@implementation GViewAppDelegate

@synthesize window = _window;
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize skView = _skView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
 //   _window.acceptsMouseMovedEvents = YES;
   // [_window makeFirstResponder:self.skView.scene];
 
    /* Pick a size for the scene */
    _scene = [BoardScene sceneWithSize:CGSizeMake(480, 360)]; //480, 360
    
    /* Set the scale mode to scale to fit the window */
    _scene.scaleMode = SKSceneScaleModeAspectFit;

    [_skView presentScene:_scene];
  //  [_skView add
   // self.skView.showsFPS = YES;
   // self.skView.showsNodeCount = YES;
 
    [self setupBoard];
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(void)mouseDownAtPosition:(CGPoint)pos {
    NSLog(@"%f", pos.x);
}

-(void)setupBoard {
    _board = [[Board alloc] init];
    // TEMP CODE.
    NSInteger boardSizeX = [_board boardSizeX];
    NSInteger boardSizeY = [_board boardSizeY];

    // Load the board.
    NSString *levelNr = @"1";
    NSString *pathBoard = [NSString stringWithFormat:@"%@%@",@"BoardListLevel",levelNr];
    NSString *filePathBoard = [[NSBundle mainBundle] pathForResource:pathBoard
                                                              ofType:@"plist"];
    [_board loadBoard:filePathBoard];
    
    for(int i = 0; i < boardSizeY; i++) {
        for(int j = 0; j < boardSizeX; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:boardSizeX*i + j];
            //[[_scene setupBoardX:[bc x] Y:[bc y]];]
            [_scene setupBoardX:[bc x] Y:[bc y] TileSize:[_board tilesize] BeginPoint:[_board boardBegin] Status:[bc status]];
            // SHOW IT HERE
        }
    }
}

@end
