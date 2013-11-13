//
//  GViewAppDelegate.h
//  SpacePuzzleEditor
//

//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "Board.h"
#import "BoardScene.h"

@class BoardView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet SKView *skView;
@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) BoardScene *scene;

-(IBAction)openLevel:(id)sender;
-(IBAction)saveLevel:(id)sender;
-(void)boardEdited:(NSNotification *) notification;
-(void)setupBoard;
-(void)observeText:(NSString *)text Selector:(SEL)selector;
@end
