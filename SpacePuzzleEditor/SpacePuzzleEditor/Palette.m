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
@synthesize selectedSolid = _selectedSolid;
@synthesize selectedCracked = _selectedCracked;
@synthesize selectedVoid = _selectedVoid;

-(IBAction)solidClick:(id)sender {
    // Show which tile is selected.
    [_selectedSolid setHidden:NO];
    [_selectedVoid setHidden:YES];
    [_selectedCracked setHidden:YES];
    
    [self notifyText:@"SolidClick" Object:nil Key:@"SolidClick"];
}

-(IBAction)crackedAction:(id)sender {
    [_selectedSolid setHidden:YES];
    [_selectedVoid setHidden:YES];
    [_selectedCracked setHidden:NO];
    
    [self notifyText:@"CrackedClick" Object:nil Key:@"CrackedClick"];
}

-(IBAction)voidClick:(id)sender {
    [_selectedSolid setHidden:YES];
    [_selectedVoid setHidden:NO];
    [_selectedCracked setHidden:YES];
    
    [self notifyText:@"VoidClick" Object:nil Key:@"VoidClick"];
}


-(IBAction)startClick:(id)sender {
    [self notifyText:@"StartClick" Object:Nil Key:@"StartClick"];
}

-(IBAction)finishClick:(id)sender {
    [self notifyText:@"FinishClick" Object:Nil Key:@"FinishClick"];
}

-(IBAction)rockClick:(id)sender {
    [self notifyText:@"RockClick" Object:Nil Key:@"RockClick"];
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
