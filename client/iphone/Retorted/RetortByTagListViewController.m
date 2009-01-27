//
//  RetortByTagListViewController.m
//  Retorted
//
//  Created by B.J. Ray on 1/7/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "RetortByTagListViewController.h"
#import "RetortViewController.h"
#import "TRRetortFacade.h"
#import "RetortCellView.h"		//our custom cell view class

// Model class inclusion
#import "TRRetort.h"
#import "TRTag.h"
#import "TRRating.h"

// //Constant for maximum acceleration.
//#define kMaxAcceleration 3.0
// //Constant for the high-pass filter.
//#define kFilteringFactor 0.1

@implementation RetortByTagListViewController
@synthesize retorts, facade, selectedTag, tagId;
@synthesize retortsView;
@synthesize loadFailureMessage;

- (void)viewDidLoad {
	self.retortsView.hidden = YES;
	self.loadFailureMessage.hidden = YES;
	[activityIndicator startAnimating];
	self.title = self.selectedTag;

//	//set up accelerometer...
//	UIAccelerometer *myAccel = [UIAccelerometer sharedAccelerometer];
//	myAccel.updateInterval = .1;
//	myAccel.delegate = self;
	
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	[self loadURL];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.retorts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"CustomTagCellIdentifier";
    //static NSString *CellIdentifier = @"Cell";
    
	RetortCellView *cell = (RetortCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RetortCellView" owner:self options:nil];
		for (NSUInteger i=0; i< [nib count]; i++) {
			id obj = [nib objectAtIndex:i];
			//if ([obj isMemberOfClass:[RetortCellView class]]) {
			if ([obj isMemberOfClass:[RetortCellView class]]) {
				cell = obj;
			}
		}
		
    }
	
	//TODO: Why doesn't this debug section get called when compliling for debugging?
#if DEBUG
	if (cell == nil) {
		UITableViewCell *badCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		badCell.text = @"You are not using the correct NIB bundle for the cell";
		return badCell;
	}
#endif
	
    
    // Set up the cell...
	TRRetort *aRetort = [self.retorts objectAtIndex:indexPath.row];
	//TRRating *retortRating = aRetort.rating;
	
	cell.retortValue.text = aRetort.content;
    return cell;
}

#pragma mark TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 94; //kTableCellViewRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    RetortViewController *retortVC = [[RetortViewController alloc] initWithNibName:@"RetortView" bundle:nil];
	retortVC.retortTitle = NSLocalizedString(@"Retort", @"Used to label the nav bar on the retort by tag list view screen");
	retortVC.retort = [self.retorts objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:retortVC animated:YES];
	[retortVC release];
}


- (void)dealloc {
	self.retorts = nil;
	self.selectedTag = nil;
	self.tagId = nil;
	self.facade = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Methods
- (void)loadURL {
	self.facade = [[TRRetortFacade alloc] init];
	
	[self.facade loadRetortsWithRelativePath:[NSString stringWithFormat:@"tags/%d.xml", [self.tagId intValue]]];
}

- (void)handleDataLoad:(NSNotification *)note {
	JLog(@"HandleDataLoad called!");
	TRRetortFacade *aFacade = [note object];
	[activityIndicator stopAnimating];
	
	if ((aFacade.loadSuccessful) && ([aFacade.retorts count])) {
		self.retortsView.hidden = NO;
		self.loadFailureMessage.hidden = YES;
		self.retorts = aFacade.retorts;
		[self.retortsView reloadData];
	} else {
		self.retortsView.hidden = YES;
		self.loadFailureMessage.hidden = NO;
		self.loadFailureMessage.font = [UIFont systemFontOfSize:17.0];
		self.loadFailureMessage.text = NSLocalizedString(@"Unable to acquire data at this time.  Please shake to try again.", @"Message on Retort By Tag list view to let the user know that data could not be received and they need to refresh.");
	}
		self.facade = nil;
		[self removeFromAllNotifications];
}

- (void)refreshData {
	
}

- (void)addToNotificationWithSelector:(SEL)selector notificationName:(NSString *)notificationName{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:self 
		   selector:selector
			   name:notificationName
			 object:nil];
}

- (void)removeFromAllNotifications {
	//remove self from notification center...
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	JLog(@"Unregistered with notification center.");
}

@end

