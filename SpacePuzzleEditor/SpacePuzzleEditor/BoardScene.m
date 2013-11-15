//
//  GViewMyScene.m
//  SpacePuzzleEditor
//

#import "BoardScene.h"

@implementation BoardScene
@synthesize solid = _solid;
@synthesize voidTile = _voidTile;
@synthesize crackedTile = _crackedTile;
@synthesize boardSprites = _boardSprites;
@synthesize bkg = _bkg;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
        self.size = CGSizeMake(size.width, size.height);
        _solid = [SKTexture textureWithImageNamed:@"solidtile.png"];
        _voidTile = [SKTexture textureWithImageNamed:@"voidtile.png"];
        _crackedTile = [SKTexture textureWithImageNamed:@"crackedtile.jpg"];
        _bkg = [SKSpriteNode spriteNodeWithImageNamed:@"Background.png"];
     
        _bkg.size = CGSizeMake(size.width, size.height);
        _bkg.position = CGPointMake(WIN_SIZE_X/2, WIN_SIZE_Y/2);
        [self addChild:_bkg];

        NSLog(@"%f", self.size.height);
        _boardSprites = [[NSMutableArray alloc] init];
        statusOfPalette = MAPSTATUS_SOLID;
        currentTexture = _solid;
        
        [self observeText:@"SolidClick" Selector:@selector(solidClick)];
        [self observeText:@"VoidClick" Selector:@selector(voidClick)];
        [self observeText:@"CrackedClick" Selector:@selector(crackedClick)];
    }
    return self;
}

-(void)mouseDown:(NSEvent *)theEvent {
    [self editABoardItem:theEvent];
}

-(void)mouseDragged:(NSEvent *)theEvent {
    [self editABoardItem:theEvent];
}

-(void)keyDown:(NSEvent *)theEvent {
    
}

/*
 *  Changes one tile on the board according to what brush is used and notifies observers that the view
 *  has changed. */
-(void)editABoardItem:(NSEvent *)theEvent {
    // Find mouse location and convert.
    SKView *sk = self.view;
    NSPoint mouseLoc = [sk convertPoint:[theEvent locationInWindow] fromView:nil];
    CGPoint loc = CGPointMake(mouseLoc.x*WIN_SIZE_X/(sk.frame.size.width), mouseLoc.y*WIN_SIZE_Y/(sk.frame.size.height));
    
    loc = [Converter convertMousePosToCoord:loc];
    
    // Check if the click was inside the board.
    if(loc.x >= 0 && loc.x < BOARD_SIZE_X && loc.y >= 0 && loc.y < BOARD_SIZE_Y) {
        // Notify observers.
        
        NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithPoint:loc],
                                                 [NSNumber numberWithInteger: statusOfPalette],nil];
        [self notifyText:@"BoardEdited" Object:arr Key:@"BoardEdited"];
    
        // Change texture of sprite.
        SKSpriteNode *s = [_boardSprites objectAtIndex:loc.y * BOARD_SIZE_X + loc.x];
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
    } else if(status == MAPSTATUS_CRACKED) {
        currentTexture = _crackedTile;
        statusOfPalette = status;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)setupBoardX:(NSInteger)x Y:(NSInteger)y TileSize:(NSInteger)ts Status:(NSInteger)status {
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    
    [self setTextureOfSprite:sprite AccordingToStatus:status];

    sprite.size = CGSizeMake(ts, ts);
    CGPoint p = CGPointMake(x, y);
    p = [Converter convertCoordToPixel:p];
    p.x += 22;
    
   // NSInteger xx = x*ts + p.x + ts/2;
   // NSInteger yy = [Converter convertCoordToPixel:p];//WIN_SIZE_Y - 22 - y*ts;

    sprite.position = p;
    [_boardSprites addObject:sprite];
    [self addChild:sprite];
}

-(void)refreshBoardX:(NSInteger)x Y:(NSInteger)y Status: (NSInteger)status {
    SKSpriteNode *sprite = [_boardSprites objectAtIndex:y*BOARD_SIZE_X + x];
    [self setTextureOfSprite:sprite AccordingToStatus:status];
}

/*
 *  Sets the texture of a sprite according to the status of the board coordinate. */
-(void)setTextureOfSprite:(SKSpriteNode *)sprite AccordingToStatus:(NSInteger)status {
    if(status == MAPSTATUS_SOLID) {
        sprite.texture = _solid;
    } else if(status == MAPSTATUS_VOID) {
        sprite.texture = _voidTile;
    } else if(status == MAPSTATUS_CRACKED) {
        sprite.texture = _crackedTile;
    }
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
