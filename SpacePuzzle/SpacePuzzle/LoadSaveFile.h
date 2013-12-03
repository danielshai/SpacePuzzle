//
//  LoadFile.h
//  SpacePuzzle
//
//  Created by Viktor on 03/12/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadSaveFile : NSObject

+(NSString*)loadFile;
+(void) saveFileWithWorld:(NSInteger)world andLevel:(NSInteger) level;

@end
