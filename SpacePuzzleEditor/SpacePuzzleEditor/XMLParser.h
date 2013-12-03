//
//  XMLParser.h
//  SpacePuzzleEditor
//
//  Created by IxD on 13/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Position;
@class Box;
@class Star;
@class StarButton;
@class BridgeButton;
@class Bridge;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    NSString *currentElement;
    BOOL boardElement;
    BOOL startAstronautElement;
    BOOL startAlienElement;
    BOOL finishElement;
    BOOL rockElement;
    BOOL starElement;
    BOOL boardElements;
    BOOL starButtonElement;
    BOOL starButtonStar;
    BOOL bridgeElement;
    BOOL bridgeButtonElement;
    BOOL bridgeButtonBridge;
    BOOL platformElement;
    BOOL leverElement;
    BOOL leverPlatform;
    BOOL path;
    NSInteger tempXElement;
    NSInteger tempYElement;
    NSInteger tempXRef;
    NSInteger tempYRef;
    NSInteger pathX;
    NSInteger pathY;
    NSMutableArray *pathArray;
    BOOL tempBlockingElement;
    BOOL tempState;
    NSString *output;
}

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *board;
@property (nonatomic, retain) Position *startAstronaut;
@property (nonatomic, retain) Position *startAlien;
@property (nonatomic, retain) Position *finish;
@property (nonatomic, retain) NSMutableDictionary *elements;
-(id)initWithContentsOfURL:(NSURL *)url;
-(void)addOutput:(NSString *) string;
-(BOOL)writeToFile:(NSString *)fileName;
@end
