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

@implementation XMLParser
@synthesize parser = _parser;
@synthesize board = _board;
@synthesize start = _start;
@synthesize finish = _finish;
@synthesize elements = _elements;

-(id)init {
    if(self = [super init]) {
        output = @"";
        boardElement = NO;
        startElement = NO;
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
        startElement = NO;
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
        
        _board = [[NSMutableArray alloc] init];
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        _start = [[Position alloc] initWithX:0 Y:0];
        _finish = [[Position alloc] initWithX:0 Y:0];
        _elements = [[NSMutableDictionary alloc] init];
        [_parser setDelegate:self];
        [_parser parse];
    }
    return self;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    _start = [[Position alloc] initWithX:0 Y:0];
    _finish = [[Position alloc] initWithX:0 Y:0];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentElement = elementName;
    
    if([currentElement isEqualToString:@"coords"]) {
        boardElement = YES;
    } else if ([currentElement isEqualToString:@"start"]) {
        startElement = YES;
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
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"coords"]) {
        boardElement = NO;
    } else if ([elementName isEqualToString:@"start"]) {
        startElement = NO;
    } else if ([elementName isEqualToString:@"finish"]) {
        finishElement = NO;
    } else if ([elementName isEqualToString:CLASS_BOX]) {
        rockElement = NO;
        Box *r = [[Box alloc] initWithX:tempXElement Y:tempYElement];
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
        [_elements setObject:r forKey:index];
        
    } else if ([elementName isEqualToString:CLASS_STAR]) {
        starElement = NO;
        Star *s = [[Star alloc] initWithX:tempXElement Y:tempYElement];
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
        [_elements setObject:s forKey:index];
        
    } else if ([elementName isEqualToString:CLASS_BRIDGE]) {
        bridgeElement = NO;
        Bridge *b = [[Bridge alloc] initWithX:tempXElement Y:tempYElement Hidden:NO];
        b.blocking = tempBlockingElement;
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
        [_elements setObject:b forKey:index];
        
    } else if ([elementName isEqualToString:CLASS_STARBUTTON]) {
        starButtonElement = NO;
        NSNumber *starIndex = [NSNumber numberWithInteger:tempYRef*BOARD_SIZE_X+tempXRef];
        Star *s = [_elements objectForKey:starIndex];
        s.hidden = YES;
        StarButton *sb = [[StarButton alloc] initWithStar:s X:tempXElement Y:tempYElement];
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
        [_elements setObject:sb forKey:index];
        
    } else if ([elementName isEqualToString:CLASS_BRIDGEBUTTON]) {
        bridgeButtonElement = NO;
        NSNumber *bridgeIndex = [NSNumber numberWithInteger:tempYRef*BOARD_SIZE_X+tempXRef];
        Bridge *b = [_elements objectForKey:bridgeIndex];
        b.hidden = NO;
        BridgeButton *bb = [[BridgeButton alloc] initWithBridge:b X:tempXElement Y:tempYElement];
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
        [_elements setObject:bb forKey:index];
        NSLog(@"From: %ld %ld  To: %ld %ld",(long)bb.x,(long)bb.y,(long)b.x,(long)b.y);
        
    } else if ([elementName isEqualToString:STAR_BUTTON_REF]) {
        starButtonStar = NO;
    } else if ([elementName isEqualToString:BRIDGE_BUTTON_REF]) {
        bridgeButtonBridge = NO;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    int intString = [string intValue];
    
    if ([currentElement isEqualToString:@"coords"]) {
        boardElement = YES;
    } else if([currentElement isEqualToString:@"status"] && boardElement) {
        [_board insertObject:[NSNumber numberWithInt:intString] atIndex:[_board count]];
    } else if([currentElement isEqualToString:@"x"] && startElement) {
        _start.x = intString;
    } else if([currentElement isEqualToString:@"y"] && startElement) {
        _start.y = intString;
    } else if([currentElement isEqualToString:@"x"] && finishElement) {
        _finish.x = intString;
    } else if([currentElement isEqualToString:@"y"] && finishElement) {
        _finish.y = intString;
    } else if([currentElement isEqualToString:@"x"] && boardElement && !starButtonStar &&
              !bridgeButtonBridge) {
        tempXElement = intString;
    } else if([currentElement isEqualToString:@"y"] && boardElement && !starButtonStar &&
              !bridgeButtonBridge) {
        tempYElement = intString;
    } else if([currentElement isEqualToString:@"x"] && (starButtonStar || bridgeButtonBridge) ) {
        tempXRef = intString;
    } else if([currentElement isEqualToString:@"y"] && (starButtonStar || bridgeButtonBridge) ) {
        tempYRef = intString;
    } else if([currentElement isEqualToString:@"blocking"] && (rockElement || bridgeButtonElement) ) {
        tempBlockingElement = intString;
    } else if([currentElement isEqualToString:@"state"] && (starButtonElement || bridgeButtonElement) ) {
        tempState = intString;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    // INSERT ERROR CHECK HERE.
    output = @"";
    boardElement = NO;
    startElement = NO;
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
