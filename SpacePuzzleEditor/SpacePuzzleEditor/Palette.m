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
@synthesize selectedEraser = _selectedEraser;
@synthesize selectedStarButton = _selectedStarButton;

-(IBAction)solidClick:(id)sender {
    // Show which tile is selected.
    [self setSelectedIndicatorIsHiddenSolid:NO IsCracked:YES IsVoid:YES isStart:YES isFinished:YES
                                     isRock:YES isStar:YES isEraser:YES isStarButton:YES];
    
    [self notifyText:@"SolidClick" Object:nil Key:@"SolidClick"];
}

-(IBAction)crackedAction:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:NO IsVoid:YES isStart:YES isFinished:YES
                                     isRock:YES isStar:YES isEraser:YES isStarButton:YES];
    
    [self notifyText:@"CrackedClick" Object:nil Key:@"CrackedClick"];
}

-(IBAction)voidClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:NO isStart:YES isFinished:YES
                                     isRock:YES isStar:YES isEraser:YES isStarButton:YES];
    
    [self notifyText:@"VoidClick" Object:nil Key:@"VoidClick"];
}

-(IBAction)startClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:NO isFinished:YES
                                     isRock:YES isStar:YES isEraser:YES isStarButton:YES];
    [self notifyText:@"StartClick" Object:Nil Key:@"StartClick"];
}

-(IBAction)finishClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:NO
                                     isRock:YES isStar:YES isEraser:YES isStarButton:YES];
    [self notifyText:@"FinishClick" Object:Nil Key:@"FinishClick"];
}

-(IBAction)rockClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:YES
                                     isRock:NO isStar:YES isEraser:YES isStarButton:YES];
    [self notifyText:@"RockClick" Object:Nil Key:@"RockClick"];
}

- (IBAction)starClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:YES
                                     isRock:YES isStar:NO isEraser:YES isStarButton:YES];
    [self notifyText:@"StarClick" Object:Nil Key:@"StarClick"];
}

- (IBAction)eraserClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:YES isRock:YES isStar:YES isEraser:NO isStarButton:YES];
    [self notifyText:@"EraserClick" Object:Nil Key:@"EraserClick"];
}

-(IBAction)starButtonClick:(id)sender {
    [self setSelectedIndicatorIsHiddenSolid:YES IsCracked:YES IsVoid:YES isStart:YES isFinished:YES isRock:YES isStar:YES isEraser:YES isStarButton:NO];
    [self notifyText:@"StarButtonClick" Object:Nil Key:@"StarButtonClick"];
}

/* 
 *  Displays a selection rectangle on the palette according to what brush is selected. */
-(void)setSelectedIndicatorIsHiddenSolid:(BOOL)solid IsCracked:(BOOL)cracked IsVoid:(BOOL)isVoid isStart:(BOOL)start isFinished:(BOOL)finish isRock:(BOOL)rock isStar:(BOOL)star isEraser:(BOOL)eraser isStarButton:(BOOL)starbtn {
    [_selectedSolid setHidden:solid];
    [_selectedVoid setHidden:isVoid];
    [_selectedCracked setHidden:cracked];
    [_selectedStart setHidden:start];
    [_selectedFinish setHidden:finish];
    [_selectedRock setHidden:rock];
    [_selectedStar setHidden:star];
    [_selectedEraser setHidden:eraser];
    [_selectedStarButton setHidden:starbtn];
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
