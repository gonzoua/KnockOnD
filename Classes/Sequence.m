//
//  Sequence.m
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-13.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "Sequence.h"


@implementation Sequence

@synthesize name;
@synthesize host;
@synthesize delay;
@synthesize ports;

- (id) init 
{
    self = [super init];
    ports = [[NSMutableArray alloc] init];
    delay = [NSNumber numberWithInt:5];
    name = @"";
    host = @"";
    return self;
}


- (void) addPort:(unsigned short)port protocol:(NSString*)proto
{
    
    [ports addObject:[[Port alloc] initWithPortNumber:port proto:proto]];
}


- (void) deletePortAtIndex: (NSUInteger)index
{
    [ports removeObjectAtIndex:index];
}


- (Port*) portAtIndex: (NSUInteger)index
{
    return [ports objectAtIndex:index];
}

- (NSUInteger) count
{
    return [ports count];
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init]) {
        self.ports = [coder decodeObjectForKey:@"ports"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.host = [coder decodeObjectForKey:@"host"];
        self.delay = [coder decodeObjectForKey:@"delay"];
    }
    
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:host forKey:@"host"];
    [coder encodeObject:delay forKey:@"delay"];
    [coder encodeObject:ports forKey:@"ports"];
}

- (void) dump
{
    for (Port* port in ports) {
        NSLog(@"%@/%@", [port port], [port proto]);
    }
}

@end