//
//  Path.m
//  SpacePuzzle
//
//  Created by IxD on 26/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Path.h"
#import "Position.h"

@implementation Path
@synthesize points = _points;
@synthesize platform = _platform;

-(id)init {
    if(self = [super init]){
        _points = [[NSMutableArray alloc] init];
        index = 0;
        countUp = YES;
    }
    return self;
}

-(CGPoint)nextPoint {
    Position *p = [_points objectAtIndex:index];
    
    if(countUp) {
        index++;
        if(index >= [_points count]) {
            countUp = NO;
            // Subtract with 2 if the platform shouldn't stay one step longer on end points.
            index--;
        }
    } else {
        index--;
        if(index < 0) {
            countUp = YES;
            // Add 2 if the platform shouldn't stay one step longer on end points.
            index++;
        }
    }
    
    return CGPointMake(p.x, p.y);
}

-(void)addPoint:(CGPoint)p {
    Position *pos = [[Position alloc] initWithX:p.x Y:p.y];
    [_points insertObject:pos atIndex:_points.count];
}

@end
