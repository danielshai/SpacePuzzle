//
//  Item.m
//  SpacePuzzle

#import "Element.h"

@implementation Element
@synthesize blocking = _blocking;

-(id)init {
    if(self = [super init]){
        
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super initWithX:x Y:y]) {
        
    }
    return self;
}

-(void)doAction {
    
}

-(void)doMoveAction:(NSInteger)dir {
    
}

-(void)movedTo {
    
}

@end
