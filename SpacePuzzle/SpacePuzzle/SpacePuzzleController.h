/*
    GViewViewController.h
    SpacePuzzle

    Controller for the main game scene.
    
    To fix:
        - Level progress.
        - Startpositioner för olika units.
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

-(void)singleTap:(UIGestureRecognizer *)sender;
-(void)doubleTap:(UIGestureRecognizer *)sender;
-(void)swipeUp:(UISwipeGestureRecognizer *)sender;
-(void)swipeDown:(UISwipeGestureRecognizer *)sender;
-(void)swipeLeft:(UISwipeGestureRecognizer *)sender;
-(void)swipeRight:(UISwipeGestureRecognizer *)sender;
-(void)changeUnit;
-(void)unitWantsToMoveTo: (CGPoint)loc;
-(void)unitWantsToDoActionAt: (CGPoint)loc;
-(void)doActionOnBoxSmash: (Element*)box;
-(void)doActionOnBox: (Element*)rock InDirection: (NSInteger)dir;
-(void)doActionOnStarButton: (Element*)button;
-(void)doActionOnBridgeButton: (Element*)button;
-(void)doActionOnPlatformLever: (Element*)lever;
-(BOOL)isUnitOnGoal;
-(void)setupBoard;
-(void)setupElements;
-(void)setupUnits;
-(void)movePlatform: (MovingPlatform*)mp;
-(void)observeText:(NSString*)text Selector: (SEL)selector;
-(void)getNextLevel;
-(void)setupNextLevel;
-(NSArray*)getDataFromNotification:(NSNotification*) notif Key: (NSString*) key;
-(IBAction)changeUnitAction:(id)sender;
@end
