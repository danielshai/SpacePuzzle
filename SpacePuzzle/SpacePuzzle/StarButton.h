//
//  Button.h
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Element.h"

@class Star;

@interface StarButton : Element
@property (nonatomic, assign) Star* star;
@property (nonatomic, assign) BOOL state;
-(id)initWithStar: (Star*)e X:(NSInteger)x Y:(NSInteger)y;

@end
