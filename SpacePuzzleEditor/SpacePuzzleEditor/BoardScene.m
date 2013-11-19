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
@synthesize startElement = _startElement;
@synthesize startElSprite = _startElSprite;
@synthesize finishElement = _finishElement;
@synthesize finishSprite = _finishSprite;
@synthesize rockTexture = _rockTexture;
@synthesize elementSprites = _elementSprites;
@synthesize starTexture = _starTexture;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _elementSprites = [[NSMutableDictionary alloc] init];
        
        self.backgroundColor = [SKColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
        self.size = CGSizeMake(size.width, size.height);
        _solid = [SKTexture textureWithImageNamed:@"solidtile.png"];
        _voidTile = [SKTexture textureWithImageNamed:@"voidtile.png"];
        _crackedTile = [SKTexture textureWithImageNamed:@"crackedtile.jpg"];
        _bkg = [SKSpriteNode spriteNodeWithImageNamed:@"Background.png"];
        _startElement = [SKTexture textureWithImageNamed:@"Start.gif"];
        _finishElement = [SKTexture textureWithImageNamed:@"Finish.png"];
        _rockTexture = [SKTexture textureWithImageNamed:@"Rock.png"];
        _starTexture = [SKTexture textureWithImageNamed:@"Star.png"];
        
        _startElSprite = [SKSpriteNode spriteNodeWithTexture:_startElement];
        _startElSprite.position = CGPointMake(-100, -100);
        _startElSprite.size = CGSizeMake(TILESIZE/2, TILESIZE/2);
        _startElSprite.zPosition = 10;
        [self addChild:_startElSprite];
        
        _finishSprite = [SKSpriteNode spriteNodeWithTexture:_finishElement];
        _finishSprite.position = CGPointMake(-100, -100);
        _finishSprite.size = CGSizeMake(TILESIZE/2, TILESIZE/2);
        _finishSprite.zPosition = 10;
        [self addChild:_finishSprite];
        
        _bkg.size = CGSizeMake(size.width, size.height);
        _bkg.position = CGPointMake(WIN_SIZE_X/2, WIN_SIZE_Y/2);
        [self addChild:_bkg];

        _boardSprites = [[NSMutableArray alloc] init];
        statusOfPalette = MAPSTATUS_SOLID;
        currentTexture = _solid;
        
        [self observeText:@"SolidClick" Selector:@selector(solidClick)];
        [self observeText:@"VoidClick" Selector:@selector(voidClick)];
        [self observeText:@"CrackedClick" Selector:@selector(crackedClick)];
        [self observeText:@"StartClick" Selector:@selector(startClick)];
        [self observeText:@"FinishClick" Selector:@selector(finishClick)];
        [self observeText:@"RockClick" Selector:@selector(rockClick)];
        [self observeText:@"StarClick" Selector:@selector(starClick)];
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
 *  Could be used to change brush? */
-(void)keyDown:(NSEvent *)theEvent {
   
}

/*
 *  Changes one tile/element on the board according to what brush is used and notifies observers that the 
 *  view has changed. */
-(void)editABoardItem:(NSEvent *)theEvent {
    // Find mouse location and convert.
    SKView *sk = self.view;
    NSPoint mouseLoc = [sk convertPoint:[theEvent locationInWindow] fromView:nil];
    CGPoint loc = CGPointMake(mouseLoc.x*WIN_SIZE_X/(sk.frame.size.width), mouseLoc.y*WIN_SIZE_Y/(sk.frame.size.height));
    
    loc = [Converter convertMousePosToCoord:loc];
    NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithPoint:loc],
                    [NSNumber numberWithInteger: statusOfPalette],nil];
    NSNumber *flatIndex = [NSNumber numberWithInt:loc.y*BOARD_SIZE_X + loc.x];
    // Check if the click was inside the board.
    if(loc.x >= 0 && loc.x < BOARD_SIZE_X && loc.y >= 0 && loc.y < BOARD_SIZE_Y) {
        // Change texture of sprite if tiles.
        if(statusOfPalette == MAPSTATUS_SOLID || statusOfPalette == MAPSTATUS_CRACKED || statusOfPalette == MAPSTATUS_VOID) {
            SKSpriteNode *s = [_boardSprites objectAtIndex:loc.y * BOARD_SIZE_X + loc.x];
            s.texture = currentTexture;

            [self notifyText:@"BoardEdited" Object:arr Key:@"BoardEdited"];
        }
        // Elements.
        else {
            if(statusOfPalette == BRUSH_START) {
                // Change position of Start sprite.
                loc = [Converter convertCoordToPixel:loc];
                loc.x += TILESIZE/2;
                _startElSprite.position = CGPointMake(loc.x, loc.y);
                [self notifyText:@"BoardEdited" Object:arr Key:@"BoardEdited"];
            } else if(statusOfPalette == BRUSH_FINISH) {
                loc = [Converter convertCoordToPixel:loc];
                loc.x +=TILESIZE/2;
                _finishSprite.position = CGPointMake(loc.x, loc.y);
                [self notifyText:@"BoardEdited" Object:arr Key:@"BoardEdited"];
            }
            // Elements that are part of the element dictionary.
            else if (![_elementSprites objectForKey:flatIndex]) {
                [self notifyText:@"BoardEdited" Object:arr Key:@"BoardEdited"];
            
                if(statusOfPalette == BRUSH_ROCK) {
                    // Sets up a rock at the position selected.
                    SKSpriteNode *rock = [SKSpriteNode spriteNodeWithTexture:_rockTexture];
                    CGPoint locPx = [Converter convertCoordToPixel:loc];
                    locPx.x += TILESIZE/2;
                    rock.position = locPx;
                    rock.size = CGSizeMake(TILESIZE-4, TILESIZE-4);
                    [_elementSprites setObject:rock forKey:flatIndex];
                    [self addChild:rock];
                } else if(statusOfPalette == BRUSH_STAR) {
                    SKSpriteNode *star = [SKSpriteNode spriteNodeWithTexture:_starTexture];
                    CGPoint locPx = [Converter convertCoordToPixel:loc];
                    locPx.x += TILESIZE/2;
                    star.position = locPx;
                    star.size = CGSizeMake(TILESIZE-4, TILESIZE-4);
                    [_elementSprites setObject:star forKey:flatIndex];
                    [self addChild:star];
                }
            }
            // Add sprite to dictionary with items according to brush.
        }
    }
}

