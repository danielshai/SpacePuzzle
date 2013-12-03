//
//  XMLParser.m
//  SpacePuzzleEditor
//
//  Created by IxD on 13/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "XMLParser.h"
#import "Position.h"
#import "Box.h"
#import "Macros.h"
#import "Star.h"
#import "StarButton.h"
#import "Bridge.h"
#import "BridgeButton.h"
#import "PlatformLever.h"
#import "MovingPlatform.h"
#import "Path.h"

@implementation XMLParser
@synthesize parser = _parser;
@synthesize board = _board;
@synthesize startAstronaut = _startAstronaut;
@synthesize finish = _finish;
@synthesize elements = _elements;
@synthesize startAlien = _startAlien;

-(id)init {
    if(self = [super init]) {
        output = @"";
        boardElement = NO;
        startAstronautElement = NO;
        finishElement = NO;
        _board = [[NSMutableArray alloc] init];
        [_parser setDelegate:self];
    }
    return self;
}

-(id)initWithContentsOfURL:(NSURL *)url {
    if(self = [super init]) {
        output = @"";
        boardElement = NO;
        startAstronautElement = NO;
        startAlienElement = NO;
        finishElement = NO;
        starElement = NO;
        boardElements = NO;
        starButtonElement = NO;
        starButtonStar = NO;
        tempBlockingElement = NO;
        tempState = NO;
        bridgeElement = NO;
        bridgeButtonElement = NO;
        bridgeButtonBridge = NO;
        leverElement = NO;
        leverPlatform = NO;
        platformElement = NO;
        path = NO;
        
        _board = [[NSMutableArray alloc] init];
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        _startAstronaut = [[Position alloc] initWithX:0 Y:0];
        _startAlien = [[Position alloc] initWithX:0 Y:0];
        _finish = [[Position alloc] initWithX:0 Y:0];
        _elements = [[NSMutableDictionary alloc] init];
        pathArray = [[NSMutableArray alloc] init];
        
        [_parser setDelegate:self];
        [_parser parse];
    }
    return self;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
   // _startAstronaut = [[Position alloc] initWithX:0 Y:0];
   // _finish = [[Position alloc] initWithX:0 Y:0];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentElement = elementName;
    
    if([currentElement isEqualToString:@"coords"]) {
        boardElement = YES;
    } else if ([currentElement isEqualToString:@"startastronaut"]) {
        startAstronautElement = YES;
    } else if ([elementName isEqualToString:@"startalien"]) {
        startAlienElement = YES;
    } else if ([currentElement isEqualToString:@"finish"]) {
        finishElement = YES;
    } else if ([currentElement isEqualToString:CLASS_BOX]) {
        rockElement = YES;
    } else if ([currentElement isEqualToString:CLASS_STAR]) {
        starElement = YES;
    } else if ([currentElement isEqualToString:@"boardelements"]) {
        boardElement = YES;
    } else if ([currentElement isEqualToString:CLASS_STARBUTTON]) {
        starButtonElement = YES;
    } else if ([currentElement isEqualToString:STAR_BUTTON_REF]) {
        starButtonStar = YES;
    } else if ([currentElement isEqualToString:CLASS_BRIDGE]) {
        bridgeElement = YES;
    } else if ([currentElement isEqualToString:CLASS_BRIDGEBUTTON]) {
        bridgeButtonElement = YES;
    } else if ([currentElement isEqualToString:BRIDGE_BUTTON_REF]) {
        bridgeButtonBridge = YES;
    } else if ([currentElement isEqualToString:CLASS_LEVER]) {
        leverElement = YES;
    } else if ([currentElement isEqualToString:CLASS_MOVING_PLATFORM]) {
        platformElement = YES;
    } else if ([currentElement isEqualToString:LEVER_REF]) {
        leverPlatform = YES;
    } else if ([currentElement isEqualToString:@"path"]) {
        path = YES;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"coords"]) {
        boardElement = NO;
    } else if ([elementName isEqualToString:@"startastronaut"]) {
        startAstronautElement = NO;
    } else if ([elementName isEqualToString:@"startalien"]) {
        startAlienElement = NO;
    } else if ([elementName isEqualToString:@"finish"]) {
        finishElement = NO;
    } else if ([elementName isEqualToString:CLASS_BOX]) {
        rockElement = NO;
        Box *r = [[Box alloc] initWithX:tempXElement Y:tempYElement];
        [_elements setObject:r forKey:r.key];
        
    } else if ([elementName isEqualToString:CLASS_STAR]) {
        starElement = NO;
        Star *s = [[Star alloc] initWithX:tempXElement Y:tempYElement];
        [_elements setObject:s forKey:s.key];
    } else if ([elementName isEqualToString:CLASS_BRIDGE]) {
        bridgeElement = NO;
        Bridge *b = [[Bridge alloc] initWithX:tempXElement Y:tempYElement Hidden:NO];
        b.blocking = tempBlockingElement;
        [_elements setObject:b forKey:b.key];
        
    } else if ([elementName isEqualToString:CLASS_STARBUTTON]) {
        starButtonElement = NO;
        NSNumber *starIndex = [NSNumber numberWithInteger:tempYRef*BOARD_SIZE_X+tempXRef];
        Star *s = [_elements objectForKey:starIndex];
        s.hidden = YES;
        StarButton *sb = [[StarButton alloc] initWithStar:s X:tempXElement Y:tempYElement];
        [_elements setObject:sb forKey:sb.key];
        
    } else if ([elementName isEqualToString:CLASS_BRIDGEBUTTON]) {
        bridgeButtonElement = NO;
        NSNumber *bridgeIndex = [NSNumber numberWithInteger:tempYRef*BOARD_SIZE_X+tempXRef];
        Bridge *b = [_elements objectForKey:bridgeIndex];
        b.hidden = NO;
        BridgeButton *bb = [[BridgeButton alloc] initWithBridge:b X:tempXElement Y:tempYElement];
        [_elements setObject:bb forKey:bb.key];
        
    } else if ([elementName isEqualToString:CLASS_MOVING_PLATFORM]) {
        platformElement = NO;
        MovingPlatform *mp = [[MovingPlatform alloc] initWithX:tempXElement Y:tempYElement];
        for(int i = 0; i < pathArray.count; i++) {
            Position *p = [pathArray objectAtIndex:i];
            [[[mp path] points] insertObject:p atIndex:i];
        }
 
        [_elements setObject:mp forKey:mp.key];
        // Clear the path array for the next |MovingPlatform|.
        [pathArray removeAllObjects];
        
    } else if ([elementName isEqualToString:CLASS_LEVER]) {
        leverElement = NO;
        NSNumber *platformIndex = [NSNumber numberWithInteger:tempYRef*BOARD_SIZE_X+tempXRef];
        MovingPlatform *mp = [_elements objectForKey:platformIndex];
        PlatformLever *pl = [[PlatformLever alloc] initWithMovingPlatform:mp X:tempXElement Y:tempYElement];
        [_elements setObject:pl forKey:pl.key];
        
    } else if ([elementName isEqualToString:STAR_BUTTON_REF]) {
        starButtonStar = NO;
    } else if ([elementName isEqualToString:BRIDGE_BUTTON_REF]) {
        bridgeButtonBridge = NO;
    } else if ([elementName isEqualToString:LEVER_REF]) {
        leverPlatform = NO;
    } else if ([elementName isEqualToString:@"path"]) {
        path = NO;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    int intString = [string intValue];
    
    if ([currentElement isEqualToString:@"coords"]) {
        boardElement = YES;
    } else if([currentElement isEqualToString:@"status"] && boardElement) {
        [_board insertObject:[NSNumber numberWithInt:intString] atIndex:[_board count]];
    } else if([currentElement isEqualToString:@"x"] && startAstronautElement) {
        _startAstronaut.x = intString;
    } else if([currentElement isEqualToString:@"y"] && startAstronautElement) {
        _startAstronaut.y = intString;
    } else if([currentElement isEqualToString:@"x"] && startAlienElement) {
        _startAlien.x = intString;
    } else if([currentElement isEqualToString:@"y"] && startAlienElement) {
        _startAlien.y = intString;
    } else if([currentElement isEqualToString:@"x"] && finishElement) {
        _finish.x = intString;
    } else if([currentElement isEqualToString:@"y"] && finishElement) {
        _finish.y = intString;
    } else if([currentElement isEqualToString:@"x"] && boardElement && !starButtonStar &&
              !bridgeButtonBridge && !leverPlatform && !path) {
        tempXElement = intString;
    } else if([currentElement isEqualToString:@"y"] && boardElement && !starButtonStar &&
              !bridgeButtonBridge && !leverPlatform && !path) {
        tempYElement = intString;
    } else if([currentElement isEqualToString:@"x"] && (starButtonStar || bridgeButtonBridge || leverPlatform ) ) {
        tempXRef = intString;
    } else if([currentElement isEqualToString:@"y"] && (starButtonStar || bridgeButtonBridge || leverPlatform) ) {
        tempYRef = intString;
    } else if([currentElement isEqualToString:@"blocking"] && (rockElement || bridgeButtonElement) ) {
        tempBlockingElement = intString;
    } else if([currentElement isEqualToString:@"state"] && (starButtonElement || bridgeButtonElement || leverElement) ) {
        tempState = intString;
    } else if([currentElement isEqualToString:@"x"] && path) {
        pathX = intString;
    } else if([currentElement isEqualToString:@"y"] && path) {
        pathY = intString;
        Position *p = [[Position alloc] initWithX:pathX Y:pathY];
        [pathArray insertObject:p atIndex:pathArray.count];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    // INSERT ERROR CHECK HERE.
    output = @"";
    boardElement = NO;
    startAstronautElement = NO;
    startAlienElement = NO;
    finishElement = NO;
    rockElement = NO;
    starElement = NO;
    boardElements = NO;
    starButtonElement = NO;
    starButtonStar = NO;
    tempState = NO;
    tempBlockingElement = NO;
    bridgeElement = NO;
    bridgeButtonElement = NO;
    bridgeButtonBridge = NO;
    leverPlatform = NO;
    leverElement = NO;
    platformElement = NO;
    path = NO;
    [pathArray removeAllObjects];
}

-(void)addOutput:(NSString *)string {
    output = [output stringByAppendingString:string];
}

/*
 *  Does the final write to a file using the output that has been added from the |addOutput| function. */
-(BOOL)writeToFile:(NSString *)fileName {
    NSError *error;
    
    if (![output writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"Could not write document out...");
        output = @"";
        return NO;
    }
    output = @"";
    return YES;
}
@end
