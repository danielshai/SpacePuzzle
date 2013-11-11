//
//  GViewMyScene.m
//  SpacePuzzleEditor
//
//  Created by IxD on 11/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "BoardViewScene.h"

@implementation BoardViewScene
@synthesize square = _square;
@synthesize unplayable = _unplayable;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.size = CGSizeMake(size.width, size.height);
        _square = [SKTexture textureWithImageNamed:@"square.gif"];
        _unplayable = [SKTexture textureWithImageNamed:@"grey.png"];
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
    //CGPoint location = [theEvent locationInNode:self];
    /*
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    sprite.position = CGPointMake(480, 360);
    sprite.scale = 0.5;
    
    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    
    [sprite runAction:[SKAction repeatActionForever:action]];
    
    [self addChild:sprite];
     */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)setupBoardX:(NSInteger)x Y:(NSInteger)y TileSize:(NSInteger)ts BeginPoint:(CGPoint)p Status:(NSInteger)status {
    SKSpriteNode *sprite;
    
    if(status == 0) {
        sprite = [SKSpriteNode spriteNodeWithTexture:_square];
    } else if(status == -2) {
        sprite = [SKSpriteNode spriteNodeWithTexture:_unplayable];
    }
    sprite.size = CGSizeMake(ts, ts);
    
    NSInteger xx = x*ts + p.x + ts/2;
    
    NSInteger yy = p.y - y*ts-ts/2 - 5;

    sprite.position = CGPointMake(xx,yy);
    [self addChild:sprite];
}

@end
