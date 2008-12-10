//
//  RetortViewController.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "RetortViewController.h"
#import "TRRetort.h"

@implementation RetortViewController
@synthesize retort, retortTitle;


- (IBAction)ratingChanged:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSInteger segment = segmentedControl.selectedSegmentIndex;
	
	if (segment == 0) {
		NSLog(@"Your vote is Awesome!");
	} else {
		NSLog(@"Your vote is Sucks!");
	}
}

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	retortText.text = retortTitle;
    //[super viewDidLoad];
	
	self.title = @"Retort";
	[tagCloud loadHTMLString:@"<html><body style=\"background-color: #000; color: #fff\"><h1>Shant is my hero!</h1><p>Call him at 832.878.5685</p></body></html>" baseURL:nil];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[retort release];
	[retortTitle release];
    [super dealloc];
}


@end
