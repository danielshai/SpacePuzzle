//
//  BridgeButton.m
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "BridgeButton.h"

@implementation BridgeButton
@synthesize blocking = _blocking;
@synthesize bridge = _bridge;
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

-(id)initWithBridge:(Bridge*)e X:(NSInteger)x Y:(NSInteger)y{
    if(self = [super initWithX:x Y:y]) {
        _bridge = e;
    }
    return self;
}

-(void) doAction {
    _state = !_state;
    _bridge.blocking = !_bridge.blocking;
}

-(void)movedTo {
    _state = YES;
    _bridge.blocking = NO;
}

-(void)unitLeft {
    _state = NO;
    _bridge.blocking = YES;
}
@end