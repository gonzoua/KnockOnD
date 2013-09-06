//
//  Port.m
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-12.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "Port.h"


@implementation Port 

@synthesize proto;
@synthesize port;

- (id) initWithPortNumber: (NSUInteger)num proto:(NSString*)protocol
{
    self = [super init];
    NSNumber *n = [[NSNumber alloc] initWithInt:num];
    [self setPort:n];
    [self setProto:protocol];
    
    return self;
}

- (id) initWithPort:(Port*) portObj
{
    if (self = [super init])
    {
        [self setPort:[portObj port]];
        [self setProto:[portObj proto]];
    }
    
    return self;
}


- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        [self setPort:[coder decodeObjectForKey:@"port"]];
        [self setProto:[coder decodeObjectForKey:@"proto"]];
    }
    
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.port forKey:@"port"];
    [coder encodeObject:self.proto forKey:@"proto"];
}

@end