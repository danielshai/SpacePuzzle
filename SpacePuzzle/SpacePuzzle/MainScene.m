//
//  GViewMyScene.m
//  SpacePuzzle

#import "MainScene.h"
#import "Macros.h"
#import "Converter.h"
#import "BigLWalk.h"
#import "LittleJohnWalk.h"
#import "AnimationFactory.h"

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
@synthesize switchOff = _switchOff;
@synthesize switchOn = _switchOn;
@synthesize bigLUp = _bigLUp;
@synthesize bigLDown = _bigLDown;
@synthesize bigLRight = _bigLRight;
@synthesize bigLLeft = _bigLLeft;
@synthesize littleJohnUp = _littleJohnUp;
@synthesize littleJohnDown = _littleJohnDown;
@synthesize littleJohnRight = _littleJohnRight;
@synthesize littleJohnLeft = _littleJohnLeft;
@synthesize sequence = _sequence;
@synthesize bWUp = _bWUp;
@synthesize bWDown = _bWDown;
@synthesize bWRight = _bWRight;
@synthesize bWLeft = _bWLeft;
@synthesize lWUp = _lWUp;
@synthesize lWDown = _lWDown;
@synthesize lWRight = _lWRight;
@synthesize lWLeft = _lWLeft;

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
        _switchOn = [SKTexture textureWithImageNamed:@"SwitchON.png"];
        _switchOff = [SKTexture textureWithImageNamed:@"SwitchOFF.png"];
        _bkg = [SKSpriteNode spriteNodeWithImageNamed:@"Background.png"];
        _bkg.size = CGSizeMake(size.width, size.height);
        _littleJohn.texture = [SKTexture textureWithImageNamed:@"AlienDown"];
        _bigL.texture = [SKTexture textureWithImageNamed:@"AstroDown"];
        _bkg.position = CGPointMake(WIN_SIZE_X/2, WIN_SIZE_Y/2);
        [self addChild:_bkg];
        _elements = [[NSMutableDictionary alloc] init];
        _tiles = [[NSMutableArray alloc] init];
        [self initScene];
    }
    return self;
}

// Preloads animation textures.
-(void)initScene {
    // Preloading Big Ls walking animations.
    [SKTexture preloadTextures:BIGLWALK_ANIM_AUP withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_AUP timePerFrame:TIME_PER_FRAME];
        _bWUp = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:BIGLWALK_ANIM_ADOWN withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_ADOWN timePerFrame:TIME_PER_FRAME];
        _bWDown = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:BIGLWALK_ANIM_ARIGHT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_ARIGHT timePerFrame:TIME_PER_FRAME];
        _bWRight = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:BIGLWALK_ANIM_ALEFT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_ALEFT timePerFrame:TIME_PER_FRAME];
        _bWLeft = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    
    // Preloading Little Johns walking animations.
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BUP withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BUP timePerFrame:TIME_PER_FRAME];
        _lWUp = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BDOWN withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BDOWN timePerFrame:TIME_PER_FRAME];
        _lWDown = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BRIGHT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BRIGHT timePerFrame:TIME_PER_FRAME];
        _lWRight = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BLEFT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BLEFT timePerFrame:TIME_PER_FRAME];
        _lWLeft = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
}

/*
 *  Updates the current unit with the data model. */
-(void)updateUnit:(CGPoint)coord inDirection:(NSInteger)direction {
    CGPoint pos = [Converter convertCoordToPixel:coord];
    pos.x += 20;
    pos.y -= 5;
    SKAction *move;
    SKAction *action;
    // Depending on the direction the unit is making, update to the correct picture.
    if (_currentUnit == _bigL) {
        if(direction == UP) {
            move = [SKAction moveToY:pos.y duration:_bWUp.duration];
            action = [SKAction group:@[_bWUp, move]];
        } else if(direction == DOWN) {
            move = [SKAction moveToY:pos.y duration:_bWDown.duration];
            action = [SKAction group:@[_bWDown, move]];
        } else if(direction == RIGHT) {
            move = [SKAction moveToX:pos.x duration:_bWRight.duration];
            action = [SKAction group:@[_bWRight, move]];
        } else {
            move = [SKAction moveToX:pos.x duration:_bWLeft.duration];
            action = [SKAction group:@[_bWLeft, move]];
        }
    } else {
        if(direction == UP) {
            move = [SKAction moveToY:pos.y duration:_lWUp.duration];
            action = [SKAction group:@[_lWUp, move]];
        } else if(direction == DOWN) {
            move = [SKAction moveToY:pos.y duration:_lWDown.duration];
            action = [SKAction group:@[_lWDown, move]];
        } else if(direction == RIGHT) {
            move = [SKAction moveToX:pos.x duration:_lWRight.duration];
            action = [SKAction group:@[_lWRight, move]];
        } else {
            move = [SKAction moveToX:pos.x duration:_lWLeft.duration];
            action = [SKAction group:@[_lWLeft, move]];
        }
    }
    [_currentUnit runAction:action];
    //_currentUnit.position = pos;
}

