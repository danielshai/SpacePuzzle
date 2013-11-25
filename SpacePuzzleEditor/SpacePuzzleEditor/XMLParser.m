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
    } else if ([currentElement isEqualToString:@"Box"]) {
        rockElement = YES;
    } else if ([currentElement isEqualToString:CLASS_STAR]) {
        starElement = YES;
    } else if ([currentElement isEqualToString:@"boardelements"]) {
        boardElement = YES;
    } else if ([currentElement isEqualToString:CLASS_STARBUTTON]) {
        starButtonElement = YES;
    } else if ([currentElement isEqualToString:STAR_BUTTON_REF]) {
        starButtonStar = YES;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"coords"]) {
        boardElement = NO;
    } else if ([elementName isEqualToString:@"start"]) {
        startElement = NO;
    } else if ([elementName isEqualToString:@"finish"]) {
        finishElement = NO;
    } else if ([elementName isEqualToString:@"Box"]) {
        rockElement = NO;
        Box *r = [[Box alloc] initWithX:tempXElement Y:tempYElement];
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
        [_elements setObject:r forKey:index];
    } else if ([elementName isEqualToString:CLASS_STAR]) {
        starElement = NO;
        Star *s = [[Star alloc] initWithX:tempXElement Y:tempYElement];
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
        [_elements setObject:s forKey:index];
    } else if ([elementName isEqualToString:CLASS_STARBUTTON]) {
        starButtonElement = NO;
        NSNumber *starIndex = [NSNumber numberWithInteger:tempYRef*BOARD_SIZE_X+tempXRef];
        Star *s = [_elements objectForKey:starIndex];
        s.hidden = YES;
        StarButton *sb = [[StarButton alloc] initWithStar:s X:tempXElement Y:tempYElement];
        NSNumber *index = [NSNumber numberWithInteger:tempYElement*BOARD_SIZE_X + tempXElement];
       // NSLog(@"starbutton: %ld %ld", (long)tempXElement,(long)tempYElement);
       // NSLog(@"starbutton: %ld %ld", (long)tempXRef,(long)tempYRef);
        [_elements setObject:sb forKey:index];
    } else if ([elementName isEqualToString:STAR_BUTTON_REF]) {
        starButtonStar = NO;
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
    } else if([currentElement isEqualToString:@"x"] && boardElement && !starButtonStar) {
        tempXElement = intString;
    } else if([currentElement isEqualToString:@"y"] && boardElement && !starButtonStar) {
        tempYElement = intString;
    } else if([currentElement isEqualToString:@"x"] && starButtonStar) {
        tempXRef = intString;
    } else if([currentElement isEqualToString:@"y"] && starButtonStar) {
        tempYRef = intString;
    } else if([currentElement isEqualToString:@"blocking"] && rockElement) {
        tempBlockingElement = intString;
    } else if([currentElement isEqualToString:@"state"] && starButtonElement) {
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
