/*
    Board.h
    Space Puzzle
  
    The data model of the board. Stored as an array with |BoardValues|. Also loads the board
    given in a path.
*/

#import <Foundation/Foundation.h>
#import "BoardCoord.h"

@interface Board : NSObject
@property (nonatomic, strong) NSMutableArray *board;
-(void) loadBoard:(NSString*) path;
-(NSInteger) getBoardSizeX;
-(NSInteger) getBoardSizeY;

@end
