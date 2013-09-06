//
//  SequenceManager.h
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-13.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sequence.h"

@interface SequenceManager : NSObject {
    NSMutableArray *sequences;
}

+ (SequenceManager *)sharedSequenceManager;
- (id) initUniqueInstance;

- (void) save;
- (void) load;
- (NSUInteger) count;
- (Sequence*) sequenceAtIndex:(NSUInteger)index;
- (void) removeSequenceAtIndex:(NSUInteger)index;
- (void) addSequence:(Sequence*)sequence;

@end
