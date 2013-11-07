//
//  GViewMyScene.m
//  SpacePuzzle
//
//  Created by IxD on 07/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "GViewMyScene.h"

@implementation GViewMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
       
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
