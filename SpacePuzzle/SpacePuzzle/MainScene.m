//
//  GViewMyScene.m
//  SpacePuzzle
#import "SpacePuzzleController.h"
#import "MainScene.h"
#import "Macros.h"
#import "Converter.h"
#import "BigLWalk.h"
#import "LittleJohnWalk.h"
#import "StarOnTile.h"
#import "StarTaken.h"
#import "AnimationFactory.h"
#import "Position.h"
#import "Element.h"
#import "Position.h"
#import "Box.h"
#import "Star.h"
#import "StarButton.h"
#import "BridgeButton.h"
#import "Bridge.h"
#import "PlatformLever.h"
#import "MovingPlatform.h"

@implementation MainScene
@synthesize controller = _controller;
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
@synthesize sequence = _sequence;
@synthesize bWUp = _bWUp;
@synthesize bWDown = _bWDown;
@synthesize bWRight = _bWRight;
@synthesize bWLeft = _bWLeft;
@synthesize lWUp = _lWUp;
@synthesize lWDown = _lWDown;
@synthesize lWRight = _lWRight;
@synthesize lWLeft = _lWLeft;
@synthesize star = _star;
@synthesize finish = _finish;
@synthesize gui = _gui;
@synthesize guiAstro = _guiAstro;
@synthesize mBox = _mBox;
@synthesize mStar = _mStar;
@synthesize tStar = _tStar;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _bigL = [SKSpriteNode spriteNodeWithImageNamed:@"AstroDown.png"];
        _littleJohn = [SKSpriteNode spriteNodeWithImageNamed:@"AlienDown.png"];
        _bigL.zPosition = 9999999;
        _littleJohn.zPosition = 9999999;
        [self addChild:_littleJohn];
        [self addChild:_bigL];
        _currentUnit = _littleJohn;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _solidTile = [SKTexture textureWithImageNamed:@"solidtile.png"];
        _crackedTile = [SKTexture textureWithImageNamed:@"Cracked.png"];
        _voidTile = [SKTexture textureWithImageNamed:@"voidtile.png"];
        _buttonOn = [SKTexture textureWithImageNamed:@"ButtonON.png"];
        _buttonOff = [SKTexture textureWithImageNamed:@"BridgeButton.png"];
        _bridgeOn = [SKTexture textureWithImageNamed:@"BridgeON.png"];
        _bridgeOff = [SKTexture textureWithImageNamed:@"BridgeOFF.png"];
        _switchOn = [SKTexture textureWithImageNamed:@"SwitchON.png"];
        _switchOff = [SKTexture textureWithImageNamed:@"SwitchOFF.png"];
        _guiAstro = [SKTexture textureWithImageNamed:@"TopBarAstro"];
        _guiAlien = [SKTexture textureWithImageNamed:@"TopBarAlien"];
        _finish = [SKSpriteNode spriteNodeWithImageNamed:@"Finish.png"];
        _finish.size = CGSizeMake(TILESIZE, TILESIZE);
        _finish.zPosition = 2;
        [self addChild:_finish];
        
        _bkg = [SKSpriteNode spriteNodeWithImageNamed:@"Background01.png"];
        _movingPlatform = [SKTexture textureWithImageNamed:@"MovingPlatform.png"];
        _star = [SKTexture textureWithImageNamed:@"Star.png"];
        _box = [SKTexture textureWithImageNamed:@"Box.png"];
        
        _bkg.size = CGSizeMake(size.width, size.height);
        _littleJohn.texture = [SKTexture textureWithImageNamed:@"AlienDown"];
        _littleJohn.zPosition = 99999;
        _bigL.texture = [SKTexture textureWithImageNamed:@"AstroDown"];
        _bigL.zPosition = 99999;
        
        _bkg.position = CGPointMake(WIN_SIZE_X/2, WIN_SIZE_Y/2);
        [self addChild:_bkg];
        
        _elements = [[NSMutableDictionary alloc] init];
        _tiles = [[NSMutableArray alloc] init];
        
        _gui = [SKSpriteNode spriteNodeWithTexture:_guiAstro];
        CGSize scale = _gui.size;
        scale.width = scale.width / 2;
        scale.height = scale.height / 2;
        _gui.size = scale;
        _gui.position = CGPointMake(WIN_SIZE_X/2, WIN_SIZE_Y-_gui.size.height/2);
        [self addChild:_gui];
        
        takenStarsArray = [[NSMutableArray alloc] init];
        
        [self initScene];
    }
    return self;
}

