//
//  GViewAppDelegate.h
//  SpacePuzzleEditor
//

//  Copyright (c) 2013 WMD. All rights reserved.
//


// TODO: FIXA MACROS MED KLASSNAMN EFTERSOM DE KAN ÄNDRAS!!
#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "Board.h"
#import "BoardScene.h"

@class BoardView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSString *currentFilePath;
    // Used for checking if a file has been edited, which is used to give feedback to the user of this fact.
    BOOL edited;
}
@property (unsafe_unretained) IBOutlet NSWindow *controlPanel;
@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet SKView *skView;
@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) BoardScene *scene;
@property (weak) IBOutlet NSMenu *recentMenu;
-(IBAction)newLevel:(id)sender;
-(IBAction)openLevel:(id)sender;
-(IBAction)saveLevel:(id)sender;
-(IBAction)saveAsLevel:(id)sender;
-(void)boardEdited:(NSNotification *) notification;
-(void)showControlPanel:(NSNotification *) notification;
-(void)cleanView;
-(void)refreshView;
-(void)refreshBoardView;
-(void)refreshElementView;
-(void)setupBoard;
-(void)observeText:(NSString *)text Selector:(SEL)selector;
@end
