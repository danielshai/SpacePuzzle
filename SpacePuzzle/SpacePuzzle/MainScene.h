/*
    MainScene.h
    SpacePuzzle

    The main scene of the game, i.e. where the main game is shown.
 */

#import <SpriteKit/SpriteKit.h>
#import "Macros.h"
#import "Converter.h"

@class Element;
@class SpacePuzzleController;

@interface MainScene : SKScene {
    NSMutableArray *takenStarsArray;
}
@property (nonatomic, retain) SpacePuzzleController *controller;
@property (nonatomic, retain) SKTexture *solidTile;
@property (nonatomic, retain) SKTexture *crackedTile;
@property (nonatomic, retain) SKTexture *voidTile;
@property (nonatomic, retain) SKTexture *buttonOn;
@property (nonatomic, retain) SKTexture *buttonOff;
@property (nonatomic, retain) SKTexture *bridgeOn;
@property (nonatomic, retain) SKTexture *bridgeOff;
@property (nonatomic, retain) SKTexture *switchOn;
@property (nonatomic, retain) SKTexture *switchOff;
@property (nonatomic, retain) SKTexture *movingPlatform;
@property (nonatomic, retain) SKTexture *star;
@property (nonatomic, retain) SKTexture *box;
@property (nonatomic, retain) SKTexture *guiAstro;
@property (nonatomic, retain) SKTexture *guiAlien;
@property (nonatomic, retain) SKTexture *smBox;

@property (nonatomic, retain) SKSpriteNode *bigL;
@property (nonatomic, retain) SKSpriteNode *littleJohn;
@property (nonatomic, retain) SKSpriteNode *currentUnit;
@property (nonatomic, retain) SKSpriteNode *bkg;
@property (nonatomic, retain) SKSpriteNode *finish;
@property (nonatomic, retain) SKSpriteNode *gui;

@property (nonatomic, retain) NSMutableDictionary *elements;
@property (nonatomic, retain) NSMutableArray *tiles;
@property (nonatomic, retain) SKAction *sequence;
@property (nonatomic, retain) SKAction *moveTo;

@property (nonatomic, retain) SKAction *bWUp;
@property (nonatomic, retain) SKAction *bWDown;
@property (nonatomic, retain) SKAction *bWRight;
@property (nonatomic, retain) SKAction *bWLeft;
@property (nonatomic, retain) SKAction *lWUp;
@property (nonatomic, retain) SKAction *lWDown;
@property (nonatomic, retain) SKAction *lWRight;
@property (nonatomic, retain) SKAction *lWLeft;
@property (nonatomic, retain) SKAction *mBox;
@property (nonatomic, retain) SKAction *mStar;
@property (nonatomic, retain) SKAction *tStar;
@property (nonatomic, retain) SKAction *sBox;

//@property (nonatomic, retain) SKEmitterNode *myParticle;


-(void)updateUnit:(CGPoint) coord inDirection:(NSInteger) direction;
-(void)updateElementsAtPosition: (CGPoint)pos withArray: (NSMutableArray *)elArr;
-(void)refreshTileAtPosition: (CGPoint)pos WithStatus: (NSInteger)status;
-(void)refreshTileAtFlatIndex: (NSInteger)findex WithStatus:(NSInteger)status;
-(void)refreshElementAtPosition: (NSNumber*)index OfClass:(NSString*)name WithStatus:(BOOL)on;
-(void)setElementAtPosition: (NSNumber*) index IsHidden: (BOOL)hidden;
-(void)unitFallingAnimation: (NSInteger)unit;
-(void)moveElementFrom: (CGPoint)oldCoord WithIndex: (NSInteger)elementIndex To: (CGPoint)newCoord OntoStatus:(NSInteger)status InDir:(NSInteger)direction;
-(void)smashBox: (Element*)box;
-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y Status: (NSInteger)status;
-(void)setupElement: (CGPoint)coord Name: (NSString*)className Hidden: (BOOL)hidden;
-(void)setupAstronaut: (CGPoint)pos;
-(void)setupAlien: (CGPoint)pos;
-(void)notifyText: (NSString *)text Object: (NSObject*)object Key: (NSString*)key;
-(void)changeUnit;
-(void)setCurrentUnitWithMacro: (NSInteger)unit;
-(void)cleanScene;
-(void)starTakenAtPosition: (Element*)star CurrentTaken:(NSInteger)taken;
-(SKTexture*)getTextureForElement: (Element*)e;
-(CGFloat)getZPositionForElement: (Element*)e;
-(SKTexture*)updateSpriteWith:(NSString *) name State: (BOOL)state;
-(CGSize)sizeForElement: (Element*)e;

@end
