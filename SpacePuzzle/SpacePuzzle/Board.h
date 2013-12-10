/*
    Board.h
    Space Puzzle
  
    The data model of the board. Stored as an array with |BoardValues|. Also loads the board
    given in a path.
*/

#import <Foundation/Foundation.h>
#import "BoardCoord.h"

@class XMLParser;
@class Element;
@class Box;
@class StarButton;
@class Star;
@class Bridge;
@class BridgeButton;
@class MovingPlatform;
@class PlatformLever;
@class Path;

@interface Board : NSObject

@property (nonatomic, strong) NSMutableArray *board;
@property (nonatomic, assign) NSInteger tilesize;
@property (nonatomic, assign) NSInteger boardSizeX;
@property (nonatomic, assign) NSInteger boardSizeY;
@property (nonatomic, assign) CGPoint boardBegin;
@property (nonatomic, retain) XMLParser *parser;
@property (nonatomic, retain) NSMutableDictionary *elementDictionary;
@property (nonatomic, retain) Position *startPosAstronaut;
@property (nonatomic, retain) Position *startPosAlien;
@property (nonatomic, retain) Position *finishPos;
@property (nonatomic, assign) NSInteger originalNumberOfStars;

-(void) moveElementFrom: (CGPoint)from To: (CGPoint)to;
-(void) loadBoard:(NSString*) path;
-(void) saveBoard:(NSString*) fileName;
-(void) createEmptyBoard;
-(void) startAndFinishExport;
-(void) addElementNamed:(NSString*) name AtPosition:(CGPoint) pos IsBlocking:(BOOL) block;
-(void) elementExport;
-(void) starExport: (Star*) star;
-(void) boxExport: (Box*) box;
-(void) starButtonExport: (StarButton*) sb;
-(void) bridgeExport: (Bridge*) b;
-(void) bridgeButtonExport: (BridgeButton*) bb;
-(void) movingPlatformExport: (MovingPlatform*) mp;
-(void) leverExport: (PlatformLever*) pl;
-(BOOL) isPointWithinBoard: (CGPoint)p;
-(BOOL) isPointMovableTo: (CGPoint)p;
-(BOOL) isPointCracked: (CGPoint)p ;
@end
