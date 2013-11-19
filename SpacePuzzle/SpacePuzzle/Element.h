/*
    Item.h
    SpacePuzzle
    
    Items are scattered on the board and can be used/picked up by the player.
*/

#import "Position.h"

@interface Element : Position
@property (nonatomic, assign) BOOL blocking;
-(id)initWithX: (NSInteger) x Y: (NSInteger) y;
-(void) doAction;
-(void) doMoveAction: (NSInteger) dir;

@end
