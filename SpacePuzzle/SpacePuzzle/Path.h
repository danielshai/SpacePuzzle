//
//  Path.h
//  SpacePuzzle
//
//  Created by IxD on 26/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Position;
@class MovingPlatform;

@interface Path : NSObject {
    NSInteger index;
    BOOL countUp;
}
@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, retain) MovingPlatform *platform;
-(CGPoint) nextPoint;
-(void) addPoint: (CGPoint)p;
@end
