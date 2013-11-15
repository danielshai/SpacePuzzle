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

@interface SpacePuzzleController : UIViewController
@property (nonatomic, retain) Board *board;
@property (nonatomic, assign) MainScene *scene;
@property (nonatomic, retain) Unit *currentUnit;
@property (nonatomic, retain) BigL *bigL;
@property (nonatomic, retain) LittleJohn *littleJohn;
-(void)unitWantsToMove:(NSNotification *)notification;
-(void)unitMoved:(NSNotification *) notification;
-(void)setupBoard;
-(void)setupUnits;
-(void)observeText:(NSString*)text Selector: (SEL)selector;
-(NSArray*)getDataFromNotification:(NSNotification*) notif Key: (NSString*) key;
@end
