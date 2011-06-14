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

SYNTHESIZE_SINGLETON_FOR_CLASS(SequenceManager);

- (id)init
{
    self = [super init];
    if (self) {
        sequences = [[[NSMutableArray alloc] init] retain];
        [self load];
    }
    
    return self;
}

- (void) dealloc
{
    [sequences release];
    [super dealloc];
}

- (void) load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (defaults) {
        NSData *data = [defaults objectForKey:@"Sequences"];
        NSMutableArray *tmp = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];   
        if (tmp) {
            [sequences release];
            sequences = tmp;
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