// Board.m
#import "Board.h"
#import "Macros.h"

@interface Board() {
@private
    NSInteger boardSizeX;
    NSInteger boardSizeY;
}
@end

@implementation Board

@synthesize board = _board;

-(id) init {
    if(self = [super init]){
        _board = [[NSMutableArray alloc] init];
        boardSizeX = 0;
        boardSizeY = 0;
    }
    return self;
}

/*
 *  Loads a board given a path, i.e. |BoardValues| are set for each coordinate on 
 *  the board. */
- (void) loadBoard:(NSString*) path {
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    // Gets the dimensions of the board.
    
    [_board removeAllObjects];
    
    //i = rows
    for (int i = 0; i < BOARD_SIZE_Y; i++) {
        //j = columns
        for (int j = 0; j < BOARD_SIZE_X; j++) {
            BoardCoord* bc = [[BoardCoord alloc] init];
            bc.x = j;
            bc.y = i;
            if(i*BOARD_SIZE_X + j < [arr count]) {
                bc.status = [[arr objectAtIndex:((i*BOARD_SIZE_X) + j)] intValue];
            } else {
                // If the |BoardList| is incomplete for some reason, fill it up with
                // |MAPSTATUS_UNPLAYABLE|.
                bc.status = MAPSTATUS_UNPLAYABLE;
            }
            //(Row number * y) + Column number)
            [_board insertObject:bc atIndex:((i*BOARD_SIZE_X) + j)];
        }
    }
    boardSizeX = BOARD_SIZE_X;
    boardSizeY = BOARD_SIZE_Y;
}

-(NSInteger) getBoardSizeX {
    return boardSizeX;
}

-(NSInteger) getBoardSizeY {
    return boardSizeY;
}

- (void) print {
    for (int i = 0; i < _board.count; i++) {
        if([[_board objectAtIndex:i] status] != MAPSTATUS_EMPTY)
            NSLog(@"%d IS TAKEN ON THE MAP!", i);
    }
}
@end