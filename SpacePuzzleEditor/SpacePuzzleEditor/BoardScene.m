//
//  GViewMyScene.m
//  SpacePuzzleEditor
//
//  Created by IxD on 11/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "BoardScene.h"

@implementation BoardScene
@synthesize square = _square;
@synthesize unplayable = _unplayable;
@synthesize highlight = _highlight;
@synthesize boardSprites = _boardSprites;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.size = CGSizeMake(size.width, size.height);
        _square = [SKTexture textureWithImageNamed:@"square.gif"];
        _unplayable = [SKTexture textureWithImageNamed:@"grey.png"];
        _highlight = [SKSpriteNode spriteNodeWithImageNamed:@"hl.png"];
        _highlight.size = CGSizeMake(40, 40);
        _boardSprites = [[NSMutableArray alloc] init];
        statusOfPalette = MAPSTATUS_EMPTY;
        currentTexture = _square;
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
    
    // Find mouse location and convert.
    SKView *sk = self.view;
    NSPoint mouseLoc = [sk convertPoint:[theEvent locationInWindow] fromView:nil];
    CGPoint loc = CGPointMake(mouseLoc.x*360/(sk.frame.size.width), mouseLoc.y*480/(sk.frame.size.height));
    
    loc = [Converter convertMousePosToCoord:loc];
    
    // Notify observers.
    NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithPoint:loc],nil];
    [self notifyText:@"MouseDown" Object:arr Key:@"MouseDown"];
    
    // Change texture of sprite.
    SKSpriteNode * s = [_boardSprites objectAtIndex:loc.y * BOARD_SIZE_X + loc.x];
    s.texture = currentTexture;
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
    [_boardSprites addObject:sprite];
    [self addChild:sprite];
}

-(void) notifyText:(NSString *)text Object:(NSObject *)object Key:(NSString *)key {
    if(object) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:object forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:text object:nil
                                                          userInfo:userInfo];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:text object:nil];
    }
}

@end
