//
//  BoardController.h
//  SpacePuzzle
//
//  Created by IxD on 05/12/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Board;
@class Element;
@class SpacePuzzleController;
@class BoardCoord;
@class MainScene;

@interface BoardController : NSObject
@property (nonatomic, retain) Board *board;
@property (nonatomic, assign) NSInteger starsLeft;
@property (nonatomic, retain) SpacePuzzleController *spController;
@property (nonatomic, assign) MainScene *scene;

-(void) setupBoardWithWorld: (NSInteger)world AndLevel: (NSInteger)level;
-(BOOL) unitWantsToMoveFrom: (CGPoint)from To: (CGPoint)to WithSwipe: (BOOL)swipe UnitWasAstronatut: (BOOL)isAstronaut;
-(NSInteger) getBoardStatusAtPosition: (CGPoint)p;
-(BOOL) isPointMovableTo: (CGPoint)p;
-(NSMutableArray*) elementsAtPosition: (CGPoint)p;
-(void)takeStar: (Element*)star;
-(BOOL)removeElement: (Element*)e FromBoardCoord: (BoardCoord*)bc;
-(void)addElement: (Element*)e ToBoardCoord: (BoardCoord*)bc;
-(void)moveBox: (Element*)rock InDirection: (NSInteger)dir;
-(void)doActionOnStarButton:(Element *)button;
-(void)doActionOnBridgeButton: (Element*)button;
-(void)doActionOnBoxSmash:(Element*)box;
-(void)unitWantsToDoActionAt:(CGPoint)loc From: (CGPoint)from IsBigL: (BOOL)isBigL;
-(void)boxMovedToPoint: (CGPoint)p FromPoint: (CGPoint)pFrom InDirection: (NSInteger)dir;
-(void)updateElementsMovedToPoint: (CGPoint)to;
-(BoardCoord*) boardCoordForPoint: (CGPoint)p;
-(BOOL)isUnitOnVoid: (CGPoint)unitPoint;
@end
