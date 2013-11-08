//
//  GViewMyScene.m
//  SpacePuzzle

#import "MainScene.h"

@implementation MainScene
@synthesize square = _square;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _square = [SKTexture textureWithImageNamed:@"square.gif"];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        //CGPoint location = [touch locationInNode:self];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

-(void)renderBoardX:(NSInteger)x Y:(NSInteger)y {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:_square];
    sprite.size = CGSizeMake(32, 32);
    
    NSInteger xx = x*32+16;

    NSInteger yy = 352 - y*32-16;

    sprite.position = CGPointMake(xx,yy);
    [self addChild:sprite];
}

@end
