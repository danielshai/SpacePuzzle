//
//  GViewMyScene.m
//  SpacePuzzle

#import "MainScene.h"

@implementation MainScene
@synthesize square = _square;
@synthesize bigL = _bigL;
@synthesize littleJohn = _littleJohn;
@synthesize currentUnit = _currentUnit;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        _currentUnit = _littleJohn;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _square = [SKTexture textureWithImageNamed:@"square.gif"];
    }
    return self;
}

/* 
 *  Called when a touch begins. */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
        
        // TEMP CODE
        CGPoint coord = [Converter convertMousePosToCoord:location];
        CGPoint pos = [Converter convertCoordToPixel:coord];
        pos.x += 20; // TEMP SHIFT FOR THIS CERTAIN TEMP TEXTURE
        pos.y -= 5;
        if(coord.x >= 0 && coord.x < BOARD_SIZE_X && coord.y >= 0 && coord.y < BOARD_SIZE_Y) {
            CGPoint p = _currentUnit.position;
            p.x += 20;
            p.y -= 5;
            CGPoint unit = CGPointMake([Converter convertMousePosToCoord:p].x, [Converter convertMousePosToCoord:p].y);
            
            // Only move one step.
            if((coord.x - unit.x == 1 || coord.x - unit.x == -1) && coord.y == unit.y) {
                _currentUnit.position = CGPointMake(pos.x, _currentUnit.position.y);
                NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:coord],nil];
                [self notifyText:UNIT_MOVED Object:arr Key:UNIT_MOVED];
            } else if ((coord.y - unit.y == 1 || coord.y - unit.y == -1) && coord.x == unit.x) {
                _currentUnit.position = CGPointMake(_currentUnit.position.x, pos.y);
                NSArray *arr = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:coord],nil];
                [self notifyText:UNIT_MOVED Object:arr Key:UNIT_MOVED];
            }
        }
        // ADD CONNECTION TO CONTROLLER. NOTIFY NEW POSITION OF UNIT.
        
        // When adding swipe, this code should be run.
        /*
        if([_littleJohn isEqual:touchedNode]) {
            // Add point to where the currentUnit should move.
        }*/
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
   
}

/*
 *  Sets up the view of the board. TEMP CODE RIGHT NOW. */
-(void)setupBoardX:(NSInteger)x Y:(NSInteger)y {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:_square];
    sprite.size = CGSizeMake(TILESIZE, TILESIZE);
    
    NSInteger xx = x*TILESIZE+TILESIZE/2 + BOARD_PIXEL_BEGIN_X;

    NSInteger yy = BOARD_PIXEL_BEGIN_Y - y*TILESIZE-TILESIZE/2;
    
    sprite.position = CGPointMake(xx,yy);
    [self addChild:sprite];
}

/*
 *  Sets up the view of units. */
-(void)setupUnits {
    // TEMP
    _littleJohn = [SKSpriteNode spriteNodeWithImageNamed:@"littlejohn.png"];
    _littleJohn.size = CGSizeMake(32,32);
    CGPoint p = [Converter convertCoordToPixel:CGPointMake(0, 0)];
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
