//
//  GViewAppDelegate.h
//  SpacePuzzleEditor
//

//  Copyright (c) 2013 WMD. All rights reserved.
//


// TODO: fixa att rita ut element. behöver en dictionary. Start och finish element kan ha en av varje.
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
-(void)refreshView;
-(void)refreshBoardView;
-(void)refreshElementView;
-(void)setupBoard;
-(void)observeText:(NSString *)text Selector:(SEL)selector;
@end
