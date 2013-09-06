//
//  Sequence.h
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-13.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Port.h"

@interface Sequence : NSObject<NSCoding> {
    NSString *name;
    NSString *host;
    NSNumber *delay;
    NSMutableArray *ports;
}

- (id) init;

- (void) addPort:(unsigned short)port protocol:(NSString*)proto;
- (void) deletePortAtIndex: (NSUInteger)index;
- (Port*) portAtIndex: (NSUInteger)index;
- (NSUInteger) count;
- (void) dump;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSNumber *delay;
@property (nonatomic, strong) NSMutableArray *ports;

@end
