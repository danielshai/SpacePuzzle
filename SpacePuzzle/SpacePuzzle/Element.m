//
//  Item.m
//  SpacePuzzle

#import "Element.h"
#import "Macros.h"

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

-(NSNumber*) key {
    return [NSNumber numberWithInteger:self.y*BOARD_SIZE_X + self.x];
}

@end
