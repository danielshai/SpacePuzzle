//
//  Palette.h
//  SpacePuzzleEditor
//
//  Created by IxD on 12/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@interface Palette : NSPanel
@property (weak) IBOutlet NSImageView *solidTile;
@property (weak) IBOutlet NSImageView *crackedTile;
@property (weak) IBOutlet NSImageView *voidTile;
@property (weak) IBOutlet NSButton *solidButton;
@property (weak) IBOutlet NSButton *crackedButton;
@property (weak) IBOutlet NSButton *voidButton;
@property (weak) IBOutlet NSImageView *selectedSolid;
@property (weak) IBOutlet NSImageView *selectedCracked;
@property (weak) IBOutlet NSImageView *selectedVoid;
@property (weak) IBOutlet NSButton *startButton;

-(IBAction)solidClick:(id)sender;
-(IBAction)crackedAction:(id)sender;
-(IBAction)voidClick:(id)sender;
-(void)notifyText:(NSString *)text Object: (NSObject*)object Key: (NSString*)key;
- (IBAction)startClick:(id)sender;

@end
