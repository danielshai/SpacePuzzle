/*
 
    Macros.h
    Space Puzzle

    Contains definitions of constants.
*/

#ifndef Block_Game_Macros_h
#define Block_Game_Macros_h

#define MAPSTATUS_VOID          -1
#define MAPSTATUS_SOLID         0
#define MAPSTATUS_CRACKED       1
#define BRUSH_ROCK              100
#define BRUSH_START             101
#define BRUSH_FINISH            102
#define BRUSH_STAR              103
#define BRUSH_ERASER            104
#define BRUSH_STARBUTTON        105
#define BRUSH_BRIDGEBUTTON      106

#define TILESIZE                44
#define BOARD_PIXEL_BEGIN_X     10 // The pixel value that the actual board begins at.
#define BOARD_PIXEL_BEGIN_Y     460
#define BOARD_COORD_BEGIN_X     1  // The coordinate value that the actual board begins at.
#define BOARD_COORD_BEGIN_Y     1
#define WIN_SIZE_X              320
#define WIN_SIZE_Y              480
#define BOARD_SIZE_X            7
#define BOARD_SIZE_Y            10

#define TOUCHES_BEGAN           @"TouchesBegan"
#define TOUCHES_MOVED           @"TouchesMoved"
#define TOUCHES_ENDED           @"TouchesEnded"
#define NEXT_BUTTON_TOUCHED     @"nextButtonTouched"
#define UNIT_MOVED              @"UnitMoved"
#define UNIT_WANTS_TO_MOVE      @"UnitWantsToMove"

#define CLASS_STARBUTTON        @"StarButton"
#define CLASS_STAR              @"Star"
#define STAR_BUTTON_REF         @"starbuttonstar"

#define RIGHT                   1
#define LEFT                    2
#define UP                      3
#define DOWN                    4
#endif
