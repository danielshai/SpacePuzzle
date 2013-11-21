//
//  Button.m
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Button.h"

@implementation Button
@synthesize blocking = _blocking;
@synthesize element = _element;
@synthesize state = _state;

-(id)init {
    if(self = [super init]){
        _blocking = NO;
        _state = NO;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
        _state = NO;
    }
    return self;
}

-(id)initWithElement:(Element*)e X:(NSInteger)x Y:(NSInteger)y{
    if(self = [super initWithX:x Y:y]) {
        _element = e;
    }
    return self;
}

-(void) doAction {
    
}

@end
