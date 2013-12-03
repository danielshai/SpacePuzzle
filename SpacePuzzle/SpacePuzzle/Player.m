//
//  Player.m
//  SpacePuzzle
//
//  Created by IxD on 19/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize starsTaken = _starsTaken;
@synthesize world = _world;
@synthesize level = _level;
// Först bara Big L
// Startpositioner
// Värld- samt ban-integer. 
-(id)init {
    if(self = [super init]){
        _starsTaken = 0;
    }
    return self;
}

-(id)initWithWorld: (NSInteger) world andLevel: (NSInteger) level{
    if (self = [super init]){
        _starsTaken = 0;
        _world = world;
        _level = level;
    }
    return self;
}

@end
