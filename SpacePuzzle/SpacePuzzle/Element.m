//
//  Item.m
//  SpacePuzzle

#import "Element.h"
#import "Macros.h"

@implementation Element
@synthesize blocking = _blocking;
@synthesize hidden = _hidden;

-(id)init {
    if(self = [super init]){
        _blocking = NO;
        _hidden = NO;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
        _hidden = NO;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y Hidden:(BOOL)hidden {
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
        _hidden = hidden;
    }
    return self;
}

-(void)doAction {
    
}

-(void)doMoveAction:(NSInteger)dir {
    
}

-(void)movedTo {
    
}

-(NSNumber*) key {
    return [NSNumber numberWithInteger:self.y*BOARD_SIZE_X + self.x];
}

@end
