/*
    BigL.h
    SpacePuzzle
 
    One of the player controlled units. This one is the "big guy", which has some other abilites compared
    to the "small guy".
*/

#import "Unit.h"

@interface BigL : Unit

-(void) move;
-(void) throwPlayer;
-(void) smash;

@end
