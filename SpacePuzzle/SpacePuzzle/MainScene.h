/*
    MainScene.h
    SpacePuzzle

    The main scene of the game, i.e. where the main game is shown.
 */

#import <SpriteKit/SpriteKit.h>
#import "Macros.h"
#import "Converter.h"

@class AnimationFactory;

@interface MainScene : SKScene
@property (nonatomic, retain) SKTexture *solidTile;
@property (nonatomic, retain) SKTexture *crackedTile;
@property (nonatomic, retain) SKTexture *voidTile;
@property (nonatomic, retain) SKTexture *buttonOn;
@property (nonatomic, retain) SKTexture *buttonOff;
@property (nonatomic, retain) SKTexture *bridgeOn;
@property (nonatomic, retain) SKTexture *bridgeOff;
@property (nonatomic, retain) SKTexture *switchOn;
@property (nonatomic, retain) SKTexture *switchOff;
@property (nonatomic, retain) SKSpriteNode *bigL;
@property (nonatomic, retain) SKSpriteNode *littleJohn;
@property (nonatomic, retain) SKSpriteNode *currentUnit;
@property (nonatomic, retain) SKSpriteNode *bkg;
@property (nonatomic, retain) NSMutableDictionary *elements;
@property (nonatomic, retain) NSMutableArray *tiles;
@property (nonatomic, retain) SKTexture *bigLUp;
@property (nonatomic, retain) SKTexture *bigLDown;
@property (nonatomic, retain) SKTexture *bigLRight;
@property (nonatomic, retain) SKTexture *bigLLeft;
@property (nonatomic, retain) SKTexture *littleJohnUp;
@property (nonatomic, retain) SKTexture *littleJohnDown;
@property (nonatomic, retain) SKTexture *littleJohnRight;
@property (nonatomic, retain) SKTexture *littleJohnLeft;
@property (nonatomic, retain) SKAction *sequence;
@property (nonatomic, retain) AnimationFactory *aniFact;

@property (nonatomic, retain) SKAction *bWUp;
@property (nonatomic, retain) SKAction *bWDown;
@property (nonatomic, retain) SKAction *bWRight;
@property (nonatomic, retain) SKAction *bWLeft;
@property (nonatomic, retain) SKAction *lWUp;
@property (nonatomic, retain) SKAction *lWDown;
@property (nonatomic, retain) SKAction *lWRight;
@property (nonatomic, retain) SKAction *lWLeft;


-(void)updateUnit:(CGPoint) coord inDirection:(NSInteger) direction;
-(void)refreshTileAtPosition: (CGPoint)pos WithStatus: (NSInteger)status;
-(void)refreshTileAtFlatIndex: (NSInteger)findex WithStatus:(NSInteger)status;
-(void)refreshElementAtPosition: (NSNumber*)index OfClass:(NSString*)name WithStatus:(BOOL)on;
-(void)setElementAtPosition: (NSNumber*) index IsHidden: (BOOL)hidden;
-(void)moveElement: (CGPoint)oldCoord NewCoord: (CGPoint)newCoord;
-(void)removeElementAtPosition: (NSNumber*)index;
-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y Status: (NSInteger)status;
-(void)setupElement: (CGPoint)coord Name: (NSString*)className Hidden: (BOOL)hidden;
-(void)setupUnits: (CGPoint)pos;
-(void)notifyText: (NSString *)text Object: (NSObject*)object Key: (NSString*)key;
-(void)changeUnit;
-(SKTexture*)updateSpriteWith:(NSString *) name State: (BOOL)state;

@end