// Preloads animation textures.
// UPDATE: resize:YES ger animation utan vita rutor. Dock resizar den spriten till 88x88, eftersom texturen
// har den storleken. Om vi kör med bilder i Images.xcassets med en version av varje texture för vanlig
// iPhone och en för Retina, dvs. 44x44 och 88x88.
-(void)initScene {
    // Preloading Big L's walking animations.
    [SKTexture preloadTextures:BIGLWALK_ANIM_AUP withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_AUP timePerFrame:TIME_PER_FRAME_UNIT_WALK resize:NO restore:NO];
        _bWUp = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:BIGLWALK_ANIM_ADOWN withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_ADOWN timePerFrame:TIME_PER_FRAME_UNIT_WALK resize:NO restore:NO];
        
        _bWDown = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:BIGLWALK_ANIM_ARIGHT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_ARIGHT timePerFrame:TIME_PER_FRAME_UNIT_WALK resize:NO restore:NO];
        _bWRight = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:BIGLWALK_ANIM_ALEFT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:BIGLWALK_ANIM_ALEFT timePerFrame:TIME_PER_FRAME_UNIT_WALK resize:NO restore:NO];
        _bWLeft = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    
    // Preloading Little Johns walking animations.
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BUP withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BUP timePerFrame:TIME_PER_FRAME_UNIT_WALK];
        _lWUp = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BDOWN withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BDOWN timePerFrame:TIME_PER_FRAME_UNIT_WALK];
        _lWDown = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BRIGHT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BRIGHT timePerFrame:TIME_PER_FRAME_UNIT_WALK];
        _lWRight = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BLEFT withCompletionHandler:^(void){
        SKAction *walk = [SKAction animateWithTextures:LITTLEJOHNWALK_ANIM_BLEFT timePerFrame:TIME_PER_FRAME_UNIT_WALK];
        _lWLeft = [SKAction sequence:@[walk, walk, walk, walk]];
    }];
    
    // Preloading the Boxes moving animations.
    NSArray *arr = [[NSArray alloc] init];
    SKTexture *t = [SKTexture textureWithImageNamed:@"Box.png"];
    arr = @[t,t,t,t];
    [SKTexture preloadTextures:LITTLEJOHNWALK_ANIM_BLEFT withCompletionHandler:^(void){
        SKAction *moveBox = [SKAction animateWithTextures:arr timePerFrame:TIME_PER_FRAME_BOX_MOVE];
        _mBox = [SKAction sequence:@[moveBox, moveBox, moveBox, moveBox]];
    }];
    
    // Preloading the Stars moving animations.
    [SKTexture preloadTextures:STARONTILE_ANIM_MOVING withCompletionHandler:^(void){
        SKAction *moveStar = [SKAction animateWithTextures:STARONTILE_ANIM_MOVING timePerFrame:0.15];
        _mStar = [SKAction repeatActionForever:moveStar];
    }];
    
    // Preloading the Stars taken animations.
    [SKTexture preloadTextures:STARTAKEN_ANIM_STARTAKEN withCompletionHandler:^(void){
        SKAction *takenStar = [SKAction animateWithTextures:STARTAKEN_ANIM_STARTAKEN timePerFrame:0.02 resize:NO restore:NO];
        _tStar = [SKAction sequence:@[takenStar]];
    }];
}

/*
 *  Updates the current unit with the data model. */
