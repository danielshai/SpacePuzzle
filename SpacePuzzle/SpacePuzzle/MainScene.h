/*
    MainScene.h
    SpacePuzzle

    The main scene of the game, i.e. where the main game is shown.
 */

#import <SpriteKit/SpriteKit.h>

@interface MainScene : SKScene
@property (nonatomic, assign) SKTexture *square;
-(void)renderBoardX:(NSInteger) x Y: (NSInteger) y;

@end
