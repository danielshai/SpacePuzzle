/*
    Board.h
    Space Puzzle
  
    The data model of the board. Stored as an array with |BoardValues|. Also loads the board
    given in a path.
*/

#import <Foundation/Foundation.h>
#import "BoardCoord.h"

@class XMLParser;
@class Rock;
@interface Board : NSObject

@property (nonatomic, strong) NSMutableArray *board;
@property (nonatomic, assign) NSInteger tilesize;
@property (nonatomic, assign) NSInteger boardSizeX;
@property (nonatomic, assign) NSInteger boardSizeY;
@property (nonatomic, assign) CGPoint boardBegin;
@property (nonatomic, retain) XMLParser *parser;
@property (nonatomic, retain) NSMutableDictionary *elementDictionary;
-(void) loadBoard:(NSString*) path;
-(void) saveBoard:(NSString*) fileName;
-(void) createEmptyBoard;
@end