-(void)updateUnit:(CGPoint)coord inDirection:(NSInteger)direction {
    CGPoint pos = [Converter convertCoordToPixel:coord];
    pos.x += 20;
    pos.y -= 5;
    Position *coordinations = [[Position alloc] init];
    coordinations.x = coord.x;
    coordinations.y = coord.y;
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
    
    [_currentUnit setZPosition:9999];
    [_currentUnit runAction:action completion:^(void){
        if(_currentUnit == _bigL) {
            if(direction == UP) {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroUp.png"];
            } else if(direction == DOWN) {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroDown.png"];
            } else if(direction == RIGHT) {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroRight.png"];
            } else {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroLeft.png"];
            }
        } else {
            if(direction == UP) {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienUp.png"];
            } else if(direction == DOWN) {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienDown.png"];
            } else if(direction == RIGHT) {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienRight.png"];
            } else {
                _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienLeft.png"];
            }
        }
        [_controller sceneFinishedMovingUnit];
    }];
}

-(void)updateElementsAtPosition: (CGPoint)pos withArray: (NSMutableArray *)elArr {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSNumber *index = [NSNumber numberWithInteger:pos.y*BOARD_SIZE_X+pos.x];
    Element *element;
    
    NSMutableArray *prevArr = [_elements objectForKey:index];
    if(prevArr.count > 0) {
        for (int i = 0; i < prevArr.count; i++) {
            SKSpriteNode *pS = [prevArr objectAtIndex:i];
            [pS removeFromParent];
        }
        [prevArr removeAllObjects];
        [_elements removeObjectForKey:index];
    }
    
    for(int i = 0; i < elArr.count; i++) {
        element = [elArr objectAtIndex:i];
        SKSpriteNode *s = [SKSpriteNode spriteNodeWithTexture:[self getTextureForElement:element]];
        s.size = [self sizeForElement:element];
        CGPoint pos2 = [Converter convertCoordToPixel:pos];
        pos2.x += TILESIZE/2;
        s.position = pos2;
        s.hidden = element.hidden;
        s.zPosition = [self getZPositionForElement:element];
        [self addChild:s];
        if(s.texture == _star) {
            [s runAction:_mStar];
        }
        [arr insertObject:s atIndex:i];
    }
    
    if(elArr.count > 0) {
        [_elements setObject:arr forKey:index];
    }
}

/*
 *  Gets size for en element. */
-(CGSize)sizeForElement:(Element *)e {
    if([e isKindOfClass:[Box class]]) {
        return CGSizeMake(TILESIZE-8, TILESIZE-8);
    } else {
        return CGSizeMake(TILESIZE, TILESIZE);
    }
}

// ADD STATE OF ELEMENT.
-(SKTexture*)getTextureForElement:(Element *)e {
    if([e isKindOfClass:[Box class]]) {
        return _box;
    } else if([e isKindOfClass:[Star class]]) {
        return _star;
    } else if([e isKindOfClass:[StarButton class]]) {
        StarButton *sb = (StarButton*)e;
        if(sb.state) {
            return _buttonOn;
        } else {
            return _buttonOff;
        }
    } else if([e isKindOfClass:[BridgeButton class]]) {
        return _buttonOff;
    } else if([e isKindOfClass:[Bridge class]]) {
        return _buttonOff;
    } else if([e isKindOfClass:[PlatformLever class]]) {
        return _buttonOff;
    } else if([e isKindOfClass:[MovingPlatform class]]) {
        return _buttonOff;
    }

    return nil;
}

