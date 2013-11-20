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

-(id)init {
    if(self = [super init]){
        _starsTaken = 0;
    }
    return self;
}
@end
