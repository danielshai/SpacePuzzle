//
//  Player.h
//  SpacePuzzle
//
//  Created by IxD on 19/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property (nonatomic, assign) NSInteger starsTaken;
@property (nonatomic, assign) NSInteger world;
@property (nonatomic, assign) NSInteger level;

-(id)initWithWorld: (NSInteger) world andLevel: (NSInteger) level;
@end
