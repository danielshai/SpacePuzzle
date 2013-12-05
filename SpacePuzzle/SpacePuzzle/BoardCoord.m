//
//  BoardCoord.m
//  SpacePuzzle


#import "BoardCoord.h"

@implementation BoardCoord
@synthesize status = _status;
@synthesize elements = _elements;

-(id)init {
    if(self = [super init]){
        _elements = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
