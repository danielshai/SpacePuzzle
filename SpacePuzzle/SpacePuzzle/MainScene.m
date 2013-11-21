//
//  GViewMyScene.m
//  SpacePuzzle

#import "MainScene.h"

@implementation MainScene
@synthesize solidTile = _solidTile;
@synthesize crackedTile = _crackedTile;
@synthesize voidTile = _voidTile;
@synthesize bigL = _bigL;
@synthesize littleJohn = _littleJohn;
@synthesize currentUnit = _currentUnit;
@synthesize bkg = _bkg;
@synthesize elements = _elements;
@synthesize tiles = _tiles;
@synthesize buttonOff = _buttonOff;
@synthesize buttonOn = _buttonOn;
@synthesize bridgeOff = _bridgeOff;
@synthesize bridgeOn = _bridgeOn;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _currentUnit = _littleJohn;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _solidTile = [SKTexture textureWithImageNamed:@"solidtile.png"];
        _crackedTile = [SKTexture textureWithImageNamed:@"Cracked.png"];
        _voidTile = [SKTexture textureWithImageNamed:@"voidtile.png"];
        _buttonOn = [SKTexture textureWithImageNamed:@"ButtonON.png"];
        _buttonOff = [SKTexture textureWithImageNamed:@"ButtonOFF.png"];
        _bridgeOn = [SKTexture textureWithImageNamed:@"BridgeON.png"];
        _bridgeOff = [SKTexture textureWithImageNamed:@"BridgeOFF.png"];
        _bkg = [SKSpriteNode spriteNodeWithImageNamed:@"Background.png"];
        _bkg.size = CGSizeMake(size.width, size.height);

        _bkg.position = CGPointMake(WIN_SIZE_X/2, WIN_SIZE_Y/2);
        [self addChild:_bkg];
        _elements = [[NSMutableDictionary alloc] init];
        _tiles = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 *  Updates the current unit with the data model. */
-(void)updateUnit:(CGPoint)coord {
    CGPoint pos = [Converter convertCoordToPixel:coord];
    pos.x += 20;
    pos.y -= 5;
    _currentUnit.position = pos;
}

-(void)moveElement:(CGPoint)oldCoord NewCoord:(CGPoint)newCoord {
    NSNumber *indexOrigin = [NSNumber numberWithFloat:oldCoord.y*BOARD_SIZE_X + oldCoord.x];
    NSNumber *indexNew = [NSNumber numberWithFloat:newCoord.y*BOARD_SIZE_X + newCoord.x];
    SKSpriteNode *s = [_elements objectForKey:indexOrigin];
    [_elements setObject:s forKey:indexNew];

    // Gets the pixel value for the new position.
    newCoord = [Converter convertCoordToPixel:newCoord];
    // Converter does not take into account anchor point.
    newCoord.x += TILESIZE/2;
    s.position = newCoord;
    [_elements removeObjectForKey:indexOrigin];
}

-(void)removeElementAtPosition:(NSNumber *)index {
    SKSpriteNode* s = [_elements objectForKey:index];
    [s removeFromParent];
    [_elements removeObjectForKey:index];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
   
}

-(void)refreshTileAtPosition: (CGPoint)pos WithStatus: (NSInteger)status {
    SKSpriteNode *s = [_tiles objectAtIndex:pos.y*BOARD_SIZE_X + pos.x];
    
    if(status == MAPSTATUS_SOLID) {
        s.texture = _solidTile;
    } else if(status == MAPSTATUS_CRACKED) {
        s.texture = _crackedTile;
    } else if(status == MAPSTATUS_VOID) {
        s.texture = _voidTile;
    }
}

-(void)refreshTileAtFlatIndex:(NSInteger)findex WithStatus:(NSInteger)status {
    SKSpriteNode *s = [_tiles objectAtIndex:findex];
    
    if(status == MAPSTATUS_SOLID) {
        s.texture = _solidTile;
    } else if(status == MAPSTATUS_CRACKED) {
        s.texture = _crackedTile;
    } else if(status == MAPSTATUS_VOID) {
        s.texture = _voidTile;
    }
}

