//
//  KnockOnDViewController.h
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-10.
//  Copyright BluezBox 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "Reachability.h"

@interface KnockOnDViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, SettingsViewControllerDelegate> {
    
    IBOutlet UIButton *knockButton;
    IBOutlet UIPickerView *pickerView;
    UIAlertView *progressAlert;
    UIActivityIndicatorView *progressView;
    NSArray *pickerViewArray;
    NetworkStatus internetConnectionStatus;
    NSInteger currentSeq;
}

@property NetworkStatus internetConnectionStatus;

- (IBAction)settings;
- (IBAction)knock;
- (void)doKnock;
- (void)hostNotFound;

@end

