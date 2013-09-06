//
//  KnockOnDAppDelegate.h
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-10.
//  Copyright BluezBox 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KnockOnDViewController;

@interface KnockOnDAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    KnockOnDViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet KnockOnDViewController *viewController;

@end

