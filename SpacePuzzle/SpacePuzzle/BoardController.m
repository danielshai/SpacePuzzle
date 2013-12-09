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
#import "SpacePuzzleController.h"

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
                [bcTo.elements removeObject:eTo];
            } else if([eTo isKindOfClass:[StarButton class]]) {
                [self doActionOnStarButton:eTo OtherUnitPoint:otherUnitPoint];
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
    NSMutableArray *eArray;
    CGPoint rockPoint = CGPointMake(rock.x, rock.y);
    BoardCoord *bcFrom = [[_board board] objectAtIndex:[Converter CGPointToKey:rockPoint]];

    if (dir == RIGHT) {
        // Check if at the edge of the board, if so do nothing.
        if(rock.x >= BOARD_SIZE_X-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x + 1];
        nextPos = CGPointMake(rock.x + 1, rock.y);
        BoardCoord *bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
        eArray = [bcNext elements];
        
    } else if (dir == LEFT) {
        if(rock.x <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x - 1];
        nextPos = CGPointMake(rock.x-1, rock.y);
        BoardCoord *bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
        eArray = [bcNext elements];
    } else if (dir == UP) {
        if(rock.y <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y-1)*BOARD_SIZE_X + rock.x];
        nextPos = CGPointMake(rock.x, rock.y-1);
        BoardCoord *bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
        eArray = [bcNext elements];
    } else if (dir == DOWN){
        if(rock.y >= BOARD_SIZE_Y-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y+1)*BOARD_SIZE_X + rock.x];
        nextPos = CGPointMake(rock.x, rock.y+1);
        BoardCoord *bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
        eArray = [bcNext elements];
    }
    // Add more elements which cannot be pushed upon to if-statement.
    // ![e isKindOfClass:[Box class]] ---> !e isBlocking
    CGPoint finishPos = CGPointMake([_board finishPos].x, [_board finishPos].y);
    
    // Check the board of the next position. If the box cannot be moved there, return without moving.
    if([Converter isPoint:nextPos sameAsPoint:otherUnitPos] ||
       [Converter isPoint:finishPos sameAsPoint:nextPos]) {
        return;
    }
    
    // Do same for element array.
    for(int i = 0; i < eArray.count; i++) {
        Element *e = [eArray objectAtIndex:i];
        if ([e blocking]) {
            return;
        }
    }
    
    CGPoint posPreMove = CGPointMake(rock.x, rock.y);

    // Do the move on the box.
    [rock doMoveAction:dir];
    rockPoint = CGPointMake(rock.x, rock.y);
    BoardCoord *bcMovedTo = [[_board board] objectAtIndex:[Converter CGPointToKey:rockPoint]];
    
    // Remove rock from bcFrom.
    [self removeElement:rock FromBoardCoord:bcFrom];
    NSInteger nextTile = [[[_board board] objectAtIndex:[Converter CGPointToKey:rockPoint]] status];
    
    if(nextTile == MAPSTATUS_SOLID) {
        [self addElement:rock ToBoardCoord:bcMovedTo];
        [self boxMovedToPoint:rockPoint FromPoint:posPreMove OtherUnitPos:otherUnitPos];
    }
    
    [self.spController updateElementsAtPosition:rockPoint withArray:bcMovedTo.elements];
    [self.spController updateElementsAtPosition:posPreMove withArray:bcFrom.elements];
    
/*
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
 */
}

/* 
 *  A box was moved to a point. Check if there's any interaction between box and other elements 
 *  available. */
-(void)boxMovedToPoint:(CGPoint)p FromPoint:(CGPoint)pFrom OtherUnitPos:(CGPoint)otherUnitPos {
    BoardCoord *bc = [[_board board] objectAtIndex:[Converter CGPointToKey:p]];
    BoardCoord *bcFrom = [[_board board] objectAtIndex:[Converter CGPointToKey:pFrom]];
    
    for (int i = 0; i < bc.elements.count; i++) {
        Element *e = [bc.elements objectAtIndex:i];
        if([e isKindOfClass:[StarButton class]]) {
            [self doActionOnStarButton:e OtherUnitPoint:otherUnitPos];
            [self.spController updateElementsAtPosition:p withArray:bc.elements];
        }
        // ADD MORE BUTTONS ETC.
    }
    
    for (int i = 0; i < bcFrom.elements.count; i++) {
        Element *e = [bcFrom.elements objectAtIndex:i];
        if([e isKindOfClass:[StarButton class]]) {
            [e unitLeft];
            [self.spController updateElementsAtPosition:pFrom withArray:bcFrom.elements];
        }
    }
}

-(void)doActionOnStarButton:(Element *)button OtherUnitPoint:(CGPoint)otherUnitPoint {
    StarButton *sb = (StarButton*)button;
    [sb movedTo];
    CGPoint starPos = CGPointMake(sb.star.x, sb.star.y);
    CGPoint buttonPos = CGPointMake(sb.x, sb.y);
    // Updates the star connected to the button on the scene, i.e. showing it.
    if(!sb.star.taken) {
        // If the other unit is standing on the same spot as the star and button is on the star should be
        // taken by the player.
        if([Converter isPoint:starPos sameAsPoint:otherUnitPoint] && sb.state) {
            [self takeStar:sb.star];
        }
    }
    BoardCoord *bcStar = [[_board board] objectAtIndex:[Converter CGPointToKey:starPos]];
    BoardCoord *bcButton = [[_board board] objectAtIndex:[Converter CGPointToKey:buttonPos]];
    [self.spController updateElementsAtPosition:starPos withArray:bcStar.elements];
    [self.spController updateElementsAtPosition:buttonPos withArray:bcButton.elements];
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

-(void)addElement:(Element *)e ToBoardCoord:(BoardCoord *)bc {
    [bc.elements addObject:e];
}

-(BOOL)removeElement: (Element*)e FromBoardCoord: (BoardCoord*)bc {
    for (int i = 0; i < bc.elements.count; i++) {
        Element *eBc = [bc.elements objectAtIndex:i];
        if(eBc == e) {
            [bc.elements removeObjectAtIndex:i];
            return YES;
        }
    }
    
    return NO;
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
