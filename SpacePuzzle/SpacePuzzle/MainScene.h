/*
    MainScene.h
    SpacePuzzle

    The main scene of the game, i.e. where the main game is shown.
 */

#import <SpriteKit/SpriteKit.h>
#import "Macros.h"
#import "Converter.h"

@interface MainScene : SKScene
@property (nonatomic, retain) SKTexture *solidTile;
@property (nonatomic, retain) SKTexture *crackedTile;
@property (nonatomic, retain) SKTexture *voidTile;
@property (nonatomic, retain) SKSpriteNode *bigL;
@property (nonatomic, retain) SKSpriteNode *littleJohn;
@property (nonatomic, retain) SKSpriteNode *currentUnit;
@property (nonatomic, retain) SKSpriteNode *bkg;
@property (nonatomic, retain) NSMutableDictionary *elements;

-(void)updateUnit:(CGPoint) coord;
-(void)updateElement:(CGPoint) oldCoord NewCoord:(CGPoint) newCoord;
-(void)removeElementAtPosition:(NSNumber*) index;
-(void)setupBoardX:(NSInteger)x Y: (NSInteger)y Status: (NSInteger) status;
-(void)setupElement:(CGPoint) coord Name: (NSString*) className;
-(void)setupUnits;
-(void)notifyText:(NSString *)text Object: (NSObject*)object Key: (NSString*)key;

@end
