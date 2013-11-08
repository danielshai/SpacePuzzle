/*
    Item.h
    SpacePuzzle
    
    Items are scattered on the board and can be used/picked up by the player.
*/

#import "Position.h"

@interface Item : Position
-(void) doAction;

@end
