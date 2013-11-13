//
//  XMLParser.m
//  SpacePuzzleEditor
//
//  Created by IxD on 13/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser
@synthesize parser = _parser;
@synthesize board = _board;

-(id)initWithContentsOfURL:(NSURL *)url {
    if(self = [super init]) {
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

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    currentElement = @"ENDED";
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if([currentElement isEqualToString:@"status"]) {
        //NSLog(@"%@", string);
        int i = [string intValue];
        [_board insertObject:[NSNumber numberWithInt:i] atIndex:[_board count]];
    }
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {

}

@end
