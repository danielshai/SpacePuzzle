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

#define TILESIZE                44
#define BOARD_PIXEL_BEGIN_X     10 // The pixel value that the actual board begins at.
#define BOARD_PIXEL_BEGIN_Y     465
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

#define RIGHT                   501
#define LEFT                    502
#define UP                      503
#define DOWN                    504
#endif