-(void)moveElementFrom: (CGPoint)oldCoord WithIndex: (NSInteger)elementIndex To: (CGPoint)newCoord OntoStatus:(NSInteger)status InDir:(NSInteger)direction {
    
    NSNumber *indexOrigin = [NSNumber numberWithFloat:oldCoord.y*BOARD_SIZE_X + oldCoord.x];
    NSNumber *indexNew = [NSNumber numberWithFloat:newCoord.y*BOARD_SIZE_X + newCoord.x];
   
    if(indexNew.integerValue == indexOrigin.integerValue) {
        //return;
        // SHOULD ANYTHING HAPPEN HERE?
    }
    NSMutableArray *elArr = [_elements objectForKey:indexOrigin];
    NSMutableArray *elNewArr = [_elements objectForKey:indexNew];
    
    if(!elNewArr) {
        elNewArr = [[NSMutableArray alloc] init];
        [_elements setObject:elNewArr forKey:indexNew];
    }
    SKSpriteNode *s = [elArr objectAtIndex:elementIndex];
    
    [elArr removeObject:s];
    [elNewArr addObject:s];
    
    // Gets the pixel value for the new position.
    CGPoint movePixel = [Converter convertCoordToPixel:newCoord];
    // Converter does not take into account anchor point.
    movePixel.x += TILESIZE/2;
    if(_currentUnit == _bigL) {
        if(direction == UP) {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroUp.png"];
        } else if(direction == DOWN) {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroDown.png"];
        } else if(direction == RIGHT) {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroRight.png"];
        } else {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AstroLeft.png"];
        }
    } else {
        if(direction == UP) {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienUp.png"];
        } else if(direction == DOWN) {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienDown.png"];
        } else if(direction == RIGHT) {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienRight.png"];
        } else {
            _currentUnit.texture = [SKTexture textureWithImageNamed:@"AlienLeft.png"];
        }
    }
    
    if (status == MAPSTATUS_SOLID || status == MAPSTATUS_CRACKED) {
        SKAction *move = [SKAction moveTo:movePixel duration:_mBox.duration];
        SKAction *action = [SKAction group:@[_mBox, move]];
        [s runAction:action completion:^(void){
            s.position = movePixel;
            [self.controller sceneFinishedMovingElementFrom:oldCoord WithIndex:elementIndex To:newCoord];
        }];
    } else {
        SKAction *move = [SKAction moveTo:movePixel duration:_mBox.duration];
        SKAction *action = [SKAction group:@[_mBox, move]];
        [s runAction:action completion:^(void){

            SKAction *scalEm = [SKAction scaleBy:0.01 duration:1.2];
    
            [s runAction:scalEm completion:^(void){
                // THE BUTTON SHOULD BE UPDATED BEFORE THE BOX IS GONE, HOWEVER, THIS WILL ALSO REMOVE THE BOX.
                [self.controller sceneFinishedMovingElementFrom:oldCoord WithIndex:elementIndex To:newCoord];
            }];
        }];
    }
}

-(CGFloat)getZPositionForElement:(Element *)e {
    if([e isKindOfClass:[Box class]]) {
        return 10;
    } else if([e isKindOfClass:[Star class]]) {
        return 9;
    } else if([e isKindOfClass:[StarButton class]]) {
        return 8;
    } else if([e isKindOfClass:[BridgeButton class]]) {
        return 8;
    } else if([e isKindOfClass:[Bridge class]]) {
        return 8;
    } else if([e isKindOfClass:[PlatformLever class]]) {
        return 8;
    } else if([e isKindOfClass:[MovingPlatform class]]) {
        return 7;
    }
    
    return 0;
}

