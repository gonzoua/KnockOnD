//
//  SequenceViewController.m
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-11.
//  Copyright 2009 BluezBox. All rights reserved.
//

#import "SequenceViewController.h"
#import "Port.h"

@implementation NameCell

@synthesize textField;


@end

@implementation PortCell

@synthesize portField;
@synthesize protoSegment;


@end

@implementation SequenceViewController

@synthesize delegate;
@synthesize name;
@synthesize host;
@synthesize delay;
@synthesize ports;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        ports = [NSMutableArray array];
        name = @"";
        host = @"";
        delay = 55;
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) viewDidLoad
{
    [seqTableView setEditing:YES];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



#pragma mark UITableViewDataSource

- (id) init
{
    self = [super init];
    if (self) {
        // some extra initialization
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Sequence";
    
    return @"Ports";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    
    return [ports count] + 1;
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
    static NSString *kPortCellID = @"PortCellID";    
    static NSString *kNameCellID = @"NameCellID"; 
    
    if (indexPath.section == 0) {
        NameCell *nameCell;
        cell = [tableView dequeueReusableCellWithIdentifier:kNameCellID];
        nameCell = (NameCell *)cell;
        if (cell == nil) {
            nameCell = [[NameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNameCellID];
            cell = nameCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.opaque = NO;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
            
            UITextField *textField = [ [ UITextField alloc ] initWithFrame: CGRectMake(120, 10, 180, 25) ];
            textField.adjustsFontSizeToFitWidth = YES;
            textField.textColor = [UIColor blackColor];
            textField.font = [UIFont systemFontOfSize:17.0];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;        // no auto correction support
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            textField.textAlignment = NSTextAlignmentLeft;
            if (indexPath.row < 2)
                textField.keyboardType = UIKeyboardTypeASCIICapable; // use the default type input method (entire keyboard)
            else
                textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation; // use the default type input method (entire keyboard)
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            
            textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            textField.text = @"";
            nameCell.textField = textField;
            [ textField setEnabled: YES ];
            [cell addSubview: textField ];            
        }

        nameCell.textField.tag = 1000 + indexPath.row;            

        if (indexPath.row == 0) {
            cell.textLabel.text = @"Name";
            nameCell.textField.placeholder = @"Enter name";
            nameCell.textField.text = name;
        }
        else if (indexPath.row == 1) {
            nameCell.textField.placeholder = @"Enter hostname";
            cell.textLabel.text = @"Host";
            nameCell.textField.text = host;
        }        
        else if (indexPath.row == 2) {
            nameCell.textField.placeholder = @"Enter delay";
            cell.textLabel.text = @"Delay(ms)";
            nameCell.textField.text = [NSString stringWithFormat:@"%lu", delay];
        }
        
        return cell;
    }

    cell = [tableView dequeueReusableCellWithIdentifier:kPortCellID];    
    PortCell *portCell = (PortCell *)cell;
    if (cell == nil)
    {
        portCell = [[PortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPortCellID];
        cell = portCell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.opaque = NO;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.numberOfLines = 1;
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        // cell.textLabel.font = [UIFont systemFontOfSize:12];

        UISegmentedControl *protoControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"TCP", @"UDP",  nil]];
        protoControl.frame =  CGRectMake(170, 5, 95, 30);
        protoControl.selectedSegmentIndex = 0;
        // [actionControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        protoControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [protoControl addTarget:self
                         action:@selector(protoChanged:)
               forControlEvents:UIControlEventValueChanged];
        [cell addSubview:protoControl];
        portCell.protoSegment = protoControl;
        
        UITextField *textField = [ [ UITextField alloc ] initWithFrame: CGRectMake(50, 10, 115, 25) ];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont systemFontOfSize:17.0];
        textField.placeholder = @"Port number";
        textField.autocorrectionType = UITextAutocorrectionTypeNo;        // no auto correction support
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        textField.textAlignment = NSTextAlignmentLeft;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation; // use the default type input method (entire keyboard)
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        
        textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        textField.text = @"";
        [ textField setEnabled: YES ];
        [cell addSubview: textField ];
        portCell.portField = textField;

    }
    
    if (indexPath.row == [ports count]) {
        cell.textLabel.text = @"Add new Port";
        portCell.portField.text = @"";
        portCell.portField.placeholder = @"";
        portCell.protoSegment.hidden = YES;
        portCell.protoSegment.enabled = NO;
        portCell.portField.hidden = YES;
        portCell.portField.enabled = NO;
    }
    else {
        cell.textLabel.text = @"";
        portCell.portField.tag = indexPath.row;
        portCell.protoSegment.tag = indexPath.row;
        
        Port *portObj = [ports objectAtIndex:indexPath.row];
        if ([[portObj port] intValue] != 0)
            portCell.portField.text = [[portObj port] stringValue];
        else
            portCell.portField.text = @"";

        
        if ([[[ports objectAtIndex:indexPath.row] proto] isEqualToString:@"TCP"])
             portCell.protoSegment.selectedSegmentIndex = 0;
        else
             portCell.protoSegment.selectedSegmentIndex = 1;
        
        portCell.portField.placeholder = @"Port number";
        portCell.protoSegment.hidden = NO;
        portCell.protoSegment.enabled = YES;
        portCell.portField.hidden = NO;
        portCell.portField.enabled = YES; 
    }
        
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return NO;
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return NO;
    
    if (indexPath.row == [ports count])
        return NO;
    
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.section == 0)
        return sourceIndexPath;
    
    if (proposedDestinationIndexPath.row == [ports count])
        return sourceIndexPath;
    
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id obj = [ports objectAtIndex:sourceIndexPath.row];
    [ports insertObject:obj atIndex:destinationIndexPath.row];
    if (destinationIndexPath.row < sourceIndexPath.row)
        [ports removeObjectAtIndex:sourceIndexPath.row+1];
    else
        [ports removeObjectAtIndex:sourceIndexPath.row];

}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}


// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) 
        return UITableViewCellEditingStyleNone;
    
    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    // existing content. Existing content can be deleted.        
    if (indexPath.row == [ports count])
        return UITableViewCellEditingStyleInsert;
    else
    {
        return UITableViewCellEditingStyleDelete;
        
    }
}

#pragma mark <UITextFieldDelegate> Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing %@", textField);
    activeTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing %@", textField);
    if (textField == activeTextField)
        activeTextField = nil;
    
    if (textField.tag < 1000) {
        Port *p = [ports objectAtIndex:[textField tag]];
        NSNumber *n = [[NSNumber alloc] initWithInt:[[textField text] intValue]];
        [p setPort:n];
        [seqTableView reloadData];
    }
    else {
        if (textField.tag == 1000)
            name = textField.text;
        else if (textField.tag == 1001)
            host = textField.text;
        else {
            delay = [textField.text intValue];
            if (delay < 1)
                delay = 1;
            [seqTableView reloadData];
        }
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}


- (void) keyboardWillShow: (id)sender
{
    NSLog(@"Active tag %@/%ld", activeTextField, activeTextField.tag);
    if (activeTextField.tag < 1000) {
        seqTableView.frame = CGRectMake(seqTableView.frame.origin.x, 
                                        seqTableView.frame.origin.y, 
                                        seqTableView.frame.size.width, 
                                        seqTableView.frame.size.height-215); //resize
        
        UIScrollView* v = (UIScrollView*) seqTableView ;
        CGRect rc = [activeTextField bounds];
        rc = [activeTextField convertRect:rc toView:v];
        rc.origin.x = 0 ;
        rc.origin.y -= 60 ;
        
        rc.size.height = 400;

        [seqTableView scrollRectToVisible:rc animated:YES];  
    }
}

- (void) keyboardWillHide: (id)sender
{
    NSLog(@"Keyboard will hide");
    if (activeTextField.tag < 1000) {
        seqTableView.frame = CGRectMake(seqTableView.frame.origin.x, 
                                    seqTableView.frame.origin.y, 
                                    seqTableView.frame.size.width, 
                                    seqTableView.frame.size.height+215); //resize
    }
}

// Update the data model according to edit actions delete or insert.

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ((activeTextField) && (activeTextField.tag == indexPath.row)) {
            NSLog(@"commitEditingStyle %@", activeTextField);
            [activeTextField resignFirstResponder];
            activeTextField = nil;
        }
        [ports removeObjectAtIndex:indexPath.row];
        [seqTableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"Ports: %@", ports);
        Port *port = [[Port alloc] initWithPortNumber:0 proto:@"TCP"];
        [ports insertObject:port atIndex:[ports count]];
        NSLog(@"Added");
        [seqTableView reloadData];
    }
}

- (void) protoChanged: (id)sender
{
    UISegmentedControl *control = sender;

    Port *p = [ports objectAtIndex:control.tag];
    if (control.selectedSegmentIndex == 0)
        [p setProto:@"TCP"];
    else
        [p setProto:@"UDP"];
    NSLog(@"protoChanged: %ld/%ld", (long)control.tag, control.selectedSegmentIndex);
}


- (IBAction) save: (id)sender
{
    [self.view endEditing:YES];
    
    if ([name isEqualToString:@""]) {
        [self alert:@"Empty sequence name"];
        return;
    }
    
    for (Port *p in ports) {
        NSUInteger port = [[p port] intValue];
        if ((port < 1) || (port > 65535)) {
            NSString *s = [NSString stringWithFormat:@"Invalid port value %@, port should be a number from 1 to 65535 inclusive", [p port]];
            [self alert:s];
            return;
        }
    }
    
    [delegate sequenceViewControllerDidFinish:self accepted:YES];
}

- (IBAction) cancel: (id)sender
{
    [delegate sequenceViewControllerDidFinish:self accepted:NO];
}

- (void) alert: (NSString*)msg
{
    // check all conditions...
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];   
}

- (BOOL)prefersStatusBarHidden
{
        return YES;
}

@end
