//
//  MovingPlatform.h
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Element.h"
@class Path;

@interface MovingPlatform : Element
@property (nonatomic, retain) Path* path;
-(id)initWithX:(NSInteger)x Y:(NSInteger)y Path:(Path*) path;
@end
