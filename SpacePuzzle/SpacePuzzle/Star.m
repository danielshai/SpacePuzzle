//
//  Star.m
//  SpacePuzzle
//
//  Created by IxD on 19/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Star.h"

@implementation Star
@synthesize blocking = _blocking;
@synthesize hidden = _hidden;
@synthesize taken = _taken;

-(id)init {
    if(self = [super init]){
        _blocking = NO;
        _hidden = NO;
        _taken = NO;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y {
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
        _hidden = NO;
        _taken = NO;
    }
    return self;
}

-(id)initWithX:(NSInteger)x Y:(NSInteger)y Hidden:(BOOL)hidden Taken:(BOOL)taken{
    if(self = [super initWithX:x Y:y]) {
        _blocking = NO;
        _hidden = hidden;
        _taken = NO;
    }
    return self;
}

-(void) movedTo {
    _taken = YES;
    NSLog(@"HEJ!");
}

-(void) doAction {
     NSLog(@"HEJ2!");
}

@end
