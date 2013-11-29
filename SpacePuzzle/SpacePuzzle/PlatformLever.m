//
//  PlatformLever.m
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "PlatformLever.h"

@implementation PlatformLever
@synthesize blocking = _blocking;
@synthesize movingPlatform = _movingPlatform;
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

-(id)initWithMovingPlatform:(MovingPlatform*)e X:(NSInteger)x Y:(NSInteger)y{
    if(self = [super initWithX:x Y:y]) {
        _movingPlatform = e;
    }
    return self;
}

-(void) doAction {
    _state = !_state;
    [_movingPlatform start];
}

@end
