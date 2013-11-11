//
//  GViewMyScene.h
//  SpacePuzzleEditor
//

//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@interface BoardViewScene : SKScene
@property (nonatomic, retain) SKTexture *square;
@property (nonatomic, retain) SKTexture *unplayable;
-(void)setupBoardX: (NSInteger)x Y: (NSInteger)y TileSize: (NSInteger) ts BeginPoint: (CGPoint) p
            Status: (NSInteger)status;
@end
