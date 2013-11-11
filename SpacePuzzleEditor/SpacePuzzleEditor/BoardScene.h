//
//  GViewMyScene.h
//  SpacePuzzleEditor
//

//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Converter.h"

@interface BoardScene : SKScene {
    NSTrackingArea *tArea;
}
@property (nonatomic, retain) SKTexture *square;
@property (nonatomic, retain) SKTexture *unplayable;
@property (nonatomic, retain) SKSpriteNode *highlight;
-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y TileSize: (NSInteger) ts BeginPoint: (CGPoint) p
            Status: (NSInteger)status;
@end
