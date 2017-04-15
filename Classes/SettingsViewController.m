//
//  SettingsViewController.m
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-11.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "SettingsViewController.h"
#import "SequenceManager.h"

@implementation SettingsViewController

@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [seqTableView setEditing:YES];
    seqTableView.allowsSelectionDuringEditing = YES;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



- (IBAction) add: (id)sender 
{
    currentSeq = [[Sequence alloc] init];
    addingNew = YES;
    
    [self editSequence];
}

- (void)sequenceViewControllerDidFinish:(SequenceViewController *)controller accepted:(BOOL)accepted 
{    
    [self dismissViewControllerAnimated:YES completion:nil];

    if (accepted)
    {
        currentSeq.name = controller.name;
        currentSeq.host = controller.host;
        currentSeq.delay = [[NSNumber alloc] initWithUnsignedLong:controller.delay];
     
        NSMutableArray *ports = [[NSMutableArray alloc] init];
        // copy ports back
        for (Port *p in controller.ports) {
            [ports addObject:[[Port alloc] initWithPort:p]];
        }
        
        currentSeq.ports = ports;
        if (addingNew) {
            [[SequenceManager sharedSequenceManager] addSequence:currentSeq];
        }
        [[SequenceManager sharedSequenceManager] save];
        [seqTableView reloadData];
    }
    
    currentSeq = nil;   
    addingNew = NO;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Sequences";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    int x = [[SequenceManager sharedSequenceManager] count];

    return x;
}
// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return ([indexPath row] == 0) ? 50.0 : 38.0;
    return 38.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *kSectionCellID = @"SectionCellID";    
    NSLog(@"Before");    
    cell = [tableView dequeueReusableCellWithIdentifier:kSectionCellID];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSectionCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.opaque = NO;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
    }

    cell.textLabel.text = [[SequenceManager sharedSequenceManager] sequenceAtIndex:indexPath.row].name;
    NSLog(@"After");
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete;
}

- (void) editSequence 
{
    SequenceViewController *controller = [[SequenceViewController alloc] initWithNibName:@"SequenceView" bundle:nil];
    controller.delegate = self;
    controller.name = currentSeq.name;
    controller.host = currentSeq.host;
    controller.delay = [currentSeq.delay intValue];
    NSMutableArray *ports = [[NSMutableArray alloc] init];
    for (Port *p in currentSeq.ports) {
        [ports addObject:[[Port alloc] initWithPort:p]];
    }
    controller.ports = ports;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentSeq = [[SequenceManager sharedSequenceManager] sequenceAtIndex:indexPath.row];
    [self editSequence];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[SequenceManager sharedSequenceManager] removeSequenceAtIndex:indexPath.row];
        [[SequenceManager sharedSequenceManager] save];
        [seqTableView reloadData];
    } 
}

- (IBAction) done: (id)sender
{
    [self.delegate settingsViewControllerDidFinish:self];
}

- (BOOL)prefersStatusBarHidden
{
        return YES;
}

@end
