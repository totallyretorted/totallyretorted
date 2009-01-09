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

// Constant for maximum acceleration.
#define kMaxAcceleration 3.0
// Constant for the high-pass filter.
#define kFilteringFactor 0.1

@implementation RetortByTagListViewController
@synthesize retorts, facade, selectedTag, tagId;
@synthesize retortsView;
@synthesize loadFailureMessage;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
	self.retortsView.hidden = YES;
	self.loadFailureMessage.hidden = YES;
	[activityIndicator startAnimating];
	self.title = self.selectedTag;

	//set up accelerometer...
	UIAccelerometer *myAccel = [UIAccelerometer sharedAccelerometer];
	myAccel.updateInterval = .1;
	myAccel.delegate = self;
	
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	[self loadURL];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
			if ([obj isMemberOfClass:[RetortCellView class]]) {
				cell = obj;
			}
		}
		
		//NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RetortCellView" owner:self options:nil];
		//cell = [nib objectAtIndex:0];	//file's owner is suppose to be at index 0.  Not sure why not?
    }
	if (cell == nil) {
		return nil;
	}
    
    // Set up the cell...
	TRRetort *aRetort = [self.retorts objectAtIndex:indexPath.row];
	TRRating *retortRating = aRetort.rating;
	
	cell.retortValue.text = aRetort.content;
	if (retortRating.rank > 0.5) {
		cell.rankIndicator.image = [UIImage imageNamed:@"upArrow.png"];
	} else {
		cell.rankIndicator.image = [UIImage imageNamed:@"downArrow.png"];
	}
	

    return cell;
}

#pragma mark TableView Delegate Methods
/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80; //kTableCellViewRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RetortViewController *retortVC = [[RetortViewController alloc] initWithNibName:@"RetortView" bundle:nil];
	retortVC.retortTitle = @"Retort";
	retortVC.retort = [self.retorts objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:retortVC animated:YES];
	[retortVC release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
	NSLog(@"RetortByTagListViewController:handleDataLoad called!");
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
		self.loadFailureMessage.text = @"Unable to acquire data at this time.  Please shake to try again.";
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
	NSLog(@"RetortByTagListViewController: Unregistered with notification center.");
}

@end

