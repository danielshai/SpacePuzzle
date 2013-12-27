/*
    GViewViewController.h
    SpacePuzzle

    Controller for the main game scene.
    
    To fix:
        - Change unit by clicking it.
        - Grayed buttons when tapped.
        - Remove tap to walk???
        - Tap to move several steps?
        - Moving platform moving along paths (a generalised solution).
        - Textures should be in "Images.xcassets" with 2 versions of each (ordinary and retina [x2 size]).
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
@class LevelSelectScene;

@interface SpacePuzzleController : UIViewController {
    NSMutableArray *swipeArray;
    NSTimer *timer;
}
@property (nonatomic, retain) LevelSelectScene *levelSelect;
@property (nonatomic, retain) Board *board;
@property (nonatomic, retain) MainScene *scene;
@property (nonatomic, retain) Unit *currentUnit;
@property (nonatomic, retain) Unit *nextUnit;
@property (nonatomic, retain) BigL *bigL;
@property (nonatomic, retain) LittleJohn *littleJohn;
@property (nonatomic, retain) Player *player;
@property (nonatomic, assign) NSInteger world;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, retain) BoardController *boardController;

-(void)moveElementFrom: (CGPoint)oldCoord WithIndex: (NSInteger)elementIndex To: (CGPoint)newCoord OntoStatus:(NSInteger)status InDir:(NSInteger)direction;
-(void)checkInteraction:(NSTimer *)time;
-(void)singleTap:(UIGestureRecognizer *)sender;
-(void)doubleTap:(UIGestureRecognizer *)sender;
-(void)swipeUp:(UISwipeGestureRecognizer *)sender;
-(void)swipeDown:(UISwipeGestureRecognizer *)sender;
-(void)swipeLeft:(UISwipeGestureRecognizer *)sender;
-(void)swipeRight:(UISwipeGestureRecognizer *)sender;
-(void)changeUnit;
-(void)unitWantsToMoveTo: (CGPoint)loc WithSwipe: (BOOL)swipe;
-(void)unitWantsToDoActionAt: (CGPoint)loc;
-(void)doActionOnStarButton: (Element*)button;
-(void)doActionOnBridgeButton: (Element*)button;
-(void)doActionOnPlatformLever: (Element*)lever;
-(BOOL)areUnitsOnFinish;
-(void)sceneFinishedMovingUnit;
-(void)sceneFinishedMovingElementFrom: (CGPoint)from WithIndex: (NSInteger)index To: (CGPoint)to;
-(void)setupBoard;
-(void)setupElements;
-(void)setupUnits;
-(void)setupScene;
-(void)movePlatform: (MovingPlatform*)mp;
-(void)observeText:(NSString*)text Selector: (SEL)selector;
-(void)getNextLevel;
-(void)setupNextLevel;
-(void)startGameWithWorld: (NSInteger)world AndLevel: (NSInteger)level;
-(void)updateElementsAtPosition: (CGPoint)pos withArray: (NSMutableArray*)elArr;
-(NSInteger)currentUnitToMacro;
-(IBAction)restartAction:(id)sender;
-(NSArray*)getDataFromNotification:(NSNotification*) notif Key: (NSString*) key;
-(IBAction)changeUnitAction:(id)sender;
-(void)takeStar;
-(void)checkIfUnitShouldFall;
@end
