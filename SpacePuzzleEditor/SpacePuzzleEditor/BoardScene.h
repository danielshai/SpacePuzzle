//
//  GViewMyScene.h
//  SpacePuzzleEditor
//
//  IMPORTANT: the tile graphics should include a border on each texture, so that the grid is visible.
#import <SpriteKit/SpriteKit.h>
#import "Converter.h"

@interface BoardScene : SKScene {
    NSInteger statusOfPalette;
    SKTexture *currentTexture;
}
@property (nonatomic, retain) SKTexture *solid;
@property (nonatomic, retain) SKTexture *voidTile;
@property (nonatomic, retain) SKTexture *crackedTile;
@property (nonatomic, retain) NSMutableArray *boardSprites;

-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y TileSize: (NSInteger) ts BeginPoint: (CGPoint) p
            Status: (NSInteger)status;
-(void)refreshBoardX: (NSInteger)x Y: (NSInteger)y Status: (NSInteger)status;
-(void)setTextureOfSprite: (SKSpriteNode*)sprite AccordingToStatus: (NSInteger)status;
-(void)solidClick;
-(void)crackedClick;
-(void)voidClick;
-(void)notifyText:(NSString *)text Object: (NSObject*)object Key: (NSString*)key;
-(void)changeTextureOfBrush:(NSInteger) status;
-(void)editABoardItem:(NSEvent *)theEvent;
-(void)observeText:(NSString *)text Selector:(SEL)selector;

@end
