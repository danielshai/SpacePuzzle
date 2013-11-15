/*
    Position.h
    SpacePuzzle

    Base class for all classes that has a position on the game board. Simply contains an x and y value.
*/

#import <Foundation/Foundation.h>

@interface Position : NSObject
-(id)initWithX: (NSInteger) x Y: (NSInteger) y;
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;


@end
