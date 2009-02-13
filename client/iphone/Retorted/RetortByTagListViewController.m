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

// The size of a full page of retorts
#define kRetortPageSize 25

@interface RetortByTagListViewController()
- (void)loadURL;
- (void)handleDataLoad:(NSNotification *)note;
- (void)setFooterView;
- (void)refreshData;
@end

@implementation RetortByTagListViewController
@synthesize retorts, facade, selectedTag, tagId;
@synthesize retortsView, footerView;
@synthesize loadFailureMessage, currentPage;




// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.currentPage = 1;
	}
	return self;
 }
 

- (void)viewDidLoad {
	self.retortsView.hidden = YES;
	self.loadFailureMessage.hidden = YES;
	[activityIndicator startAnimating];
	self.title = self.selectedTag;
	
	self.retortsView.tableFooterView = self.footerView;
	[self refreshData];

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
	NSUInteger rowCount = [self.retorts count];
	if (rowCount == kRetortPageSize) {
		// Add an extra row for the "Get More" button.
		//rowCount =+ 1;
	} 
    return rowCount;
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
	self.footerView = nil;
    [super dealloc];
}



#pragma mark -
#pragma mark User Events
- (IBAction)nextPage:(id)sender {
	//increment page number and reload list...
	self.currentPage++;
	JLog(@"More retorts button pressed");
	[self refreshData];
}

#pragma mark -
#pragma mark Custom Methods
- (void)refreshData {
	
	//set self to receive callback notification...
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	[self loadURL];
}

- (void)setFooterView {
	if ([self.retorts count] >= kRetortPageSize) {
		self.footerView.hidden = NO;
	} else {
		self.footerView.hidden = YES;
	}
}

- (void)loadURL {
	if (!self.facade) {
		self.facade = [[TRRetortFacade alloc] init];
	}
	
	[self.facade loadRetortsWithRelativePath:[NSString stringWithFormat:@"tags/%d/retorts.xml?page=%d", [self.tagId intValue], self.currentPage]];
}

- (void)handleDataLoad:(NSNotification *)note {
	JLog(@"HandleDataLoad called!");
	TRRetortFacade *aFacade = [note object];
	[activityIndicator stopAnimating];
	
	if ((aFacade.loadSuccessful) && ([aFacade.retorts count])) {
		self.retortsView.hidden = NO;
		self.loadFailureMessage.hidden = YES;
		//TODO: Will likely need to optimize sense this will allow the array to continue to grow...
		if ([self.retorts count] > 0) {
			[self.retorts addObjectsFromArray:aFacade.retorts];
		} else {
			self.retorts = aFacade.retorts;
		}
		
		[self.retortsView reloadData];
	} else {
		self.retortsView.hidden = YES;
		self.loadFailureMessage.hidden = NO;
		self.loadFailureMessage.font = [UIFont systemFontOfSize:17.0];
		self.loadFailureMessage.text = NSLocalizedString(@"Unable to acquire data at this time.  Please shake to try again.", @"Message on Retort By Tag list view to let the user know that data could not be received and they need to refresh.");
	}
	
	[self setFooterView];
	self.facade = nil;
	[self removeFromAllNotifications];
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

