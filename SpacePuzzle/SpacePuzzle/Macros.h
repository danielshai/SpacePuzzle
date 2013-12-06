/*
 
    Macros.h
    Space Puzzle

    Contains definitions of constants.
*/

#ifndef Space_Puzzle_Macros_h
#define Space_Puzzle_Macros_h

#define PI                      3.1415

#define MAPSTATUS_VOID          -1
#define MAPSTATUS_SOLID         0
#define MAPSTATUS_CRACKED       1
#define BRUSH_ROCK              100
#define BRUSH_START_ASTRO       101
#define BRUSH_START_ALIEN       111
#define BRUSH_FINISH            102
#define BRUSH_STAR              103
#define BRUSH_ERASER            104
#define BRUSH_STARBUTTON        105
#define BRUSH_BRIDGEBUTTON      106
#define BRUSH_BRIDGE            107
#define BRUSH_LEVER             108
#define BRUSH_MOVING_PLATFORM   109
#define BRUSH_PATH              110

#define TIME_PER_FRAME_UNIT_WALK 0.03
#define TIME_PER_FRAME_BOX_MOVE 0.025

#define TILESIZE                44
#define BOARD_PIXEL_BEGIN_X     10 // The pixel value that the actual board begins at.
#define BOARD_PIXEL_BEGIN_Y     440
#define BOARD_COORD_BEGIN_X     1  // The coordinate value that the actual board begins at.
#define BOARD_COORD_BEGIN_Y     1
#define WIN_SIZE_X              320 // NOT GOOD TO HAVE HERE
#define WIN_SIZE_Y              480
#define BOARD_SIZE_X            7
#define BOARD_SIZE_Y            10

#define TOUCHES_BEGAN           @"TouchesBegan"
#define TOUCHES_MOVED           @"TouchesMoved"
#define TOUCHES_ENDED           @"TouchesEnded"
#define UNIT_MOVED              @"UnitMoved"
#define UNIT_WANTS_TO_MOVE      @"UnitWantsToMove"

#define CLASS_STARBUTTON        @"StarButton"
#define CLASS_STAR              @"Star"
#define CLASS_BRIDGE            @"Bridge"
#define CLASS_BOX               @"Box"
#define CLASS_BRIDGEBUTTON      @"BridgeButton"
#define CLASS_LEVER             @"PlatformLever"
#define CLASS_MOVING_PLATFORM   @"MovingPlatform"

#define STAR_BUTTON_REF         @"starbuttonstar"
#define BRIDGE_BUTTON_REF       @"bridgebuttonbridge"
#define LEVER_REF               @"leverplatform"

#define RIGHT                   1
#define LEFT                    2
#define UP                      3
#define DOWN                    4

#define BIG_L                   500
#define LITTLE_JOHN             501

#define RAINBOW_FROM_UP_TO_RIGHT    1001
#define RAINBOW_FROM_UP_TO_LEFT     1002
#define RAINBOW_FROM_RIGHT_TO_UP    1003
#define RAINBOW_FROM_RIGHT_TO_DOWN  1004
#define RAINBOW_FROM_DOWN_TO_LEFT   1005
#define RAINBOW_FROM_DOWN_TO_RIGHT  1006
#define RAINBOW_FROM_LEFT_TO_UP     1007
#define RAINBOW_FROM_LEFT_TO_DOWN   1008


#endif
