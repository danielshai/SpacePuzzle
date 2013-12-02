//
//  MovingPlatform.m
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "MovingPlatform.h"
#import "Path.h"

@implementation MovingPlatform
@synthesize blocking = _blocking;
@synthesize path = _path;
@synthesize speed = _speed;

-(id)init {
    if(self = [super init]){
        _blocking = NO;
        _path = [[Path alloc] init];
        _speed = 2;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
        _path = [[Path alloc] init];
        _speed = 2;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y Path:(Path*)path {
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
        _path = path;
        _speed = 2;
    }
    return self;
}

-(void) movedTo {
    
}

-(void) doAction {
    
}

-(void)start {
    NSLog(@"Started");
}

-(void)stop {
    NSLog(@"Stopped");
}

@end
