//
//  SequenceManager.m
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-13.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "SynthesizeSingleton.h"
#import "SequenceManager.h"


@implementation SequenceManager

+ (SequenceManager*)sharedSequenceManager {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SequenceManager alloc] initUniqueInstance];
    });
    return shared;
}

- (id) initUniqueInstance {
    self = [self init];
    if (self) {
        sequences = [[NSMutableArray alloc] init];
        [self load];
    }
    
    return self;
}

- (void) load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        NSData *data = [defaults objectForKey:@"Sequences"];
        if (data != nil) {
            NSMutableArray *tmp = [NSKeyedUnarchiver unarchiveObjectWithData:data];   
            if (tmp) {
                sequences = tmp;
            }
        }
    }
}

- (void) save
{
    NSData *seqData = [NSKeyedArchiver archivedDataWithRootObject:sequences];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        [defaults setObject:seqData forKey:@"Sequences"];
        [defaults synchronize];
    }
}

- (NSUInteger) count
{
    return [sequences count];
}

- (Sequence*) sequenceAtIndex:(NSUInteger)index
{
    // sanity check
    if ([sequences count] <= index)
        return nil;
    
    return [sequences objectAtIndex:index];
}

- (void) removeSequenceAtIndex:(NSUInteger)index
{
    // Sanity check
    if ([sequences count] <= index)
        return;
    
    [sequences removeObjectAtIndex:index];
}

- (void) addSequence:(Sequence*)sequence
{
    NSLog(@"Adding to seq.. %@", sequences);
    [sequences addObject:sequence];
}

@end