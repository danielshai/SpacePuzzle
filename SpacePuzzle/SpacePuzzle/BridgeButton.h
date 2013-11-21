//
//  BridgeButton.h
//  SpacePuzzle
//
//  Created by Viktor on 21/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Element.h"

@class Bridge;

@interface BridgeButton : Element
@property (nonatomic, assign) Bridge* element;
@property (nonatomic, assign) BOOL state;
-(id)initWithElement: (Element*)e X:(NSInteger)x Y:(NSInteger)y;

@end
