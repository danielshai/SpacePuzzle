//
//  BoardController.m
//  SpacePuzzle
//
//  Created by IxD on 05/12/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "BoardController.h"
#import "MainScene.h"
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

-(BOOL)unitWantsToMoveFrom:(CGPoint)from To:(CGPoint)to WithSwipe:(BOOL)swipe UnitWasAstronatut:(BOOL)isAstronaut {
    NSInteger dir = [Converter convertCoordsTo:to Direction:from];
    BoardCoord *bcFrom = [[_board board] objectAtIndex:[Converter CGPointToKey:from]];
    CGPoint otherUnitPoint = CGPointMake(self.spController.nextUnit.x, self.spController.nextUnit.y);
    
    // First check if the move is valid on the board, i.e. is inside board, and not diagonal, etc.
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
        for (int i = 0; i < bcFrom.elements.count; i++) {
            Element *eFrom = [[bcFrom elements] objectAtIndex:i];
            // Checks if the element moved from is a button, and the third condition checks if
            // the other unit is still on the button, which means the button shouldn't be deactivated.
            if( ([eFrom isKindOfClass:[StarButton class]] || [eFrom isKindOfClass:[BridgeButton class]])
            && ![Converter isPoint:from sameAsPoint:otherUnitPoint] ) {
                // Buttons should be deactivated if left.
                if([eFrom isKindOfClass:[StarButton class]]) {
                    StarButton *sb = (StarButton*)eFrom;
                    [sb unitLeft];
                    CGPoint p = CGPointMake(sb.star.x, sb.star.y);
                    BoardCoord *bc = [self boardCoordForPoint:p];
                    [self.spController updateElementsAtPosition:p withArray:bc.elements];
                    [self.spController updateElementsAtPosition:from withArray:bcFrom.elements];
                } else if ([eFrom isKindOfClass:[BridgeButton class]]) {
                    BridgeButton *bb = (BridgeButton*)eFrom;
                    [bb unitLeft];
                    CGPoint p = CGPointMake(bb.bridge.x, bb.bridge.y);
                    BoardCoord *bc = [self boardCoordForPoint:p];
                    [self.spController updateElementsAtPosition:p withArray:bc.elements];
                    [self.spController updateElementsAtPosition:from withArray:bcFrom.elements];
                    
                    if([Converter isPoint:p sameAsPoint:otherUnitPoint]) {
                        //[self.scene unitFallingAnimation];
                    }
                }
            }
        }
    
        /* Checks elements on the tile moved to. */
        BoardCoord *bcTo = [[_board board] objectAtIndex:[Converter CGPointToKey:to]];
    
        for (int i = 0; i < bcTo.elements.count; i++) {
            // If the element is a star.
            Element *eTo = [[bcTo elements] objectAtIndex:i];
            if([eTo isKindOfClass:[Star class]] && ![eTo hidden]) {
                [self takeStar:eTo];
                [bcTo.elements removeObject:eTo];
                [self.spController updateElementsAtPosition:from withArray:bcFrom.elements];
                [self.spController updateElementsAtPosition:to withArray:bcTo.elements];
            } else if([eTo isKindOfClass:[StarButton class]]) {
                [self doActionOnStarButton:eTo];
                [self.spController updateElementsAtPosition:from withArray:bcFrom.elements];
            //    [self.spController updateElementsAtPosition:to withArray:bcTo.elements];
            } else if([eTo isKindOfClass:[BridgeButton class]]) {
                [self doActionOnBridgeButton:eTo];
            }
        }
        return YES;
    }
    BoardCoord *bcTo = [self boardCoordForPoint:to];
    
    // Point isn't movable to, but if unit is astronaut and element blocking is a box, move it!
    // |swipe| needs to be YES because moving boxes cannot be done by single tap.
    for (int i = 0; i < bcTo.elements.count; i++) {
        Element *eTo = [[bcTo elements] objectAtIndex:i];
        if([eTo isKindOfClass:[Box class]] && swipe && isAstronaut) {
            [self moveBox:eTo InDirection:dir];
        }
    }
    return NO;
}

-(void)updateElementsMovedToPoint:(CGPoint)to {
    /* Checks elements on the tile moved to. */
    BoardCoord *bcTo = [[_board board] objectAtIndex:[Converter CGPointToKey:to]];
    
    for (int i = 0; i < bcTo.elements.count; i++) {
        // If the element is a star.
        Element *eTo = [[bcTo elements] objectAtIndex:i];
        if([eTo isKindOfClass:[Star class]] && ![eTo hidden] && ![eTo taken]) {
            [self takeStar:eTo];
            [bcTo.elements removeObject:eTo];
            [self.spController updateElementsAtPosition:to withArray:bcTo.elements];
        } else if([eTo isKindOfClass:[StarButton class]]) {
            [self doActionOnStarButton:eTo];
            [self.spController updateElementsAtPosition:to withArray:bcTo.elements];
        } else if([eTo isKindOfClass:[BridgeButton class]]) {
            //      [self doActionOnBridgeButton:eTo];
        }
    }
}

