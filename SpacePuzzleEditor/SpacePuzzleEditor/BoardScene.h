//
//  GViewMyScene.h
//  SpacePuzzleEditor
//
//  IMPORTANT: the tile graphics should include a border on each texture, so that the grid is visible.
#import <SpriteKit/SpriteKit.h>
#import "Converter.h"

@interface BoardScene : SKScene {
    NSInteger statusOfPalette;
    NSInteger lastDirChange;
    NSInteger lastDir;
    NSInteger firstDir;
    SKTexture *currentTexture;
    BOOL controlClickDrag;
    BOOL pathDrag;
    BOOL dirChange;
    BOOL redInRainbowUp;
    CGPoint startControlDrag;
    CGPoint endControlDrag;
    CGPoint startPathLine;
    NSMutableArray *pathNodes;
    NSMutableArray *rainbowSprites;
    SKShapeNode *controlDragLine;
    SKShapeNode *controlDragOutline;
    SKShapeNode *circle;
    SKShapeNode *circleOutline;
    SKSpriteNode *pathHover;
    SKTexture *rainbowStraight;
    SKTexture *rainbowLeftTurn;
    SKTexture *rainbowRightTurn;
}
@property (nonatomic, retain) SKTexture *solid;
@property (nonatomic, retain) SKTexture *voidTile;
@property (nonatomic, retain) SKTexture *crackedTile;
@property (nonatomic, retain) SKTexture *startAstronautTxt;
@property (nonatomic, retain) SKTexture *startAlienTxt;
@property (nonatomic, retain) SKTexture *finishElement;
@property (nonatomic, retain) SKTexture *rockTexture;
@property (nonatomic, retain) SKTexture *starTexture;
@property (nonatomic, retain) SKTexture *buttonTexture;
@property (nonatomic, retain) SKTexture *bridgeButtonTexture;
@property (nonatomic, retain) SKTexture *bridgeTexture;
@property (nonatomic, retain) SKTexture *leverTexture;
@property (nonatomic, retain) SKTexture *platformTexture;
@property (nonatomic, retain) SKSpriteNode *bkg;
@property (nonatomic, retain) SKSpriteNode *startAstronautSprite;
@property (nonatomic, retain) SKSpriteNode *startAlienSprite;
@property (nonatomic, retain) SKSpriteNode *finishSprite;
@property (nonatomic, retain) SKSpriteNode *controlHover;
@property (nonatomic, retain) NSMutableArray *boardSprites;
@property (nonatomic, retain) NSMutableDictionary *elementSprites;
@property (nonatomic, retain) NSMutableDictionary *connectionNodes;

-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y TileSize: (NSInteger) ts Status: (NSInteger)status;
-(void)refreshBoardX: (NSInteger)x Y: (NSInteger)y Status: (NSInteger)status;
-(void)refreshStartAstro: (CGPoint)startAstro StartAlien: (CGPoint)startAlien Finish: (CGPoint) finish;
-(void)addElement: (NSInteger)brush Position: (CGPoint)pos;
-(void)setAConnectionFrom: (CGPoint) from To: (CGPoint) to;
-(void)removeAllConnections;
-(BOOL)removeAConnectionFrom: (CGPoint)from;
-(BOOL)removeAConnectionFrom: (CGPoint)from To: (CGPoint)to;
-(BOOL)isPointAConnectionEndPoint: (CGPoint) loc;
-(BOOL)removeAConnectionBasedOnEndPoint: (CGPoint) loc;
-(void)removeAllPaths;
-(void)addAPath:(NSMutableArray*) path;
-(void)cleanElements;
-(void)cleanView;
-(void)setTextureOfSprite: (SKSpriteNode*)sprite AccordingToStatus: (NSInteger)status;
-(void)removeOneSprite: (NSNumber*) index;
-(void)solidClick;
-(void)crackedClick;
-(void)voidClick;
-(void)startClick;
-(void)finishClick;
-(void)rockClick;
-(void)starClick;
-(void)eraserClick;
-(void)starButtonClick;
-(void)bridgeButtonClick;
-(void)bridgeClick;
-(void)platformClick;
-(void)leverClick;
-(void)alienClick;
-(void)drawControlLine;
-(void)drawRainbowAtPosition: (CGPoint)p WithDirection: (NSInteger)dir;
-(void)addRainbowSpriteAtPosition: (CGPoint)p Rotation: (CGFloat)r Texture: (SKTexture*)texture;
-(void)drawPathLineFrom: (CGPoint)from To: (CGPoint)to InDirection: (NSInteger)dir
      WithLastDirection: (NSInteger)lastDir;
-(void)highlightElement: (CGPoint) elementIndex;
-(void)pathHighlight: (CGPoint)pos;
-(void)noHighlight;
-(void)notifyText:(NSString *)text Object: (NSObject*)object Key: (NSString*)key;
-(void)changeTextureOfBrush:(NSInteger) status;
-(void)editABoardItem:(NSEvent *)theEvent;
-(void)observeText:(NSString *)text Selector:(SEL)selector;
-(void)addAStar:(CGPoint) pos Index: (NSNumber*) index;
-(void)addARock:(CGPoint) pos Index: (NSNumber*) index;
-(void)addABridge:(CGPoint) pos Index: (NSNumber*) index;
-(void)addAStarButton:(CGPoint) pos Index: (NSNumber*) index;
-(void)addABridgeButton:(CGPoint) pos Index: (NSNumber*) index;
-(void)addAPlatform:(CGPoint) pos Index: (NSNumber*) index;
-(void)addALever:(CGPoint) pos Index: (NSNumber*) index;
-(NSInteger)classToBrush: (NSString*)className;
-(void)setStartAlienPosition: (CGPoint)p;
-(void)setStartAstronautPosition: (CGPoint)p;
@end
