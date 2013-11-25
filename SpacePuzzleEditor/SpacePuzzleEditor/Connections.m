//
//  Connections.m
//  SpacePuzzleEditor
//
//  Created by IxD on 25/11/13.
//  Copyright (c) 2013 WMD. All rights reserved.
//

#import "Connections.h"
#import "Element.h"
#import "StarButton.h"
#import "Star.h"

@implementation Connections
@synthesize connections = _connections;

-(id)init {
    if(self = [super init]) {
        _connections = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 *  Adds a connection from an element to an element, if possible. If the elements are already connected,
 *  the connection is updated. */
-(BOOL)addConnectionFrom: (Element*)from To: (Element*)to {
    // First, check if any of the elements already are connected. If so, update with new connection.
    for(int i = 0; i < _connections.count; i++) {
        Element *first = [[_connections objectAtIndex:i] objectAtIndex:0];
        Element *second = [[_connections objectAtIndex:i] objectAtIndex:1];
        
        // Element has connection. Update.
        if((from.x == first.x && from.y == first.y) || (to.x == second.x && to.y == second.y)) {
            // The case of a starbutton to star.
            if([from isKindOfClass: [StarButton class]] && [to isKindOfClass: [Star class]]) {
                [self removeConnection:CGPointMake(from.x, from.y)];
                [self removeConnection:CGPointMake(to.x, to.y)];
                StarButton *sb = (StarButton*)from;
                Star *star = (Star*)to;
                sb.star = star;
                
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr insertObject:from atIndex:0];
                [arr insertObject:to atIndex:1];
                [_connections insertObject:arr atIndex:_connections.count];
                return YES;
            }
        }
    }
    
    // A new connection: check if the connection can be made, and if so create it and add to |_connections|. 
    if([from isKindOfClass: [StarButton class]] && [to isKindOfClass: [Star class]]) {
        StarButton *sb = (StarButton*)from;
        Star *star = (Star*)to;
        sb.star = star;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr insertObject:from atIndex:0];
        [arr insertObject:to atIndex:1];
        [_connections insertObject:arr atIndex:_connections.count];
        return YES;
    }
    
    return NO;
}

-(BOOL)removeConnection:(CGPoint)pos {
    for(int i = 0; i < _connections.count; i++) {
        Element *from = [[_connections objectAtIndex:i] objectAtIndex:0];
        Element *to = [[_connections objectAtIndex:i] objectAtIndex:1];
        
        if((pos.x == from.x && pos.y == from.y) || (pos.x == to.x && pos.y == to.y)) {
            if([from isKindOfClass: [StarButton class]] && [to isKindOfClass: [Star class]]) {
                StarButton *sb = (StarButton*)from;
                sb.star = nil;
                [_connections removeObjectAtIndex:i];
                return YES;
            }
        }
    }
    return NO;
}

-(void)removeAllConnections {
    [_connections removeAllObjects];
}
@end
