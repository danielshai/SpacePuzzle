//
//  XMLParser.h
//  SpacePuzzleEditor
//
//  Created by IxD on 13/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    NSString *currentElement;
}

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *board;
-(id)initWithContentsOfURL:(NSURL *)url;
@end
