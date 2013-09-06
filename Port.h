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

@property (nonatomic, strong) NSNumber *port;
@property (nonatomic, strong) NSString *proto;

@end
