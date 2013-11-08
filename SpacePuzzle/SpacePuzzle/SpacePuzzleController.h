/*
    GViewViewController.h
    SpacePuzzle

    Controller for the main game scene.
    ADD LEVELFACTORY.
*/

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "Board.h"
#import "Macros.h"
#import "MainScene.h"

@interface SpacePuzzleController : UIViewController
@property (nonatomic, retain) Board *board;
@property (nonatomic, assign) MainScene *scene;
-(void) setupBoard;
@end
