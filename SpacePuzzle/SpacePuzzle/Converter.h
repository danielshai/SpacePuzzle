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
                              :(NSInteger) ssY winSize: (float) winSizeY;
+(CGPoint) convertStoneCoordToPixel:(NSInteger) x yCoord: (NSInteger) y;
@end