-(void)unitWantsToDoActionAt:(CGPoint)loc From:(CGPoint)from IsBigL:(BOOL)isBigL {
    BoardCoord *bc;
    if([_board isPointWithinBoard:loc]) {
        bc = [[_board board] objectAtIndex:[Converter CGPointToKey:loc]];
    } else {
        return;
    }
    
    for (int i = 0; i < bc.elements.count; i++) {
        Element *e = [bc.elements objectAtIndex:i];
  
        if ([e isKindOfClass:[Box class]] && isBigL && [Converter isPoint:loc NextToPoint:from]){
            [self doActionOnBoxSmash:e];
        } else if ([e isKindOfClass:[StarButton class]] && [Converter isPoint:loc sameAsPoint:from]) {
            //[self doActionOnStarButton:e];
        } else if ([e isKindOfClass:[BridgeButton class]] && [Converter isPoint:from sameAsPoint:loc]) {
            //       [self doActionOnBridgeButton:e];
        } else if ([e isKindOfClass:[PlatformLever class]] && [Converter isPoint:from sameAsPoint:loc]) {
            //       [self doActionOnPlatformLever:e];
        }
    }
}

-(void)doActionOnBoxSmash:(Element*)box {
    CGPoint p = CGPointMake(box.x, box.y);
    BoardCoord *bc = [[_board board] objectAtIndex:[Converter CGPointToKey:p]];
    [self removeElement:box FromBoardCoord:bc];
    
    for (int i = 0; i < bc.elements.count; i++) {
        Element *e = [bc.elements objectAtIndex:i];
        if([e isKindOfClass:[StarButton class]]) {
            StarButton *sb = (StarButton*)e;
            [sb unitLeft];
            [self.scene updateElementsAtPosition:p withArray:bc.elements];
            // The star.
            CGPoint starPos = CGPointMake(sb.star.x, sb.star.y);
            BoardCoord *bcStar = [[_board board] objectAtIndex:[Converter CGPointToKey:starPos]];
            [self.spController updateElementsAtPosition:starPos withArray:bcStar.elements];
        } else if([e isKindOfClass:[BridgeButton class]]) {
            BridgeButton *bb = (BridgeButton*)e;
            [bb unitLeft];
            [self.scene updateElementsAtPosition:p withArray:bc.elements];
            // The bridge.
            CGPoint bridgePos = CGPointMake(bb.bridge.x, bb.bridge.y);
            BoardCoord *bcBridge = [[_board board] objectAtIndex:[Converter CGPointToKey:bridgePos]];
            [self.spController updateElementsAtPosition:bridgePos withArray:bcBridge.elements];
            
            // ADD FALLING ANIMATION HERE!!!!!
            // COULD YOU HAVE 2 METHODS: boxLeftPos AND boxArrivedAtPos THAT GETS CALLED FROM HERE AND
            // MOVE. THERE WE CAN DO FALLING ANIMATION AND SUCH SO THAT WE DON'T NEED TO COPY/PASTE.
            [self.spController checkIfUnitIsFalling];
        }
    }
    
    [self.spController updateElementsAtPosition:p withArray:bc.elements];
}

