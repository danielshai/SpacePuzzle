/*
    GViewViewController.h
    SpacePuzzle

    Controller for the main game scene.
    
    To fix:
        - When standing on a tile and star appears, you don't pick it up (which you should).
        - Moving platform moving along paths (a generalised solution).
        - Textures should be in "Images.xcassets" with 2 versions of each (ordinary and retina [x2 size]).
        - Several elements on one coordinate.
    Cleaning up to do:
        - In board, create a class XMLExporter that has class functions that export the board.
        - Cleaner check of handling input from user, i.e. check what to do and doing it.
        - Cleaner update of scene.
        - Make use of AnimationFactory.
*/

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import "Board.h"
#import "Macros.h"
#import "MainScene.h"
#import "Unit.h"
#import "BigL.h"
#import "LittleJohn.h"

@class Element;
@class Star;
@class Player;
@class BridgeButton;
@class Bridge;
@class BoardController;

@interface SpacePuzzleController : UIViewController

@property (nonatomic, retain) Board *board;
@property (nonatomic, assign) MainScene *scene;
@property (nonatomic, retain) Unit *currentUnit;
@property (nonatomic, retain) Unit *nextUnit;
@property (nonatomic, retain) BigL *bigL;
@property (nonatomic, retain) LittleJohn *littleJohn;
@property (nonatomic, retain) Player *player;
@property (nonatomic, assign) NSInteger world;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, retain) BoardController *boardController;

-(void)singleTap:(UIGestureRecognizer *)sender;
-(void)doubleTap:(UIGestureRecognizer *)sender;
-(void)swipeUp:(UISwipeGestureRecognizer *)sender;
-(void)swipeDown:(UISwipeGestureRecognizer *)sender;
-(void)swipeLeft:(UISwipeGestureRecognizer *)sender;
-(void)swipeRight:(UISwipeGestureRecognizer *)sender;
-(void)changeUnit;
-(void)unitWantsToMoveTo: (CGPoint)loc WithSwipe: (BOOL)swipe;
-(void)unitWantsToDoActionAt: (CGPoint)loc;
-(void)doActionOnBoxSmash: (Element*)box;
-(void)doActionOnBox: (Element*)rock InDirection: (NSInteger)dir;
-(void)doActionOnStarButton: (Element*)button;
-(void)doActionOnBridgeButton: (Element*)button;
-(void)doActionOnPlatformLever: (Element*)lever;
-(BOOL)areUnitsOnFinish;
-(void)sceneFinishedMovingUnit;
-(void)setupBoard;
-(void)setupElements;
-(void)setupUnits;
-(void)setupScene;
-(void)movePlatform: (MovingPlatform*)mp;
-(void)observeText:(NSString*)text Selector: (SEL)selector;
-(void)getNextLevel;
-(void)setupNextLevel;
-(void)takeStar: (Star*)star;
-(void)updateElementsAtPosition: (CGPoint)pos withArray: (NSMutableArray*)elArr;
-(NSInteger)currentUnitToMacro;
-(IBAction)restartAction:(id)sender;
-(NSArray*)getDataFromNotification:(NSNotification*) notif Key: (NSString*) key;
-(IBAction)changeUnitAction:(id)sender;
@end
