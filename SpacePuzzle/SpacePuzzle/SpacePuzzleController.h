/*
    GViewViewController.h
    SpacePuzzle

    Controller for the main game scene.
    ADD LEVELFACTORY.
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

@interface SpacePuzzleController : UIViewController
@property (nonatomic, retain) Board *board;
@property (nonatomic, assign) MainScene *scene;
@property (nonatomic, retain) Unit *currentUnit;
@property (nonatomic, retain) BigL *bigL;
@property (nonatomic, retain) LittleJohn *littleJohn;
@property (nonatomic, retain) Player *player;

-(void)singleTap:(UIGestureRecognizer *)sender;
-(void)doubleTap:(UIGestureRecognizer *)sender;
-(void)swipeUp:(UISwipeGestureRecognizer *)sender;
-(void)swipeDown:(UISwipeGestureRecognizer *)sender;
-(void)swipeLeft:(UISwipeGestureRecognizer *)sender;
-(void)swipeRight:(UISwipeGestureRecognizer *)sender;
-(void)unitWantsToMoveTo: (CGPoint)loc;
-(void)unitWantsToDoActionAt: (CGPoint)loc;
-(void)doActionOnBox: (Element*)rock InDirection: (NSInteger)dir;
-(void)doActionOnButton: (Element*)button;
-(void)unitMoved:(NSNotification *) notification;
-(void)setupBoard;
-(void)setupElements;
-(void)setupUnits;
-(void)observeText:(NSString*)text Selector: (SEL)selector;
-(NSArray*)getDataFromNotification:(NSNotification*) notif Key: (NSString*) key;
@end
