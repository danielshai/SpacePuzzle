//
//  GViewAppDelegate.h
//  SpacePuzzleEditor
//

//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "Board.h"

@interface GViewAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;
@property (nonatomic, retain) Board *board;

-(void)setupBoard;
@end
