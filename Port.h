//
//  Port.h
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-12.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Port : NSObject<NSCoding> {
    NSNumber *port;
    NSString *proto;
};

- (id) initWithPortNumber: (NSUInteger)port proto:(NSString*)proto;
- (id) initWithPort: (Port*)portObj;
- (void) dealloc;

@property (nonatomic, retain) NSNumber *port;
@property (nonatomic, retain) NSString *proto;

@end
