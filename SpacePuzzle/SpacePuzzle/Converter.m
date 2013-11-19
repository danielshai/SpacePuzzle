// Converter.m
#import "Converter.h"

@implementation Converter

/*
 *  Takes 2 points on the sprite's position into consideration when converting from pixel
 *  to board coordinate and is thus more refined than |convertXPixelToCoord|.
 *  |xLeft|:    The left edge of the sprite.
 *  |xLeft2|:   The left edge of the sprite + half of a tile size.
 *  If |xLeft| == |xLeft|, the sprite covers more of coordinate on the left edge of the
 *  sprite, and |xLeft| is returned. Otherwise, the sprite is closer to the coordinate to 
 *  the right of |xLeft|, that is |xLeft|+1, and thus that is returned. */
+(NSInteger) convertXPixelToCoordRefined:(SKSpriteNode*) sprite shift: (NSInteger) spriteShift {
    NSInteger xLeft = [self convertXPixelToCoord :(sprite.position.x) shift:spriteShift];
    NSInteger xLeft2 = [self convertXPixelToCoord:(sprite.position.x+TILESIZE/2) shift:spriteShift];
    if(xLeft == xLeft2) {
        return xLeft;
    } else {
        return xLeft+1;
    }
}

/*
 *  Works in the same way as |convertXPixelToCoordRefined|, but in Y instead. */
+(NSInteger) convertYPixelToCoordRefined:(SKSpriteNode*) sprite shift: (NSInteger) spriteShift {
    NSInteger yUp = [self convertYPixelToCoord:(sprite.position.y) shift:spriteShift];
    NSInteger yUp2 = [self convertYPixelToCoord:(sprite.position.y-TILESIZE/2) shift:spriteShift];
    if(yUp == yUp2) {
        return yUp;
    } else {
        return yUp+1;
    }
    return 1;
}

/*
 *  Converts an x pixel to a board coordinate using the |spriteShift| of a sprite to get
 *  its "true" value. */ 
+(NSInteger) convertXPixelToCoord:(NSInteger)pixel shift: (NSInteger) spriteShift {
    // |spriteShift| is a sprite-specific pixel shift. Since the anchor point is in the
    // centre of each sprite, and they have different widths, this is needed.
    
    return (pixel-spriteShift)/TILESIZE - BOARD_COORD_BEGIN_X; // -1 =
}

/*
 *  Converts a y pixel to a board coordinate using the |spriteShift| of a sprite to get
 *  its "true" value. */
+(NSInteger) convertYPixelToCoord:(NSInteger) pixel shift: (NSInteger) spriteShift {
    // |spriteShift| works in the same way for Y as for X, just height instead.
    
    // 7 is magic.
    pixel = TILESIZE*7+BOARD_PIXEL_BEGIN_Y - pixel;
    return (pixel-spriteShift)/TILESIZE - BOARD_COORD_BEGIN_Y;
}

/*
 *  Converts a board coordinate (x,y) to pixels (x,y) using the |spriteShift| of a sprite to 
 *  get the "true" value. */
+(CGPoint) convertCoordToPixel:(NSInteger) coordX yCoord: (NSInteger) coordY shiftX: (NSInteger)ssX shiftY:
                              (NSInteger) ssY winSizeY: (float) winSizeY {
    NSInteger xPixel;
    NSInteger yPixel;
    
    xPixel = coordX*TILESIZE+BOARD_PIXEL_BEGIN_X+ssX;
    yPixel = winSizeY - (coordY*TILESIZE+BOARD_PIXEL_BEGIN_Y + ssY);
    return CGPointMake(xPixel, yPixel);
}

/* 
 *  Converter used for void tiles in the setup. */
+(CGPoint) convertStoneCoordToPixel:(NSInteger) x yCoord: (NSInteger) y {
    return CGPointMake(x*TILESIZE+BOARD_PIXEL_BEGIN_X, 160 -
               y*TILESIZE+BOARD_PIXEL_BEGIN_Y+TILESIZE);
}

+(CGPoint) convertMousePosToCoord:(CGPoint)pos {
    CGFloat nx = (pos.x-BOARD_PIXEL_BEGIN_X) / TILESIZE; // -25 from begin pixel of board. CREATE VAR.
    CGFloat ny = (BOARD_PIXEL_BEGIN_Y - pos.y) / TILESIZE;
    nx = floorf(nx);
    ny = floorf(ny);
    return CGPointMake(nx, ny);
}

+(CGPoint) convertCoordToPixel:(CGPoint)coord {
    CGFloat x = coord.x * TILESIZE + BOARD_PIXEL_BEGIN_X;
    CGFloat y = BOARD_PIXEL_BEGIN_Y-(coord.y * TILESIZE + (WIN_SIZE_Y-BOARD_PIXEL_BEGIN_Y));
    return CGPointMake(x, y);
}

// NOT WORKING?
+(CGPoint) convertFlatIndexToTwoDimensions:(NSInteger)index {
    NSInteger x = index % BOARD_SIZE_Y;
    CGFloat y = index / BOARD_SIZE_Y;
    y = floorf(y);
    NSLog(@"Got: %ld, returned x: %ld y: %ld", (long)index, (long)x, (long)y);
    return CGPointMake(x, y);
}

+(NSInteger) convertCoordsTo:(CGPoint)object Direction:(CGPoint)unit {
    if (object.y > unit.y) {
        return DOWN;
    } else if (object.y < unit.y) {
        return UP;
    } else if (object.x > unit.x) {
        return RIGHT;
    } else if (object.x < unit.x) {
        return LEFT;
    } else
        return -1;
}

@end
