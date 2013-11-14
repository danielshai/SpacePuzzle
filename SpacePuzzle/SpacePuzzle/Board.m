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
@synthesize itemDictionary = _itemDictionary;

-(id) init {
    if(self = [super init]){
        _board = [[NSMutableArray alloc] init];
        _parser = [[XMLParser alloc] init];
        _boardSizeX = 7;
        _boardSizeY = 10;
        _tilesize = 44;
        _boardBegin.x = BOARD_PIXEL_BEGIN_X;
        _boardBegin.y = BOARD_PIXEL_BEGIN_Y;
        _itemDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/*
 *  Loads a board given a path, i.e. |BoardValues| are set for each coordinate on 
 *  the board. */
- (void) loadBoard:(NSString*) path {
    NSURL *s = [[NSURL alloc] initFileURLWithPath:path];
    _parser = [[XMLParser alloc] initWithContentsOfURL:s];
    
    [_itemDictionary removeAllObjects];
    [_board removeAllObjects];
    
    // The board tiles.
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
    
    // The items.
    // Få coords från XMLParser. Används de som key, object själva item. Skapa item mha ClassFromString (strängen fås från XMLParser.
    
    // id object = [[NSClassFromString(@"NameofClass") alloc] init];
}

-(void)createEmptyBoard {
    for (int i = 0; i < _boardSizeY; i++) {
        //j = columns
        for (int j = 0; j < _boardSizeX; j++) {
            BoardCoord* bc = [[BoardCoord alloc] init];
            bc.x = j;
            bc.y = i;
            bc.status = MAPSTATUS_VOID;
            
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