/* 
 *  Runs when something is clicked on the palette. */
-(void)startClick {
    [self changeTextureOfBrush:BRUSH_START];
}

-(void)finishClick {
    [self changeTextureOfBrush:BRUSH_FINISH];
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

-(void)rockClick {
    [self changeTextureOfBrush:BRUSH_ROCK];
}

-(void)starClick {
    [self changeTextureOfBrush:BRUSH_STAR];
}
/*
 *  Changes the texture of the brush, i.e. what the brush will "paint". */
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
    } else if(status == BRUSH_START) {
        currentTexture = _startElement;
        statusOfPalette = status;
    } else if(status == BRUSH_FINISH) {
        currentTexture = _finishElement;
        statusOfPalette = status;
    } else if(status == BRUSH_ROCK) {
        currentTexture = _rockTexture;
        statusOfPalette = status;
    } else if(status == BRUSH_STAR) {
        currentTexture = _starTexture;
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
    p.x += TILESIZE/2;
    
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

-(void)refreshElementsStart:(CGPoint)start Finish:(CGPoint)finish {
    start = [Converter convertCoordToPixel:start];
    finish = [Converter convertCoordToPixel:finish];
    start.x += TILESIZE/2;
    finish.x += TILESIZE/2;
    
    _startElSprite.position = start;
    _finishSprite.position = finish;
}

-(void)addElement:(NSString *)element Position:(CGPoint)pos {
    NSNumber *flatIndex = [NSNumber numberWithInt:pos.y*BOARD_SIZE_X + pos.x];
    
    if([element isEqualToString:@"Rock"]) {
        SKSpriteNode *rock = [SKSpriteNode spriteNodeWithTexture:_rockTexture];
       
        CGPoint pxl = [Converter convertCoordToPixel:pos];
        pxl.x += TILESIZE/2;
        rock.position = pxl;
        rock.size = CGSizeMake(TILESIZE-4, TILESIZE-4);
        
        [_elementSprites setObject:rock forKey:flatIndex];
        [self addChild:rock];
    }
}

-(void)cleanElements {
    for(id key in _elementSprites) {
        SKSpriteNode* s = [_elementSprites objectForKey:key];
        [s removeFromParent];
    }
}

-(void)cleanView {
    for(id key in _elementSprites) {
        SKSpriteNode* s = [_elementSprites objectForKey:key];
      
        [s removeFromParent];
    }

    [_elementSprites removeAllObjects];
   
    _startElSprite.position = CGPointMake(-100, -100);
    _finishSprite.position = CGPointMake(-100, -100);
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
    } else if(status == BRUSH_START) {
        sprite.texture = _startElement;
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
