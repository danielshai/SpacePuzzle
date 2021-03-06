/*
    Converter.h
    Space Puzzle
 
    Contains static utility functions in the form of converters between pixels and board
    coordinates.
*/
#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>
#import "Macros.h"

@interface Converter : NSObject

+(NSInteger) convertXPixelToCoordRefined:(SKSpriteNode*) sprite shift: (NSInteger) spriteShift;
+(NSInteger) convertYPixelToCoordRefined:(SKSpriteNode*) sprite shift: (NSInteger) spriteShift;
+(NSInteger) convertXPixelToCoord:(NSInteger) pixel shift: (NSInteger) spriteShift;
+(NSInteger) convertYPixelToCoord:(NSInteger) pixel shift: (NSInteger) spriteShift;
+(CGPoint) convertCoordToPixel:(NSInteger) coordX yCoord: (NSInteger) coordY shiftX: (NSInteger)ssX shiftY
                              :(NSInteger) ssY winSizeY: (float) winSizeY;
+(CGPoint) convertStoneCoordToPixel:(NSInteger) x yCoord: (NSInteger) y;
+(CGPoint) convertMousePosToCoord:(CGPoint)pos;
+(CGPoint) convertCoordToPixel:(CGPoint)coord;
+(CGPoint) convertFlatIndexToTwoDimensions:(NSInteger) index;
+(NSInteger) CGPointToKey: (CGPoint)p;
+(BOOL) isPoint: (CGPoint)p1 DiagonallyAdjacentWithPoint: (CGPoint)p2;
+(BOOL) isPoint: (CGPoint)p1 NextToPoint: (CGPoint)p2;
+(BOOL) isPoint: (CGPoint)p1 sameAsPoint: (CGPoint)p2;
//+(BOOL) isPoint: (CGPoint)p1
+(NSInteger) convertCoordsTo:(CGPoint) object Direction: (CGPoint) u;
@end
