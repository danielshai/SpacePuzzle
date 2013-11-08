//
//  GViewViewController.m
//  SpacePuzzle

#import "SpacePuzzleController.h"
#import "MainScene.h"

@implementation SpacePuzzleController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    MainScene *scene = [MainScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    // TEMP CODE.
    Board *board = [[Board alloc] init];
    // Load the board.
    NSString *levelNr = @"1";
    NSString *pathBoard = [NSString stringWithFormat:@"%@%@",@"BoardListLevel",levelNr];
    NSString *filePathBoard = [[NSBundle mainBundle] pathForResource:pathBoard
                                                              ofType:@"plist"];
    [board loadBoard:filePathBoard];
    
    for(int i = 0; i < BOARD_SIZE_Y; i++) {
        for(int j = 0; j < BOARD_SIZE_X; j++) {
            BoardCoord *bc = [board.board objectAtIndex:BOARD_SIZE_X*i + j];
            [scene renderBoardX:[bc x] Y:[bc y]];
        }
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
