//
//  KnockOnDViewController.m
//  KnockOnD
//
//  Created by Oleksandr Tymoshenko on 09-09-10.
//  Copyright BluezBox 2009. All rights reserved.
//

#import "KnockOnDViewController.h"
#import "SequenceManager.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <fcntl.h>

// knock on port 
BOOL knockOnePort (struct hostent* he, unsigned short port, BOOL udp)
{

    struct sockaddr_in addr;
    int s;
    unsigned int flags;

    
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = *((long*)he->h_addr_list[0]);
    addr.sin_port = htons(port);
    
    if (udp) {
        s = socket(PF_INET, SOCK_DGRAM, 0);
        sendto(s, "", 1, 0, (struct sockaddr*)&addr, sizeof(addr));
    } 
    else {
        s = socket(PF_INET, SOCK_STREAM, 0);
        
        if (-1 == (flags = fcntl(s, F_GETFL, 0)))
            flags = 0;
        fcntl(s, F_SETFL, flags | O_NONBLOCK);        
        connect(s, (struct sockaddr*)&addr, sizeof(struct sockaddr));
    }
    
    close(s);
    
    return YES;
}


@implementation KnockOnDViewController

@synthesize internetConnectionStatus;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
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
    
    pickerViewArray = [NSArray array];
    currentSeq = 0;
    self.internetConnectionStatus = NotReachable;
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    Reachability  *curReach = [Reachability reachabilityForInternetConnection];
    self.internetConnectionStatus = curReach.currentReachabilityStatus;
    [curReach startNotifer];

    if ([[SequenceManager sharedSequenceManager] count])
        knockButton.enabled = YES;
    
    
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Knocking..." message:@" " delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
    progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [progressAlert addSubview:progressView];
    [progressView startAnimating];
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



#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // only one component
    currentSeq = row;
    return;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger sequences = [[SequenceManager sharedSequenceManager] count];
    if (sequences == 0)
        return @"";
    
    Sequence *s = [[SequenceManager sharedSequenceManager] sequenceAtIndex:row];
    if (s == nil)
        return @"";
    
    NSString *name = [NSString stringWithString:s.name];
    return name;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 0.0;
    
    // if (component == 0)
    //    componentWidth = 240.0;    // first column size is wider to hold names
    //else
    //    componentWidth = 40.0;    // second column is narrower to show numbers
    
    if (component == 0)
        componentWidth = 280;
    else
        componentWidth = 0;
    
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger sequences = [[SequenceManager sharedSequenceManager] count];
    NSLog(@"%d sequences", sequences);
    if (sequences == 0)
        return 1;
    else
        return sequences;    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];

    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NSLog(@"Reachability has changed -> %d", curReach.currentReachabilityStatus);
    self.internetConnectionStatus = curReach.currentReachabilityStatus;

}

- (IBAction)knock
{
    
    currentSeq = [pickerView selectedRowInComponent:0];

    if (self.internetConnectionStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" message:@"Sorry, network is not available. Please try again later." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
        return;
    }
    
    Sequence *s = [[SequenceManager sharedSequenceManager] sequenceAtIndex:currentSeq];
    if (s == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal inconsistency, please report this message to the author" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
        return;                
    }
        
    if (s.ports.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No ports defined for this sequence" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
        return;        
    }

    [progressAlert show];
    [NSThread detachNewThreadSelector:@selector(doKnock) 
                             toTarget:self 
                           withObject:nil];
    
}

- (void)hideAlert
{
    // [progressView stopAnimating];
    NSLog(@"Hide alert");
    [progressAlert dismissWithClickedButtonIndex:0 animated:YES];    

}

- (void)hostNotFound
{
    [self hideAlert];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Host not found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)doKnock
{
    @autoreleasepool {
    
        NSLog(@"Knocking...");
        
        // we should not have received this message at all
        if ([[SequenceManager sharedSequenceManager] count] == 0) {
            [self performSelectorOnMainThread:@selector(hideAlert) withObject:self waitUntilDone:YES];
            return;        
        }
        
        Sequence *s = [[SequenceManager sharedSequenceManager] sequenceAtIndex:currentSeq];

        if (s) {
            
            NSInteger delay = [s.delay intValue];
            struct hostent *he = gethostbyname([s.host UTF8String]);
            
            if (he == NULL)
            {
                [self performSelectorOnMainThread:@selector(hostNotFound) withObject:self waitUntilDone:YES];
                return;
            }
            
            for (Port *p in s.ports) {
                NSLog(@"*knock* -> %@/%@", p.port, p.proto);
                unsigned short port = [p.port intValue];
                BOOL isUDP = [p.proto isEqualToString:@"UDP"];
                knockOnePort(he, port, isUDP);
                NSLog(@"Sleeping for %dms", delay);
                usleep(delay*1000);
            }
        }

    }
    [self performSelectorOnMainThread:@selector(hideAlert) withObject:self waitUntilDone:YES];
}


- (IBAction)settings
{
    SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)settingsViewControllerDidFinish:(id)sender
{
    NSLog(@"Reloading...");
    [pickerView reloadAllComponents];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([[SequenceManager sharedSequenceManager] count])
        knockButton.enabled = YES;
    else
        knockButton.enabled = NO;
}


@end
