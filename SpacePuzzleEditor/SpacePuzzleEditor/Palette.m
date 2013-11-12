//
//  Palette.m
//  SpacePuzzleEditor
//
//  Created by IxD on 12/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Palette.h"

@implementation Palette
@synthesize solidTile = _solidTile;
@synthesize crackedTile = _crackedTile;
@synthesize voidTile = _voidTile;

- (IBAction)solidClick:(id)sender {
    NSLog(@"solidclick");
    [self notifyText:@"SolidClick" Object:nil Key:@"SolidClick"];
}

- (IBAction)crackedAction:(id)sender {
    
}

- (IBAction)voidClick:(id)sender {
    [self notifyText:@"VoidClick" Object:nil Key:@"VoidClick"];
}

-(void) notifyText:(NSString *)text Object:(NSObject *)object Key:(NSString *)key {
    if(object) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:object forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:text object:nil
                                                          userInfo:userInfo];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:text object:nil];
    }
}

@end
