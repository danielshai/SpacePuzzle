//
//  GViewMyScene.m
//  SpacePuzzleEditor
//
//  Created by IxD on 11/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "BoardScene.h"

@implementation BoardScene
@synthesize solid = _solid;
@synthesize voidTile = _voidTile;
@synthesize highlight = _highlight;
@synthesize boardSprites = _boardSprites;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.size = CGSizeMake(size.width, size.height);
        _solid = [SKTexture textureWithImageNamed:@"square.gif"];
        _voidTile = [SKTexture textureWithImageNamed:@"grey.png"];
        _highlight = [SKSpriteNode spriteNodeWithImageNamed:@"hl.png"];
        _highlight.size = CGSizeMake(40, 40);
        _boardSprites = [[NSMutableArray alloc] init];
        statusOfPalette = MAPSTATUS_SOLID;
        currentTexture = _solid;
        [self observeText:@"SolidClick" Selector:@selector(solidClick)];
        [self observeText:@"VoidClick" Selector:@selector(voidClick)];
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
    [self editABoardItem:theEvent];
}

-(void)mouseDragged:(NSEvent *)theEvent {
    [self editABoardItem:theEvent];
}

/*
 *  Changes one tile on the board according to what brush is used and notifuies observers that the view
 *  has changed. */
-(void)editABoardItem:(NSEvent *)theEvent {
    // Find mouse location and convert.
    SKView *sk = self.view;
    NSPoint mouseLoc = [sk convertPoint:[theEvent locationInWindow] fromView:nil];
    CGPoint loc = CGPointMake(mouseLoc.x*360/(sk.frame.size.width), mouseLoc.y*480/(sk.frame.size.height));
    
    loc = [Converter convertMousePosToCoord:loc];
    
    if(loc.x >= 0 && loc.x < BOARD_SIZE_X && loc.y >= 0 && loc.y < BOARD_SIZE_Y) {
        // Notify observers.
        NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithPoint:loc],nil];
        [self notifyText:@"BoardEdited" Object:arr Key:@"BoardEdited"];
    
        // Change texture of sprite.
        SKSpriteNode * s = [_boardSprites objectAtIndex:loc.y * BOARD_SIZE_X + loc.x];
        s.texture = currentTexture;
    }
}

-(void)solidClick {
    [self changeTextureOfBrush:MAPSTATUS_SOLID];
}

-(void)crackedClick {
    [self changeTextureOfBrush:MAPSTATUS_CRACKED];
}

-(void)voidClick {
    [self changeTextureOfBrush:MAPSTATUS_VOID];
}

-(void)changeTextureOfBrush:(NSInteger)status {
    if(status == MAPSTATUS_SOLID) {
        currentTexture = _solid;
        statusOfPalette = status;
    } else if(status == MAPSTATUS_VOID) {
        currentTexture = _voidTile;
        statusOfPalette = status;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)setupBoardX:(NSInteger)x Y:(NSInteger)y TileSize:(NSInteger)ts BeginPoint:(CGPoint)p
            Status:(NSInteger)status {
    SKSpriteNode *sprite;
    
    if(status == MAPSTATUS_SOLID) {
        sprite = [SKSpriteNode spriteNodeWithTexture:_solid];
    } else if(status == MAPSTATUS_VOID) {
        sprite = [SKSpriteNode spriteNodeWithTexture:_voidTile];
    }
    NSLog(@"loaded");
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

-(void)observeText:(NSString *)text Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:text object:nil];
}


@end
