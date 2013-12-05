//
//  BoardCoord.m
//  SpacePuzzle


#import "BoardCoord.h"
#import "Macros.h"

@implementation BoardCoord
@synthesize status = _status;
@synthesize elements = _elements;

-(id)init {
    if(self = [super init]){
        _elements = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSNumber*) key {
    return [NSNumber numberWithInteger:self.y*BOARD_SIZE_X + self.x];
}

@end
