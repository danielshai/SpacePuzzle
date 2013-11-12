//
//  GViewMyScene.h
//  SpacePuzzleEditor
//

//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Converter.h"

@interface BoardScene : SKScene {
    NSInteger statusOfPalette;
    SKTexture *currentTexture;
}
@property (nonatomic, retain) SKTexture *solid;
@property (nonatomic, retain) SKTexture *voidTile;
@property (nonatomic, retain) SKSpriteNode *highlight;
@property (nonatomic, retain) NSMutableArray *boardSprites;

-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y TileSize: (NSInteger) ts BeginPoint: (CGPoint) p
            Status: (NSInteger)status;
-(void)solidClick;
-(void)crackedClick;
-(void)voidClick;
-(void)notifyText:(NSString *)text Object: (NSObject*)object Key: (NSString*)key;
-(void)changeTextureOfBrush:(NSInteger) status;
-(void)editABoardItem:(NSEvent *)theEvent;
-(void)observeText:(NSString *)text Selector:(SEL)selector;

@end
