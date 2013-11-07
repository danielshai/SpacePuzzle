/*
    SpriteWithItem.h
    SpacePuzzle
    
    Extends the SpriteKit spritenode with a reference to an item. 
*/

#import <SpriteKit/SpriteKit.h>
#import "Item.h"

@interface SpriteWithItem : SKSpriteNode
@property (nonatomic, strong) Item *item;

@end
