//
//  XMLParser.m
//  SpacePuzzleEditor
//
//  Created by IxD on 13/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "XMLParser.h"
#import "Position.h"

@implementation XMLParser
@synthesize parser = _parser;
@synthesize board = _board;
@synthesize start = _start;
@synthesize finish = _finish;

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
        _board = [[NSMutableArray alloc] init];
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [_parser setDelegate:self];
        [_parser parse];
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentElement = elementName;
}

-(void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue {
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    currentElement = @"ENDED";
    if ([elementName isEqualToString:@"board"]) {
        boardElement = NO;
    } else if ([elementName isEqualToString:@"start"]) {
        startElement = NO;
    } else if ([elementName isEqualToString:@"finish"]) {
        finishElement = NO;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    int intString = [string intValue];
    
    if ([currentElement isEqualToString:@"board"]) {
        boardElement = YES;
 
    } else if([currentElement isEqualToString:@"status"] && boardElement) {
        [_board insertObject:[NSNumber numberWithInt:intString] atIndex:[_board count]];
    }  if([currentElement isEqualToString:@"start"]) {
        startElement = YES;
        NSLog(@"FOUND START");
    } else if([currentElement isEqualToString:@"finish"]) {
        finishElement = YES;
    } else if([currentElement isEqualToString:@"x"]) {
        NSLog(@"%d",intString);
        _start.x = intString;
    } else if([currentElement isEqualToString:@"y"]) {
        _start.y = intString;
    }
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {

}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    // INSERT ERROR CHECK HERE.
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
