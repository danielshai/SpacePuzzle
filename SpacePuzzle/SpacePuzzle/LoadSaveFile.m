//
//  LoadFile.m
//  SpacePuzzle
//
//  Created by Viktor on 03/12/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "LoadSaveFile.h"

@implementation LoadSaveFile : NSObject 

+(NSString*) loadFile{
    // Fetch NSDictionary containing possible saved state
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"SavedState.plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *unarchivedData = (NSDictionary *)[NSPropertyListSerialization
                                                    propertyListFromData:plistXML
                                                    mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                    format:&format
                                                    errorDescription:&errorDesc];
    
    NSNumber *world;
    NSString *currentWorld;
    NSNumber *level;
    NSString *currentLevel;
    NSString *currentState = @"Level";
    
    // If NSDictionary exists, look to see if it holds a saved game state
    if (!unarchivedData) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        return @"Error! Could not read file!";
    }
    else {
        // Load primitives
        world = [unarchivedData objectForKey:@"CurrentWorld"];
        currentWorld = [world stringValue];
        level = [unarchivedData objectForKey:@"CurrentLevel"];
        currentLevel = [level stringValue];
        // Adding current world number.
        currentState = [currentState stringByAppendingString:currentWorld];
        // Adding current level number.
        if([level integerValue] < 10) {
            currentState = [currentState stringByAppendingString:[NSString stringWithFormat:@"%d", 0]];
            currentState = [currentState stringByAppendingString:currentLevel];
        } else {
            currentState = [currentState stringByAppendingString:currentLevel];
        }
        NSLog(@"%@", currentState);
        return currentState;
    }
}

+(void) saveFileWithWorld:(NSInteger)world andLevel:(NSInteger)level {
    // We're going to save the data to SavedState.plist in our app's documents directory
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingString:@"/SavedState.plist"];
    
    // Create a dictionary to store all your data
    NSMutableDictionary *dataToSave = [NSMutableDictionary dictionary];

    NSNumber *currentWorld = [NSNumber numberWithInteger: world];
    [dataToSave setObject:currentWorld forKey:@"CurrentWorld"];

    NSNumber *currentLevel = [NSNumber numberWithInteger: level];
    [dataToSave setObject:currentLevel forKey:@"CurrentLevel"];
    
    // Create a serialized NSData instance, which can be written to a plist, from the data we've been storing in our NSMutableDictionary
    NSString *errorDescription;
    NSData *serializedData = [NSPropertyListSerialization dataFromPropertyList:dataToSave
                                                                        format:NSPropertyListXMLFormat_v1_0
                                                              errorDescription:&errorDescription];
    if(serializedData) {
        // Write file
        NSError *error;
        BOOL didWrite = [serializedData writeToFile:plistPath options:NSDataWritingFileProtectionComplete error:&error];
        
        if (didWrite)
            NSLog(@"File did write");
        else {
            NSLog(@"File write failed");
            NSLog(@"Error while writing: %@", [error description]);
        }
    }
    else {
        NSLog(@"Error in creating state data dictionary: %@", errorDescription);
    }
}
@end
