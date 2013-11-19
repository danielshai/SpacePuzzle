//
//  Rock.m
//  SpacePuzzle

#import "Rock.h"

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

-(void) doAction {
    NSLog(@"ROCK ACTION!");
}
@end
