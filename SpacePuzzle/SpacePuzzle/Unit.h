/*
    Unit.h
    SpacePuzzle
 
    A parent class the playable units in the game.
*/

#import "Position.h"

@interface Unit : Position
@property (nonatomic, assign) BOOL isPlayingOnLevel;
-(void) move;

@end
