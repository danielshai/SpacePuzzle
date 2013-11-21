/*
    Item.h
    SpacePuzzle
    
    Items are scattered on the board and can be used/picked up by the player.
*/

#import "Position.h"

@interface Element : Position
@property (nonatomic, assign) BOOL blocking;
@property (nonatomic, assign) BOOL hidden;
-(id)initWithX: (NSInteger) x Y: (NSInteger) y;
-(id)initWithX:(NSInteger)x Y:(NSInteger)y Hidden: (BOOL)hidden;
-(NSNumber*) key;
-(void) doAction;
-(void) doMoveAction: (NSInteger) dir;
-(void) movedTo;
@end
