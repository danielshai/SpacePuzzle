//
//  Rock.m
//  SpacePuzzle

#import "Rock.h"
#import "Macros.h"

@implementation Rock
@synthesize blocking = _blocking;

-(id)init {
    if(self = [super init]){
        _blocking = YES;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super initWithX:x Y:y]) {
        _blocking = YES;
    }
    return self;
}

-(void) doMoveAction:(NSInteger)dir{
    
    if (dir == RIGHT) {
        self.x = self.x + 1;
    } else if (dir == LEFT) {
        self.x = self.x - 1;
    } else if (dir == UP) {
        self.y = self.y - 1;
    } else
        self.y = self.y + 1;
}

@end
