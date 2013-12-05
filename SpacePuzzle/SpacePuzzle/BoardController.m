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

-(void)unitMovedFrom:(CGPoint)from To:(CGPoint)to UnitWasAstronatut:(BOOL)isAstronaut {
    // If |bigL| is standing on a cracked tile and moves away from it. This will destroy the tile,
    // making it void, and also destroying the item on it.
    BoardCoord *bcFrom = [[_board board] objectAtIndex:[Converter CGPointToKey:from]];
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
           && ![Converter isPoint:from sameAsPoint:to]) {
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
