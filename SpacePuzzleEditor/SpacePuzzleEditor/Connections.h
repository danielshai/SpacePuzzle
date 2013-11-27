//
//  Connections.h
//  SpacePuzzleEditor
//
//  Created by IxD on 25/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Element;
@class Star;
@class StarButton;
@class Bridge;
@class BridgeButton;
@class PlatformLever;
@class MovingPlatform;

@interface Connections : NSObject
@property (nonatomic, retain) NSMutableArray *connections;
-(BOOL)addConnectionFrom: (Element*)from To: (Element*)to;
-(BOOL)removeConnection: (CGPoint) pos;
-(void)removeAllConnections;
-(void)createStarConnection: (Element*) from To: (Element*)to;
-(void)createBridgeConnection: (Element*) from To: (Element*)to;
-(void)createMovingPlatformConnection: (Element*) from To: (Element*)to;
+(BOOL)isValidConnection: (Element*) from To: (Element*)to;
+(BOOL)isAStarConnection: (Element*)from To: (Element*)to;
+(BOOL)isABridgeConnection: (Element*)from To: (Element*)to;
+(BOOL)isAMovingPlatformConnection: (Element*)from To: (Element*)to;
@end
