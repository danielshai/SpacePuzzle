//
//  GViewAppDelegate.m
//  SpacePuzzleEditor
//
//  Created by IxD on 11/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "GViewAppDelegate.h"
#import "BoardViewScene.h"

@implementation GViewAppDelegate

@synthesize window = _window;
@synthesize board = _board;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    SKScene *scene = [BoardViewScene sceneWithSize:CGSizeMake(480, 360)]; //480, 360

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

   // self.skView.showsFPS = YES;
   // self.skView.showsNodeCount = YES;
    
    [self setupBoard];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


-(void)setupBoard {
    // TEMP CODE.
    NSInteger boardSizeX = 7;
    NSInteger boardSizeY = 7;
    _board = [[Board alloc] init];
    // Load the board.
    NSString *levelNr = @"1";
    NSString *pathBoard = [NSString stringWithFormat:@"%@%@",@"BoardListLevel",levelNr];
    NSString *filePathBoard = [[NSBundle mainBundle] pathForResource:pathBoard
                                                              ofType:@"plist"];
    [_board loadBoard:filePathBoard];
    
    for(int i = 0; i < boardSizeY; i++) {
        for(int j = 0; j < boardSizeX; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:boardSizeX*i + j];
            //[_scene setupBoardX:[bc x] Y:[bc y]];
            // SHOW IT HERE
        }
    }
}

@end
