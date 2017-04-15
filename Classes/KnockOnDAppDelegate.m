//
//  KnockOnDAppDelegate.m
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-10.
//  Copyright BluezBox 2009. All rights reserved.
//

#import "KnockOnDAppDelegate.h"
#import "KnockOnDViewController.h"

@implementation KnockOnDAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    NSLog(@"Did Finish");
    // Override point for customization after app launch    
    [window setRootViewController:viewController];
    [window makeKeyAndVisible];
}




@end