-(void)moveElement:(CGPoint)oldCoord NewCoord:(CGPoint)newCoord {
    NSNumber *indexOrigin = [NSNumber numberWithFloat:oldCoord.y*BOARD_SIZE_X + oldCoord.x];
    NSNumber *indexNew = [NSNumber numberWithFloat:newCoord.y*BOARD_SIZE_X + newCoord.x];
  //  NSLog(@"moving: %f %f %f %f", oldCoord.x,oldCoord.y,newCoord.x,newCoord.y);
    if(indexNew.integerValue == indexOrigin.integerValue) {
        return;
    }
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

    s.texture = [self updateSpriteWith:name State:on];
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
    
    if([className isEqualToString:CLASS_STAR]) {
        sprite.size = CGSizeMake(34, 34);
    } else if([className isEqualToString:CLASS_LEVER]) {
        sprite.size = CGSizeMake(34, _switchOff.size.height/2);
        pos.y -= 10;
    }
    /*else if([className isEqualToString:@"ButtonOFF"]) {
        sprite.size = CGSizeMake(40, 40);
        pos.y -= 2;
        [sprite setPosition:pos];
    } else if([className isEqualToString:@"MovingPlatform"]) {
        sprite.size = CGSizeMake(42, 40);
        pos.y -= 1;
        [sprite setPosition:pos];
    } else if([className isEqualToString:@"PlatformLever"]) {
        sprite.size = CGSizeMake(TILESIZE, sprite.texture.size.height/2);
        pos.y -= 10;
    }*/

    [sprite setPosition:pos];
    NSNumber *nr = [NSNumber numberWithInt:coord.y*BOARD_SIZE_X + coord.x];
    [_elements setObject:sprite forKey:nr];
    sprite.hidden = hidden;
    
    [self addChild:sprite];
}

/*
 *  Sets up the view of units. */
-(void)setupUnits:(CGPoint)pos{
    // TEMP
    _littleJohn = [SKSpriteNode spriteNodeWithImageNamed:@"AlienDown.png"];
    _littleJohn.size = CGSizeMake(44,44);
    _bigL = [SKSpriteNode spriteNodeWithImageNamed:@"AstroDown.png"];
    _bigL.size = CGSizeMake(44,44);
    CGPoint p = [Converter convertCoordToPixel:CGPointMake(pos.x, pos.y)];
    p.x += 20;
    p.y -= 5;
    _littleJohn.position = p;
    _bigL.position = p;

    [self addChild:_littleJohn];
    [self addChild:_bigL];
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

/*
 * Change the current unit. */
-(void) changeUnit {
    if (_currentUnit == _bigL) {
        _currentUnit = _littleJohn;
    } else {
        _currentUnit = _bigL;
    }
}

-(SKTexture*) updateSpriteWith:(NSString *)name State:(BOOL)state {
    SKTexture *pic;
    if ([name isEqualToString:@"StarButton"] || [name isEqualToString:@"BridgeButton"]) {
        if (state) {
            pic = [SKTexture textureWithImageNamed:@"ButtonON.png"];
        } else {
            pic = [SKTexture textureWithImageNamed:@"ButtonOFF.png"];
        }
    } else if ([name isEqualToString:@"Bridge"]) {
        if (state) {
            pic = [SKTexture textureWithImageNamed:@"BridgeON.png"];
        } else {
            pic = [SKTexture textureWithImageNamed:@"BridgeOFF.png"];
        }
    } else if ([name isEqualToString:CLASS_LEVER]) {
        if (state) {
            pic = [SKTexture textureWithImageNamed:@"SwitchON.png"];
        } else {
            pic = [SKTexture textureWithImageNamed:CLASS_LEVER];
        }
    } else if ([name isEqualToString:CLASS_MOVING_PLATFORM]) {
        // Might add the rainbow colours after the platform.
        pic = [SKTexture textureWithImageNamed:@"MovingPlatform.png"];
    } else if ([name isEqualToString:@"Star"]) {
        // Might add when a star is disabled.
        pic = [SKTexture textureWithImageNamed:@"Star.png"];
    } else if ([name isEqualToString:@"Star"]) {
        pic = [SKTexture textureWithImageNamed:@"Box.png"];
    } else if ([name isEqualToString:@"Start"]) {
        pic = [SKTexture textureWithImageNamed:@"Start.gif"];
    }
    return pic;
}

@end
