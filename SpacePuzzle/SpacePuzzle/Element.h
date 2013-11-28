/*
    Item.h
    SpacePuzzle
    
    Items are scattered on the board and can be used/picked up by the player.
*/

#import "Position.h"

@interface Element : Position
@property (nonatomic, assign) BOOL blocking;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL taken;
-(id)initWithX: (NSInteger) x Y: (NSInteger) y;
-(id)initWithX:(NSInteger)x Y:(NSInteger)y Hidden: (BOOL)hidden;
-(id)initWithX:(NSInteger)x Y:(NSInteger)y Hidden: (BOOL)hidden Taken: (BOOL)taken;
-(NSNumber*) key;
-(void) doAction;
-(void) doMoveAction: (NSInteger) dir;
-(void) movedTo;
@end