/*
 *  Refreshes the sprite connected to an element on a position. This is only needed for elements that have
 *  different states. */
-(void)refreshElementAtPosition: (NSNumber*)index OfClass:(NSString*)name WithStatus:(BOOL)on{
    SKSpriteNode *s = [_elements objectForKey:index];

    if([name isEqualToString:@"Button"]) {
        if(on) {
            s.texture = _buttonOn;
        } else {
            s.texture = _buttonOff;
        }
    } else if([name isEqualToString:@"Bridge"]) {
        if (on) {
            s.texture = _bridgeOn;
        } else {
            s.texture = _bridgeOff;
        }
    }
}

-(void)setElementAtPosition:(NSNumber *)index IsHidden:(BOOL)hidden {
    SKSpriteNode *s = [_elements objectForKey:index];
    s.hidden = hidden;
}

/*
 *  Sets up the view of the board. TEMP CODE RIGHT NOW. */
-(void)setupBoardX:(NSInteger)x Y:(NSInteger)y Status:(NSInteger)status {
    SKSpriteNode *sprite;
    if(status == MAPSTATUS_SOLID) {
        sprite = [SKSpriteNode spriteNodeWithTexture:_solidTile];
    } else if(status == MAPSTATUS_CRACKED) {
        sprite = [SKSpriteNode spriteNodeWithTexture:_crackedTile];
    } else if(status == MAPSTATUS_VOID) {
        sprite = [SKSpriteNode spriteNodeWithTexture:_voidTile];
    }
    sprite.size = CGSizeMake(TILESIZE, TILESIZE);
    
    NSInteger xx = x*TILESIZE+TILESIZE/2 + BOARD_PIXEL_BEGIN_X;
    NSInteger yy = BOARD_PIXEL_BEGIN_Y - y*TILESIZE-TILESIZE/2;
    
    sprite.position = CGPointMake(xx,yy);
    [self addChild:sprite];
    [_tiles insertObject:sprite atIndex:y*BOARD_SIZE_X + x];
}

-(void)setupElement:(CGPoint)coord Name:(NSString *)className Hidden:(BOOL)hidden{
    NSString *path = className;
    path = [path stringByAppendingString:@".png"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:path];
    [sprite setSize:CGSizeMake(TILESIZE, TILESIZE)];
    CGPoint pos = [Converter convertCoordToPixel:coord];
    
    // Shift the sprite a bit.
    pos.x += sprite.size.width/2;
    [sprite setPosition:pos];
    
    if([className isEqualToString:@"Star"]) {
        sprite.size = CGSizeMake(22, 22);
    } else if([className isEqualToString:@"ButtonOFF"]) {
        sprite.size = CGSizeMake(40, 40);
        pos.y -= 2;
        [sprite setPosition:pos];
    }
    
    NSNumber *nr = [NSNumber numberWithInt:coord.y*BOARD_SIZE_X + coord.x];
    [_elements setObject:sprite forKey:nr];
    sprite.hidden = hidden;
    
    [self addChild:sprite];
}

/*
 *  Sets up the view of units. */
-(void)setupUnits:(CGPoint)pos{
    // TEMP
    _littleJohn = [SKSpriteNode spriteNodeWithImageNamed:@"Alien.png"];
    _littleJohn.size = CGSizeMake(32,32);
    CGPoint p = [Converter convertCoordToPixel:CGPointMake(pos.x, pos.y)];
    p.x += 20;
    p.y -= 5;
    _littleJohn.position = p;

    [self addChild:_littleJohn];
    _currentUnit = _littleJohn;
}

/*
 *  Sends a notification to |defaultCenter|. Data can be sent through |object|. */
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
