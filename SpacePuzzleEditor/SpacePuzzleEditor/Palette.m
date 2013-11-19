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
@synthesize selectedFinish = _selectedFinish;
@synthesize selectedRock = _selectedRock;
@synthesize selectedStart = _selectedStart;
@synthesize selectedStar = _selectedStar;

-(IBAction)solidClick:(id)sender {
    // Show which tile is selected.
    [self setSelectedIndicatorIsHiddenSolid:NO IsCracked:YES IsVoid:YES isStart:YES isFinished:YES
                                     isRock:YES isStar:YES];
    
    [self notifyText:@"SolidClick" Object:nil Key:@"SolidClick"];
}

-(IBAction)crackedAction:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:NO IsVoid:YES isStart:YES isFinished:YES
                                     isRock:YES isStar:YES];
    
    [self notifyText:@"CrackedClick" Object:nil Key:@"CrackedClick"];
}

-(IBAction)voidClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:NO isStart:YES isFinished:YES
                                     isRock:YES isStar:YES];
    
    [self notifyText:@"VoidClick" Object:nil Key:@"VoidClick"];
}

-(IBAction)startClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:NO isFinished:YES
                                     isRock:YES isStar:YES];
    [self notifyText:@"StartClick" Object:Nil Key:@"StartClick"];
}

-(IBAction)finishClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:NO
                                     isRock:YES isStar:YES];
    [self notifyText:@"FinishClick" Object:Nil Key:@"FinishClick"];
}

-(IBAction)rockClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:YES
                                     isRock:NO isStar:YES];
    [self notifyText:@"RockClick" Object:Nil Key:@"RockClick"];
}

- (IBAction)starClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:YES
                                     isRock:YES isStar:NO];
    [self notifyText:@"StarClick" Object:Nil Key:@"StarClick"];
}

-(void)setSelectedIndicatorIsHiddenSolid:(BOOL)solid IsCracked:(BOOL)cracked IsVoid:(BOOL)isVoid isStart:(BOOL)start isFinished:(BOOL)finish isRock:(BOOL)rock isStar:(BOOL)star {
    [_selectedSolid setHidden:solid];
    [_selectedVoid setHidden:isVoid];
    [_selectedCracked setHidden:cracked];
    [_selectedStart setHidden:start];
    [_selectedFinish setHidden:finish];
    [_selectedRock setHidden:rock];
    [_selectedStar setHidden:star];
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
