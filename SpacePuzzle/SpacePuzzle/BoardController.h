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

@interface BoardController : NSObject
@property (nonatomic, retain) Board *board;
@property (nonatomic, assign) NSInteger starsLeft;

-(void) setupBoardWithWorld: (NSInteger)world AndLevel: (NSInteger)level;
-(void) unitMovedFrom: (CGPoint)from To: (CGPoint)to UnitWasAstronatut: (BOOL)isAstronaut;
-(NSInteger) getBoardStatusAtPosition: (CGPoint)p;
-(BOOL) isPointMovableTo: (CGPoint)p;
-(NSMutableArray*) elementsAtPosition: (CGPoint)p;
-(void)takeStar: (Element*)star;
@end