-(void)moveBox: (Element*)rock InDirection: (NSInteger)dir {
    NSNumber *nextKey;
    CGPoint nextPos;
    NSMutableArray *eArray;
    CGPoint rockPoint = CGPointMake(rock.x, rock.y);
    BoardCoord *bcFrom = [[_board board] objectAtIndex:[Converter CGPointToKey:rockPoint]];
    BoardCoord *bcNext;
    CGPoint otherUnitPos = CGPointMake(self.spController.nextUnit.x, self.spController.nextUnit.y);
    
    if (dir == RIGHT) {
        // Check if at the edge of the board, if so do nothing.
        if(rock.x >= BOARD_SIZE_X-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x + 1];
        nextPos = CGPointMake(rock.x + 1, rock.y);
        bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
        eArray = [bcNext elements];
    } else if (dir == LEFT) {
        if(rock.x <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x - 1];
        nextPos = CGPointMake(rock.x-1, rock.y);
        bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
        eArray = [bcNext elements];
    } else if (dir == UP) {
        if(rock.y <= 0) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y-1)*BOARD_SIZE_X + rock.x];
        nextPos = CGPointMake(rock.x, rock.y-1);
        bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
        eArray = [bcNext elements];
    } else if (dir == DOWN){
        if(rock.y >= BOARD_SIZE_Y-1) {
            return;
        }
        nextKey = [NSNumber numberWithInt:(rock.y+1)*BOARD_SIZE_X + rock.x];
        nextPos = CGPointMake(rock.x, rock.y+1);
        bcNext = [[_board board] objectAtIndex:[Converter CGPointToKey:nextPos]];
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
    
    [self.scene moveElementFrom:rockPoint WithIndex:bcFrom.elements.count-1 To:nextPos OntoStatus:bcNext.status InDir:dir];
    
    CGPoint posPreMove = CGPointMake(rock.x, rock.y);
    [rock doMoveAction:dir];
    rockPoint = CGPointMake(rock.x, rock.y);
    BoardCoord *bcMovedTo = [[_board board] objectAtIndex:[Converter CGPointToKey:rockPoint]];
    
    // Do the move on the box.
    CGPoint curPosTile = CGPointMake([[_spController currentUnit] x], [[_spController currentUnit] y]);
    NSInteger currentTile = [[[_board board] objectAtIndex:[Converter CGPointToKey:curPosTile]] status];
    // Remove box from bcFrom.
    [self removeElement:rock FromBoardCoord:bcFrom];
    NSInteger nextTile = [[[_board board] objectAtIndex:[Converter CGPointToKey:rockPoint]] status];
    
    if(nextTile == MAPSTATUS_SOLID) {
        [self addElement:rock ToBoardCoord:bcMovedTo];
       // [self boxMovedToPoint:rockPoint FromPoint:posPreMove OtherUnitPos:otherUnitPos];
    }
    BoardCoord *bc = [[_board board] objectAtIndex:[Converter CGPointToKey:curPosTile]];

    if(currentTile == MAPSTATUS_CRACKED) {
        [[_board board] objectAtIndex:currentTile];
        bc.status = MAPSTATUS_VOID;
        [bc.elements removeAllObjects];
        [self.scene refreshTileAtPosition:curPosTile WithStatus:bc.status];
        //[self.scene moveElementFrom:curPosTile WithIndex:0 To:nextPos OntoStatus:MAPSTATUS_VOID InDir:dir];
    }
    // SHOULD BE ADDED BACK. NO!
    //[self.spController updateElementsAtPosition:rockPoint withArray:bcMovedTo.elements];
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
-(void)boxMovedToPoint:(CGPoint)p FromPoint:(CGPoint)pFrom InDirection:(NSInteger)dir {
    NSInteger removeIndex = -1;
    CGPoint otherUnitPos = CGPointMake(self.spController.nextUnit.x, self.spController.nextUnit.y);
    
    if([_board isPointWithinBoard:p] && [_board isPointWithinBoard:pFrom]) {
        BoardCoord *bc = [[_board board] objectAtIndex:[Converter CGPointToKey:p]];
        BoardCoord *bcFrom = [[_board board] objectAtIndex:[Converter CGPointToKey:pFrom]];
        
        // First, check the position the box was moved to.
        for (int i = 0; i < bc.elements.count; i++) {
            Element *e = [bc.elements objectAtIndex:i];
            if([e isKindOfClass:[StarButton class]]) {
                [self doActionOnStarButton:e];
           // [self.spController updateElementsAtPosition:p withArray:bc.elements];
            } else if([e isKindOfClass:[Star class]]) {
                removeIndex = i;
            } else if([e isKindOfClass:[BridgeButton class]]) {
                [self doActionOnBridgeButton:e];
            }
        // ADD MORE BUTTONS ETC.
        }
        // The box was moved to a star, remove it.
        if(removeIndex >= 0) {
            [bc.elements removeObjectAtIndex:removeIndex];
        }
        
        // Check elements on the point the box was moved away from. For example, buttons should be
        // deactivated if so.
        for (int i = 0; i < bcFrom.elements.count; i++) {
            Element *e = [bcFrom.elements objectAtIndex:i];
            if([e isKindOfClass:[StarButton class]]) {
                // Make into methods, plzzz
                [e unitLeft];
                
                // Updates the position of the button in the view.
                [self.scene updateElementsAtPosition:pFrom withArray:bcFrom.elements];
                //[self.scene updateElementsAtPosition:p withArray:bc.elements];
                
                // Updates the position of the star in the view.
                StarButton *sb = (StarButton*)e;
                CGPoint starPos = CGPointMake(sb.star.x, sb.star.y);
                BoardCoord *bcStar = [[_board board] objectAtIndex:[Converter CGPointToKey:starPos]];
                [self.scene updateElementsAtPosition:starPos withArray:bcStar.elements];
            } else if([e isKindOfClass:[BridgeButton class]]) {
                [e unitLeft];
                
                [self.scene updateElementsAtPosition:pFrom withArray:bcFrom.elements];
                //[self.scene updateElementsAtPosition:p withArray:bc.elements];
                
                BridgeButton *bb = (BridgeButton*)e;
                CGPoint bridgePos = CGPointMake(bb.bridge.x, bb.bridge.y);
                BoardCoord *bcBridge = [[_board board] objectAtIndex:[Converter CGPointToKey:bridgePos]];
                [self.scene updateElementsAtPosition:bridgePos withArray:bcBridge.elements];
             
                if([Converter isPoint:bridgePos sameAsPoint:otherUnitPos]) {
                   // [self.scene unitFallingAnimation];
                }
            }
        }
        NSInteger nextTile = [[[_board board] objectAtIndex:[Converter CGPointToKey:p]] status];
        // Box was moved to a cracked tile. The tile should be updated and animate box.
        if(nextTile == MAPSTATUS_CRACKED) {
            bc.status = MAPSTATUS_VOID;
            [bc.elements removeAllObjects];
            [self.scene refreshTileAtPosition:p WithStatus:bc.status];
            [self.scene moveElementFrom:p WithIndex:0 To:p OntoStatus:MAPSTATUS_VOID InDir:dir];
        }
    }
}

-(void)doActionOnStarButton:(Element *)button {
    CGPoint otherUnitPoint = CGPointMake(self.spController.nextUnit.x, self.spController.nextUnit.y);
    
    StarButton *sb = (StarButton*)button;
    [sb movedTo];
    CGPoint starPos = CGPointMake(sb.star.x, sb.star.y);
    CGPoint buttonPos = CGPointMake(sb.x, sb.y);
    BoardCoord *bcStar = [[_board board] objectAtIndex:[Converter CGPointToKey:starPos]];
    BoardCoord *bcButton = [[_board board] objectAtIndex:[Converter CGPointToKey:buttonPos]];
    // Updates the star connected to the button on the scene, i.e. showing it.
    if(!sb.star.taken) {
        // If the other unit is standing on the same spot as the star and button is on the star should be
        // taken by the player.
        if([Converter isPoint:starPos sameAsPoint:otherUnitPoint] && sb.state) {
            [self takeStar:sb.star];
            [bcStar.elements removeObject:sb.star];
            [self.spController updateElementsAtPosition:starPos withArray:bcStar.elements];
        }
    }

    [self.scene updateElementsAtPosition:starPos withArray:bcStar.elements];
    [self.scene updateElementsAtPosition:buttonPos withArray:bcButton.elements];
}

-(void)doActionOnBridgeButton: (Element*)button {
    
    BridgeButton *bb = (BridgeButton*)button;
    [bb movedTo];
    CGPoint buttonPos = CGPointMake(bb.x, bb.y);
    CGPoint bridgePos = CGPointMake(bb.bridge.x, bb.bridge.y);
    BoardCoord *bcButton = [[_board board] objectAtIndex:[Converter CGPointToKey:buttonPos]];
    BoardCoord *bcBridge = [[_board board] objectAtIndex:[Converter CGPointToKey:bridgePos]];
    
    // Updates the button on the scene.
    [_scene updateElementsAtPosition:buttonPos withArray:bcButton.elements];
    
    // Updates the bridge connected to the button on the scene, i.e. showing it.
    [_scene updateElementsAtPosition:bridgePos withArray:bcBridge.elements];
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
    if ([_board isPointWithinBoard:p]) {
        BoardCoord *bc = [[_board board] objectAtIndex:[Converter CGPointToKey:p]];
        return [bc elements];
    }
    return nil;
}

/*
 *  Returns the status of a position on the board. */
-(NSInteger)getBoardStatusAtPosition:(CGPoint)p {
    if([_board isPointWithinBoard:p]) {
        BoardCoord *bc = [[_board board] objectAtIndex:p.y*BOARD_SIZE_X+p.x];
        return bc.status;
    }
    return -100;
}

-(BoardCoord*) boardCoordForPoint:(CGPoint)p {
    if ([_board isPointWithinBoard:p]) {
        return [[_board board] objectAtIndex:[Converter CGPointToKey:p]];
    }
    return nil;
}

-(BOOL)isUnitOnVoid: (CGPoint)unit {
    BoardCoord *bc = [[_board board] objectAtIndex:[Converter CGPointToKey:unit]];
    return bc.status == MAPSTATUS_VOID;
}

-(BOOL)isPointMovableTo: (CGPoint)p {
    return [_board isPointMovableTo:p];
}

-(void)takeStar: (Element*)star {
    [star movedTo];
    _starsLeft--;
    [self.spController takeStar];
    [self.scene starTakenAtPosition:star CurrentTaken:3-_starsLeft];
}
@end