-(void)starTakenAtPosition:(Element *)star CurrentTaken:(NSInteger)taken {
    SKSpriteNode *starSprite = [[SKSpriteNode alloc] initWithTexture:_star];
    CGPoint starPos = CGPointMake(star.x, star.y);
    starPos = [Converter convertCoordToPixel:starPos];
    starPos.x += TILESIZE/2;
    starSprite.position = starPos;
    starSprite.size = [self sizeForElement:star];
    starSprite.zPosition = [self getZPositionForElement:star];
    [self addChild:starSprite];
    [takenStarsArray addObject:starSprite];
   
    SKAction *moveToBar;
    SKAction *moveUpwards = [SKAction moveTo:CGPointMake(starSprite.position.x, (starSprite.position.y + 40)) duration:1.0];
    
    if (taken == 1) {
        // Fixating the stars to their correct positions.
        moveToBar = [SKAction moveTo:CGPointMake(139, 464) duration:0.5];
    } else if (taken == 2) {
        moveToBar = [SKAction moveTo:CGPointMake(161, 464) duration:0.5];
    } else {
        moveToBar = [SKAction moveTo:CGPointMake(183, 464) duration:0.5];
    }

    [starSprite runAction:moveUpwards completion:^(void){
        [starSprite runAction:_tStar completion:^(void){
            [starSprite runAction:moveToBar completion:^(void){
                [starSprite removeAllActions];
                starSprite.texture = STARTAKEN_TEX_STARTAKEN58;
                starSprite.size = CGSizeMake(32, 32);
            }];
        }];
    }];
    //[self removeElementAtPosition:index];
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

-(void)setupElement:(CGPoint)coord Name:(NSString *)className Hidden:(BOOL)hidden {
   
    NSString *path = className;
    path = [path stringByAppendingString:@".png"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:path];
    [sprite setSize:CGSizeMake(TILESIZE, TILESIZE)];
    CGPoint pos = [Converter convertCoordToPixel:coord];
    
    // Shift the sprite a bit.
    pos.x += sprite.size.width/2;
    
    if([className isEqualToString:CLASS_STAR]) {
        sprite.size = CGSizeMake(40, 40);
        pos.y -= 4;
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
    
    if ([className isEqualToString:@"Star"]) {
        [sprite runAction:_mStar];
    }
    
    [self addChild:sprite];
}

/*
 *  Sets up the view of units. */
-(void)setupAlien:(CGPoint)pos {
    pos = [Converter convertCoordToPixel:CGPointMake(pos.x, pos.y)];
    pos.x += 20;
    pos.y -= 5;
    
    _littleJohn.position = pos;
    _littleJohn.size = CGSizeMake(TILESIZE,TILESIZE);
    
    _currentUnit = _littleJohn;
}

-(void)setupAstronaut:(CGPoint)pos {
    pos = [Converter convertCoordToPixel:CGPointMake(pos.x, pos.y)];
    pos.x += 24;
    pos.y -= 5;
    
    _bigL.size = CGSizeMake(TILESIZE,TILESIZE);
    _bigL.position = pos;
    
    _currentUnit = _bigL;
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
        _gui.texture = _guiAlien;
    } else if (_currentUnit == _littleJohn) {
        _currentUnit = _bigL;
        _gui.texture = _guiAstro;
    }
}

-(void)setCurrentUnitWithMacro:(NSInteger)unit {
    if(unit == BIG_L) {
        _currentUnit = _bigL;
        _gui.texture = _guiAstro;
    } else if(unit == LITTLE_JOHN) {
        _currentUnit = _littleJohn;
        _gui.texture = _guiAlien;
    }
}

-(void)cleanScene {
    // IMPLEMENT!!!!!
    
    for (int i = 0; i < takenStarsArray.count; i++) {
        SKSpriteNode *s = [takenStarsArray objectAtIndex:i];
        [s removeFromParent];
    }
    [takenStarsArray removeAllObjects];
    
    for(id elm in _elements) {
        NSMutableArray *arr = [_elements objectForKey:elm];
        for(int i = 0; i < arr.count; i++) {
            SKSpriteNode *s = [arr objectAtIndex:i];
            [s removeFromParent];
        }
    }
    [_elements removeAllObjects];
    
    for(int i = 0; i < _tiles.count; i++) {
        SKSpriteNode *s = [_tiles objectAtIndex:i];
        [s removeFromParent];
    }
    [_tiles removeAllObjects];
    /*
    if(_littleJohn)
        [_littleJohn removeFromParent];
    if(_bigL)
        [_bigL removeFromParent];*/
}

-(SKTexture*) updateSpriteWith:(NSString *)name State:(BOOL)state {
    SKTexture *pic;
    if ([name isEqualToString:CLASS_STARBUTTON] || [name isEqualToString:CLASS_BRIDGEBUTTON]) {
        if (state) {
            pic = _buttonOn;
        } else {
            pic = _buttonOff;
        }
    } else if ([name isEqualToString:CLASS_BRIDGE]) {
        if (state) {
            pic = _bridgeOn;
        } else {
            pic = _bridgeOff;
        }
    } else if ([name isEqualToString:CLASS_LEVER]) {
        if (state) {
            pic = _switchOn;
        } else {
            pic = _switchOff;
        }
    } else if ([name isEqualToString:CLASS_MOVING_PLATFORM]) {
        // Might add the rainbow colours after the platform.
        pic = _movingPlatform;
    } else if ([name isEqualToString:CLASS_STAR]) {
        // Might add when a star is disabled.
        pic = _star;
    } else if ([name isEqualToString:CLASS_BOX]) {
        pic = _box;
    } else if ([name isEqualToString:@"Start"]) {
        pic = [SKTexture textureWithImageNamed:@"Start.gif"];
    }
    return pic;
}

@end
