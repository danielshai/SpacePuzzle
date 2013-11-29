//
//  GViewAppDelegate.h
//  SpacePuzzleEditor

//  TODO:
//    - Fixa macros med klassnamn.
//    - Städa: Synka alltid viewn (BoardScene) utifrån datamodellen. Alltså när en |editABoardItem| sker,
//             säg bara till AppDelegate, som i sin tur uppdaterar datamodellen och efter det uppdaterar
//             BoardScene, typ en metod |updateView|
//    - Lever, moving platform, path (alla elements). Bridge horizontal/vertical?
#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>
#import "Board.h"
#import "BoardScene.h"
#import "Palette.h"

@class BoardView;
@class Star;
@class StarButton;
@class Connections;
@class Bridge;
@class BridgeButton;
@class Path;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSString *currentFilePath;
    // Used for checking if a file has been edited, which is used to give feedback to the user of this fact.
    BOOL edited;
}
@property (unsafe_unretained) IBOutlet Palette *palette;
@property (unsafe_unretained) IBOutlet NSWindow *controlPanel;
@property (retain) IBOutlet NSWindow *window;
@property (retain) IBOutlet SKView *skView;
@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) BoardScene *scene;
@property (weak) IBOutlet NSMenu *recentMenu;
@property (nonatomic, retain) Connections *connections;
-(IBAction)newLevel:(id)sender;
-(IBAction)openLevel:(id)sender;
-(IBAction)saveLevel:(id)sender;
-(IBAction)saveAsLevel:(id)sender;
-(void)boardEdited:(NSNotification *) notification;
-(void)showControlPanel:(NSNotification *) notification;
-(void)pathDrag:(NSNotification*) notification;
-(void)controlDragged:(NSNotification *) notification;
-(void)controlDragUp:(NSNotification *) notification;
-(void)loadConnections;
-(void)updateConnectionsView;
-(void)cleanView;
-(void)refreshView;
-(void)refreshBoardView;
-(void)refreshElementView;
-(void)setupBoard;
-(void)loadPaths;
-(void)refreshPathView: (CGPoint)p;
-(void)observeText:(NSString *)text Selector:(SEL)selector;
-(void)notifyText:(NSString *)text Object: (NSObject*)object Key: (NSString*)key;
@end
