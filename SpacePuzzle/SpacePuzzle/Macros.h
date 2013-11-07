/*
 
    Macros.h
    Space Puzzle

    Contains definitions of constants.
*/

#ifndef Block_Game_Macros_h
#define Block_Game_Macros_h

#define MAPSTATUS_UNPLAYABLE    -2
#define MAPSTATUS_VOID          -1
#define MAPSTATUS_EMPTY         0

#define TILESIZE                32
#define BOARD_PIXEL_BEGIN_X     32 // The pixel value that the actual board begins at.
#define BOARD_PIXEL_BEGIN_Y     64
#define BOARD_COORD_BEGIN_X     1  // The coordinate value that the actual board begins at.
#define BOARD_COORD_BEGIN_Y     1

#define BOARD_SIZE_X            10
#define BOARD_SIZE_Y            7

#define TOUCHES_BEGAN           @"TouchesBegan"
#define TOUCHES_MOVED           @"TouchesMoved"
#define TOUCHES_ENDED           @"TouchesEnded"
#define NEXT_BUTTON_TOUCHED     @"nextButtonTouched"
#endif
