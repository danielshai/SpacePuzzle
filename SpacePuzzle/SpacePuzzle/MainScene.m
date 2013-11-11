//
//  GViewMyScene.m
//  SpacePuzzle

#import "MainScene.h"

@implementation MainScene
@synthesize square = _square;
@synthesize bigL = _bigL;
@synthesize littleJohn = _littleJohn;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
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
        _littleJohn.position = location;
        [self notifyText:UNIT_MOVED Object:nil Key:UNIT_MOVED];
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
    
    NSInteger xx = x*TILESIZE+TILESIZE/2 + 6;

    NSInteger yy = 480-BOARD_PIXEL_BEGIN_Y - y*TILESIZE-TILESIZE/2;
    
    sprite.position = CGPointMake(xx,yy);
    [self addChild:sprite];
}

/*
 *  Sets up the view of units. */
-(void)setupUnits {
    // TEMP
    _littleJohn = [SKSpriteNode spriteNodeWithImageNamed:@"littlejohn.png"];
    _littleJohn.size = CGSizeMake(32,32);
    _littleJohn.position = CGPointMake(TILESIZE/2+6,480-BOARD_PIXEL_BEGIN_Y-TILESIZE/2);
    [self addChild:_littleJohn];
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
