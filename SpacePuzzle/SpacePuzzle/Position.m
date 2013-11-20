//
//  Position.m
//  SpacePuzzle

#import "Position.h"

@implementation Position
@synthesize x = _x;
@synthesize y = _y;

-(id)init {
    if(self = [super init]){
        _x = 0;
        _y = 0;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super init]){
        _x = x;
        _y = y;
    }
    return self;
}

@end
