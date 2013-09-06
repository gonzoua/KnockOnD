//
//  SettingsViewController.h
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-11.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SequenceViewController.h"
#import "Sequence.h"
@protocol SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish: (id)sender;
@end

@interface SettingsViewController : UIViewController <SequenceViewControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
    Sequence *currentSeq;
    bool addingNew;
    IBOutlet UITableView *seqTableView;
    id<SettingsViewControllerDelegate> __weak delegate;
}

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

- (IBAction) add: (id)sender;
- (IBAction) done: (id)sender;
- (void) editSequence;

@end