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

-(void) doAction {
    NSLog(@"STAR ACTION!");
}

@end
