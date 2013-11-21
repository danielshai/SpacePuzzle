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
@property (nonatomic, retain) SKTexture *buttonOn;
@property (nonatomic, retain) SKTexture *buttonOff;
@property (nonatomic, retain) SKSpriteNode *bigL;
@property (nonatomic, retain) SKSpriteNode *littleJohn;
@property (nonatomic, retain) SKSpriteNode *currentUnit;
@property (nonatomic, retain) SKSpriteNode *bkg;
@property (nonatomic, retain) NSMutableDictionary *elements;
@property (nonatomic, retain) NSMutableArray *tiles;

-(void)updateUnit:(CGPoint) coord;
-(void)refreshTileAtPosition: (CGPoint)pos WithStatus: (NSInteger)status;
-(void)refreshTileAtFlatIndex: (NSInteger)findex WithStatus:(NSInteger)status;
-(void)refreshElementAtPoistion: (NSNumber*)index OfClass:(NSString*)name WithStatus:(BOOL)on;
-(void)moveElement: (CGPoint)oldCoord NewCoord: (CGPoint)newCoord;
-(void)removeElementAtPosition: (NSNumber*)index;
-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y Status: (NSInteger)status;
-(void)setupElement: (CGPoint)coord Name: (NSString*)className;
-(void)setupUnits: (CGPoint)pos;
-(void)notifyText: (NSString *)text Object: (NSObject*)object Key: (NSString*)key;

@end
