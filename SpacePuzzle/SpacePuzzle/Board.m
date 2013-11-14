// Board.m
#import "Board.h"
#import "Macros.h"
#import "XMLParser.h"

@implementation Board

@synthesize board = _board;
@synthesize tilesize = _tilesize;
@synthesize boardSizeX = _boardSizeX;
@synthesize boardSizeY = _boardSizeY;
@synthesize boardBegin = _boardBegin;

-(id) init {
    if(self = [super init]){
        defaultBoardPath = @"/Users/IxD/SpacePuzzle/SpacePuzzleEditor/SpacePuzzleEditor/empty.splvl";
        _board = [[NSMutableArray alloc] init];
        _boardSizeX = 7;
        _boardSizeY = 10;
        _tilesize = 44;
        _boardBegin.x = 25;
        _boardBegin.y = 465;
    }
    return self;
}

/*
 *  Loads a board given a path, i.e. |BoardValues| are set for each coordinate on 
 *  the board. */
- (void) loadBoard:(NSString*) path {
    NSURL *s = [[NSURL alloc] initFileURLWithPath:path];
    _parser = [[XMLParser alloc] initWithContentsOfURL:s];
    
    [_board removeAllObjects];
    
    //i = rows
    for (int i = 0; i < _boardSizeY; i++) {
        //j = columns
        for (int j = 0; j < _boardSizeX; j++) {
            BoardCoord* bc = [[BoardCoord alloc] init];
            bc.x = j;
            bc.y = i;
            if(i*_boardSizeX + j < [[_parser board] count]) {
                bc.status = [[[_parser board] objectAtIndex:((i*_boardSizeX) + j)] intValue];
            } else {
                // If the |BoardList| is incomplete for some reason, fill it up with
                // |MAPSTATUS_UNPLAYABLE|.
                bc.status = MAPSTATUS_VOID;
            }
            //(Row number * y) + Column number)
            [_board insertObject:bc atIndex:((i*_boardSizeX) + j)];
        }
    }
    //_boardSizeX = BOARD_SIZE_X;
    //_boardSizeY = BOARD_SIZE_Y;
}

-(void)createDefaultBoard {
    [_board removeAllObjects];
    NSURL *path = [[NSURL alloc] initFileURLWithPath:defaultBoardPath];

    _parser = [[XMLParser alloc] initWithContentsOfURL:path];
    
    for (int i = 0; i < _boardSizeY; i++) {
        //j = columns
        for (int j = 0; j < _boardSizeX; j++) {
            BoardCoord* bc = [[BoardCoord alloc] init];
            bc.x = j;
            bc.y = i;
            bc.status = [[[_parser board] objectAtIndex:((i*_boardSizeX) + j)] intValue];
            
            //(Row number * y) + Column number)
            [_board insertObject:bc atIndex:((i*_boardSizeX) + j)];
        }
    }
}

/* 
 *  Saves the board to a given path/filename. First you have to add the output to the parser then finally
 *  the actual write to file. */
-(void)saveBoard:(NSString *)fileName {
    // Add the board in xml format.
    [_parser addOutput:@"<board>"];
    for (int i = 0; i < _boardSizeY; i++) {
        for (int j = 0; j < _boardSizeX; j++) {
            BoardCoord* bc = [_board objectAtIndex:(i*_boardSizeX + j)] ;
            NSString *s = @"\n<status>";
            s = [s stringByAppendingString:[@(bc.status) stringValue]];
            s = [s stringByAppendingString:@"</status>"];
            [_parser addOutput:s];
        }
    }
    [_parser addOutput:@"\n</board>"];
    // End of board.
    
    [_parser writeToFile:fileName];
}
@end