//
//  BoardController.m
//  SpacePuzzle
//
//  Created by IxD on 05/12/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "BoardController.h"
#import "Board.h"
#import "Macros.h"
#import "Converter.h"
#import "Element.h"
#import "Star.h"
#import "Box.h"
#import "StarButton.h"
#import "BridgeButton.h"
#import "Bridge.h"
#import "PlatformLever.h"
#import "MovingPlatform.h"

@implementation BoardController
@synthesize board = _board;
@synthesize starsLeft = _starsLeft;
-(id)init {
    if(self = [super init]) {
        _board = [[Board alloc] init];
    }
    return self;
}

-(BOOL)unitWantsToMoveFrom:(CGPoint)from To:(CGPoint)to WithSwipe:(BOOL)swipe UnitWasAstronatut:(BOOL)isAstronaut OtherUnitPosition:(CGPoint)otherUnitPoint
{
    NSInteger dir = [Converter convertCoordsTo:to Direction:from];
    BoardCoord *bcFrom = [[_board board] objectAtIndex:[Converter CGPointToKey:from]];
    
    if([self isPointMovableTo:to] && ![Converter isPoint:to sameAsPoint:from]
           && [Converter isPoint:from NextToPoint:to]) {
        // If |bigL| is standing on a cracked tile and moves away from it. This will destroy the tile,
        // making it void, and also destroying the item on it.
        if ([_board isPointCracked:from] && isAstronaut) {
            // Update model.
            bcFrom.status = MAPSTATUS_VOID;
            [bcFrom.elements removeAllObjects];
        }
    
        // Update elements.
        /* Checks elements on the tile moved from. */
    
        // Checks if the element moved from is a |StarButton|, and the second condition checks if
        // the other unit is still on the button, which means the button shouldn't be deactivated.
       
        for (int i = 0; i < bcFrom.elements.count; i++) {
            Element *eFrom = [[bcFrom elements] objectAtIndex:i];
            if( ([eFrom isKindOfClass:[StarButton class]] || [eFrom isKindOfClass:[BridgeButton class]])
            && ![Converter isPoint:from sameAsPoint:otherUnitPoint]) {
                // Buttons should be deactivated if left.
                [eFrom unitLeft];
            }
        }
    
        /* Checks elements on the tile moved to. */
        BoardCoord *bcTo = [[_board board] objectAtIndex:[Converter CGPointToKey:to]];
    
        for (int i = 0; i < bcTo.elements.count; i++) {
        // If the element is a star.
            Element *eTo = [[bcTo elements] objectAtIndex:i];
            if([eTo isKindOfClass:[Star class]] && ![eTo hidden] && ![eTo taken]) {
                [self takeStar:eTo];
            } else if([eTo isKindOfClass:[StarButton class]]) {
       //     [self doActionOnStarButton:eTo];
            } else if([eTo isKindOfClass:[BridgeButton class]]) {
      //      [self doActionOnBridgeButton:eTo];
            }
        }
        return YES;
    }
    BoardCoord *bcTo = [[_board board] objectAtIndex:[Converter CGPointToKey:to]];
    
    for (int i = 0; i < bcTo.elements.count; i++) {
        Element *eTo = [[bcTo elements] objectAtIndex:i];
        if([eTo isKindOfClass:[Box class]] && swipe && isAstronaut) {
            // Point isn't movable to, but if unit is astronaut and element blocking is a box, move it!
            // |swipe| needs to be YES because moving boxes cannot be done by single tap.
            [self doActionOnBox:eTo InDirection:dir OtherUnitPosition:otherUnitPoint];
        }
    }
    return NO;
}

-(void)doActionOnBox: (Element*)rock InDirection: (NSInteger)dir OtherUnitPosition:(CGPoint)otherUnitPos {
    NSNumber *nextKey;
    CGPoint nextPos;
    Element *e;
    NSNumber *elementKey = [NSNumber numberWithInteger:rock.y*BOARD_SIZE_X + rock.x];
    
    if (dir == RIGHT) {
        // Check if at the edge of the board, if so do nothing.
        if(rock.x >= BOARD_SIZE_X-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x + 1];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x + 1, rock.y);
    } else if (dir == LEFT) {
        if(rock.x <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x - 1];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x - 1, rock.y);
    } else if (dir == UP) {
        if(rock.y <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y - 1)*BOARD_SIZE_X + rock.x];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x, rock.y - 1);
    } else if (dir == DOWN){
        if(rock.y >= BOARD_SIZE_Y-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y + 1)*BOARD_SIZE_X + rock.x];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x, rock.y + 1);
    }
    // Add more elements which cannot be pushed upon to if-statement.
    // ![e isKindOfClass:[Box class]] ---> !e isBlocking
    CGPoint finishPos = CGPointMake([_board finishPos].x, [_board finishPos].y);
    
    if (![e isKindOfClass:[Box class]] && ![Converter isPoint:nextPos sameAsPoint:otherUnitPos] &&
        ![Converter isPoint:finishPos sameAsPoint:nextPos]) {
        NSInteger intKey = [nextKey integerValue];
        NSInteger nextTile = [[[_board board] objectAtIndex:intKey] status];
        
        CGPoint posPreMove = CGPointMake(rock.x, rock.y);
        [rock doMoveAction:dir];
        
        if(nextTile != MAPSTATUS_SOLID) {
            [[_board elementDictionary] removeObjectForKey:elementKey];
            if(nextTile == MAPSTATUS_CRACKED) {
                [[_board elementDictionary] removeObjectForKey:nextKey];
                [[[_board board] objectAtIndex:intKey] setStatus:MAPSTATUS_VOID];
            }
        } else {
            NSNumber *index = [NSNumber numberWithInteger:nextPos.y * BOARD_SIZE_X + nextPos.x];
            // CHANGE THIS WHEN TWO OR MORE OBJECTS CAN BE PLACED ON THE SAME TILE!
            [[_board elementDictionary] removeObjectForKey:index];
            [_board moveElementFrom:posPreMove To:nextPos];
        }
        //nextTile should invoke its "doAction"...
    }
}

-(void)setupBoardWithWorld: (NSInteger)world AndLevel: (NSInteger)level {
    // Load the board.
    NSString *currentLevel = @"Level";
    currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%d", world]];
    if(level < 10) {
        currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%d%d", 0, level]];
    } else {
        currentLevel = [currentLevel stringByAppendingString:[NSString stringWithFormat:@"%d", level]];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:currentLevel ofType:@"splvl"];
    NSLog(@"p %@", currentLevel);
    [_board loadBoard:path];
    _starsLeft = [_board originalNumberOfStars];
}

-(NSMutableArray*)elementsAtPosition:(CGPoint)p {
    // RETURN STRING REPRESENTATION OF CLASSES?
    return [[[_board board] objectAtIndex:[Converter CGPointToKey:p]] elements];
}

/*
 *  Returns the status of a position on the board. */
-(NSInteger)getBoardStatusAtPosition:(CGPoint)p {
    BoardCoord *bc = [[_board board] objectAtIndex:p.y*BOARD_SIZE_X+p.x];
    return bc.status;
}

-(BOOL)isPointMovableTo:(CGPoint)p {
    return [_board isPointMovableTo:p];
}

-(void)takeStar: (Element*)star {
    [star movedTo];
    _starsLeft--;
}
@end
