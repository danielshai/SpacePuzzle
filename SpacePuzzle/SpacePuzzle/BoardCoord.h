/*
    BoardCoord.h
    SpacePuzzle
    
    Represents a coordinate on the game board. Inherets from |Position| and adds status (which indicates
    what kind of coordinate it is, e.g. cracked) and a |Star| object (can be empty).
*/

#import "Position.h"

@interface BoardCoord : Position

@property (nonatomic, assign) NSInteger status;

@end
