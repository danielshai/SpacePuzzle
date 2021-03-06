//
//  Button.m
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "StarButton.h"
#import "Star.h"

@implementation StarButton
@synthesize blocking = _blocking;
@synthesize star = _star;
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

-(id)initWithStar:(Star*)e X:(NSInteger)x Y:(NSInteger)y{
    if(self = [super initWithX:x Y:y]) {
        _star = e;
    }
    return self;
}

-(void) doAction {
    if(!_star.taken) {
        _state = !_state;
        _star.hidden = !_state;
    } else {
        _state = !_state;
    }
}

-(void) movedTo {
    if(!_star.taken) {
        _state = YES;
        _star.hidden = NO;
    } else {
        _state = YES;
    }
}

-(void)unitLeft {
    if(!_star.taken) {
        _state = NO;
        _star.hidden = YES;
    } else {
        _state = NO;
    }
}

@end
