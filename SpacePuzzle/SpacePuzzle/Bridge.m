//
//  Bridge.m
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Bridge.h"

@implementation Bridge
@synthesize blocking = _blocking;

-(id)init {
    if(self = [super init]){
        _blocking = NO;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
    }
    return self;
}

-(void) movedTo {
    
}

-(void) doAction {
    
}
@end
