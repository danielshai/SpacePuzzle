// Board.m
#import "Board.h"
#import "Macros.h"
#import "XMLParser.h"
#import "Rock.h"
#import "Element.h"

@implementation Board

@synthesize board = _board;
@synthesize tilesize = _tilesize;
@synthesize boardSizeX = _boardSizeX;
@synthesize boardSizeY = _boardSizeY;
@synthesize boardBegin = _boardBegin;
@synthesize elementDictionary = _elementDictionary;
@synthesize startPos = _startPos;
@synthesize finishPos = _finishPos;

-(id) init {
    if(self = [super init]){
        _board = [[NSMutableArray alloc] init];
        _parser = [[XMLParser alloc] init];
        _boardSizeX = 7;
        _boardSizeY = 10;
        _tilesize = 44;
        _boardBegin.x = BOARD_PIXEL_BEGIN_X;
        _boardBegin.y = BOARD_PIXEL_BEGIN_Y;
        _elementDictionary = [[NSMutableDictionary alloc] init];
        _startPos = [[Position alloc] initWithX:5 Y:8];
        _finishPos = [[Position alloc] initWithX:0 Y:0];
    }
    return self;
}

-(void)moveElementFrom:(CGPoint)from To:(CGPoint)to {
    NSNumber *oldFlatIndex = [NSNumber numberWithInt:from.y*_boardSizeX + from.x];
    NSNumber *newFlatIndex = [NSNumber numberWithInt:to.y*_boardSizeX + to.x];
    
    Element *e = [_elementDictionary objectForKey:oldFlatIndex];
    [_elementDictionary setObject:e forKey:newFlatIndex];
    [_elementDictionary removeObjectForKey:oldFlatIndex];
}

/*
 *  Loads a board given a path, i.e. |BoardValues| are set for each coordinate on 
 *  the board. */
- (void) loadBoard:(NSString*) path {
    NSURL *s = [[NSURL alloc] initFileURLWithPath:path];
    _parser = [[XMLParser alloc] initWithContentsOfURL:s];
    
    [_elementDictionary removeAllObjects];
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
    
    // Start and finish positions
    _startPos.x = [[_parser start] x];
    _startPos.y = [[_parser start] y];
    
    _finishPos.x = [[_parser finish] x];
    _finishPos.y = [[_parser finish] y];
    
    // The elements.
    _elementDictionary = [_parser elements];
}

/*
 *  Adds an element to the board model. Called when the user has used the editor to create an item. */
-(void)addElementNamed:(NSString *)name AtPosition:(CGPoint)pos IsBlocking:(BOOL)block{
    Element *element = [[NSClassFromString(name) alloc] init];
    element.x = pos.x;
    element.y = pos.y;
    element.blocking = block;
    NSNumber *flatIndex = [NSNumber numberWithInt:pos.y*_boardSizeX + pos.x];
    [_elementDictionary setObject:element forKey:flatIndex];
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
    [_elementDictionary removeAllObjects];
}

/* 
 *  Saves the board to a given path/filename. First you have to add the output to the parser then finally
 *  the actual write to file. */
-(void)saveBoard:(NSString *)fileName {
    // Add the tiles in xml format.
    [_parser addOutput:@"<board>"];
    [_parser addOutput:@"<coords>"];
    for (int i = 0; i < _boardSizeY; i++) {
        for (int j = 0; j < _boardSizeX; j++) {
            BoardCoord* bc = [_board objectAtIndex:(i*_boardSizeX + j)] ;
            NSString *s = @"<status>";
            s = [s stringByAppendingString:[@(bc.status) stringValue]];
            s = [s stringByAppendingString:@"</status>"];
            [_parser addOutput:s];
        }
    }
    [_parser addOutput:@"</coords>"];
    // End of tiles.
    
    // Start and finish pos in xml format.
    [self startAndFinishExport];
    [self elementExport];
    // Elements.
    // ...
    [_parser addOutput:@"</board>"];
    [_parser writeToFile:fileName];
}

/*
 *  Exports the start and finish tokens to the splvl file. */
-(void)startAndFinishExport {
    // Start pos.
    [_parser addOutput:@"<start>"];
    NSString *coordX = @"<x>";
    
    coordX = [coordX stringByAppendingString:[@(_startPos.x) stringValue]];
    coordX = [coordX stringByAppendingString:@"</x>"];
    [_parser addOutput:coordX];
    
    NSString *coordY = @"<y>";
    coordY = [coordY stringByAppendingString:[@(_startPos.y) stringValue]];
    coordY = [coordY stringByAppendingString:@"</y>"];
    [_parser addOutput:coordY];
    [_parser addOutput:@"</start>"];
    
    // Finish pos.
    [_parser addOutput:@"<finish>"];
    coordX = @"<x>";
    coordX = [coordX stringByAppendingString:[@(_finishPos.x) stringValue]];
    coordX = [coordX stringByAppendingString:@"</x>"];
    [_parser addOutput:coordX];
    
    coordY = @"<y>";
    coordY = [coordY stringByAppendingString:[@(_finishPos.y) stringValue]];
    coordY = [coordY stringByAppendingString:@"</y>"];
    [_parser addOutput:coordY];
    [_parser addOutput:@"</finish>"];
}

-(void)elementExport {
    [_parser addOutput:@"<boardelements>"];
   
    for(id key in _elementDictionary) {
        Element *e = [_elementDictionary objectForKey:key];
        NSString *element = @"<";
        
        element = [element stringByAppendingString:NSStringFromClass([e class])];
        element = [element stringByAppendingString:@">"];
        
        // Output actual data about the element.
        element = [element stringByAppendingString:@"<x>"];
        element = [element stringByAppendingString:[@(e.x) stringValue]];
        element = [element stringByAppendingString:@"</x>"];
        
        element = [element stringByAppendingString:@"<y>"];
        element = [element stringByAppendingString:[@(e.y) stringValue]];
        element = [element stringByAppendingString:@"</y>"];
        
        element = [element stringByAppendingString:@"<blocking>"];
        element = [element stringByAppendingString:[@(e.blocking) stringValue]];
        element = [element stringByAppendingString:@"</blocking>"];
        
        // End of this element.
        element = [element stringByAppendingString:@"</"];
        element = [element stringByAppendingString:NSStringFromClass([e class])];
        element = [element stringByAppendingString:@">"];
        
        [_parser addOutput:element];
    }
   
    [_parser addOutput:@"</boardelements>"];
}
@end