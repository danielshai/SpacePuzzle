/*
    SpriteWithItem.h
    SpacePuzzle
    
    Extends the SpriteKit spritenode with a reference to an item. 
    BOARD SHOULD HAVE COLLECTION OF ITEMS. STORE IN A DICTIONARY.
*/

#import <SpriteKit/SpriteKit.h>
#import "Item.h"

@interface SpriteWithItem : SKSpriteNode
@property (nonatomic, strong) Item *item;

@end
