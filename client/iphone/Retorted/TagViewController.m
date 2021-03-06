//
//  TagViewController.m
//  Retorted
//
//  Created by a on 12/23/08.
//  Copyright 2008 Forward Echo LLC. All rights reserved.
//

#import "TagViewController.h"
#import "TRTagFacade.h"
#import "TRTag.h"
#import "TagCellView.h"		//our custom cell view class
#import "RetortByTagListViewController.h"

@interface TagViewController()
@property (nonatomic, retain) UILabel *sectionLabel;

- (void) loadURL;
- (void) loadURLWithSearch:(NSString *)searchText;
- (void) handleDataLoad:(NSNotification *)note;
- (void) showHoverView:(BOOL)show;
//-(void) cleanTags: (NSMutableArray *)ts;
@end


@implementation TagViewController
@synthesize tagsView, loadFailurelbl, activityIndicator, tagSearchBar, footerView, hover, sectionLabel;
@synthesize tags, tagFacade, alphaArray;


- (void)viewDidLoad {
	self.tagsView.hidden = YES;
	self.loadFailurelbl.hidden = YES;
	
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRTagDataDidFinishedNotification];

	//set up the search bar...
	self.tagsView.tableHeaderView = self.tagSearchBar;
	self.tagSearchBar.barStyle = UIBarStyleBlackOpaque;
	self.tagSearchBar.showsCancelButton = YES;
	self.tagSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.tagsView.backgroundColor = [UIColor blackColor];
	
	self.title = NSLocalizedString(@"Tags", @"Title for the nav bar on the Tag list view screen");
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
	if (!self.tags) {
		return 1;
	} else {
		return [self.tags count];
	}
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSArray *arr = [self.tags objectAtIndex:section];
	return [arr count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomTagCellIdentifier";
	//static NSString *CellIdentifier = @"Cell";

    
	TagCellView *cell = (TagCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TagCellView" owner:self options:nil];
		for (NSUInteger i=0; i< [nib count]; i++) {
			id obj = [nib objectAtIndex:i];
			if ([obj isMemberOfClass:[TagCellView class]]) {
				cell = obj;
			}
		}
		
		//cell = [nib objectAtIndex:0];		//file's owner is suppose to be at index 0.  Not sure why not?
		
    }

	if (cell == nil) {
		return nil;
	}
    // Set up the cell...
	NSArray *aTagGroup = [self.tags objectAtIndex:indexPath.section];
    TRTag *aTag = [aTagGroup objectAtIndex:indexPath.row];
	
	if (aTag != nil) {
		if (aTag.value != nil) {
			cell.tagName.text = aTag.value;
		}
		cell.tagCount.text = [NSString stringWithFormat:@"%d", aTag.weight];
	}
	
	//cell.text=aTag.value;
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65; //kTableCellViewRowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	RetortByTagListViewController *retortVC = [[RetortByTagListViewController alloc] initWithNibName:@"RetortByTagView" bundle:nil];
	NSArray *grps = [self.tags objectAtIndex:indexPath.section];
	TRTag *aTag = [grps objectAtIndex:indexPath.row];
	retortVC.selectedTag = aTag.value;
	retortVC.tagId = aTag.primaryId;
	
	[self.navigationController pushViewController:retortVC animated:YES];
	[retortVC release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.alphaArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

	return self.alphaArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return self.sectionLabel.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	
	title = [self.alphaArray objectAtIndex:section];

	UIFont *aFont = [UIFont fontWithName:@"Georgia" size:17.0];
	CGSize sectionSize = [title sizeWithFont:aFont];
	CGRect sectionRect = CGRectMake(0, 0, sectionSize.width, sectionSize.height+20.0);
	
	//set label for settings section...
	self.sectionLabel = [[UILabel alloc] initWithFrame:sectionRect];
	self.sectionLabel.textColor = [UIColor whiteColor];
	self.sectionLabel.backgroundColor = [UIColor blackColor];
	self.sectionLabel.text = title;
	self.sectionLabel.font = aFont;
	
	return self.sectionLabel;
}

#pragma mark -
#pragma mark UISearchBarDelegate delegate methods

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.tagSearchBar resignFirstResponder];
	[self loadURLWithSearch:self.tagSearchBar.text];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	JLog(@"Search cancelled.");
	[self.tagSearchBar resignFirstResponder];
}

#pragma mark -
#pragma mark TRNotificationInterface
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

#pragma mark -
#pragma mark Custom Methods
- (void)showHoverView:(BOOL)show
{
	// fade animate the view out of view by affecting its alpha
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.40];
	
	if (show)
	{
		self.hover.alpha = 1.0;
	}
	else
	{
		self.hover.alpha = 0.0;
	}
	
	[UIView commitAnimations];
}

// Initiates the process of fetching the tag data and populating the objects.
-(void)loadURL{
	self.tagFacade = [[TRTagFacade alloc] init];
	[self showHoverView:YES];
	[self.activityIndicator startAnimating];
	[self.tagFacade loadTags];
}

- (void)loadURLWithSearch:(NSString *)searchText {
	if (self.tagFacade == nil) {
		self.tagFacade = [[TRTagFacade alloc] init];
	}
	[self showHoverView:YES];
	[self.activityIndicator startAnimating];
	[self.tagFacade loadTagsMatchingString:searchText];
}

////This method removes tags with weight 0 because there is no value to the user in clicking a tag with no associated retorts.
//-(void)cleanTags: (NSMutableArray *)ts {
//	if (nil == ts)
//		return;
//	
//	//since we are removing items, iterate in reverse
//	for (NSInteger i=[ts count]-1; i>=0; i--) {
//		TRTag* tag = [ts objectAtIndex:i];
//		if (nil == tag) {
//			continue;			
//		}
//		if (0 == [tag weight]) {
//			[ts removeObjectAtIndex:i];
//		}
//	}
//}


-(void)handleDataLoad: (NSNotification *)note{
	TRTagFacade *facade = [note object];
	[self showHoverView:NO];
	[self.activityIndicator stopAnimating];
	
	if(facade.loadSucessful && [facade.tagGroups count]>0)
	{
		self.tagsView.hidden=NO;
		self.loadFailurelbl.hidden=YES;
		
		self.tags = facade.tagGroups;
		self.alphaArray = facade.alphaArray;
//		[self.alphaArray insertObject:@"Search" atIndex:0];
		[self.tagsView reloadData];
		
	}
	else
	{
		self.tagsView.hidden=YES;
		self.loadFailurelbl.hidden = NO;
		self.loadFailurelbl.font = [UIFont systemFontOfSize:17.0];
		self.loadFailurelbl.textColor = [UIColor whiteColor];
		self.loadFailurelbl.numberOfLines = 2;
		self.loadFailurelbl.textAlignment = UITextAlignmentCenter;
		self.loadFailurelbl.text = NSLocalizedString(@"Unable to acquire data at this time.  Please shake to try again.", @"Message on Home list view to let the user know that data could not be received and they need to refresh.");
	}
}

#pragma mark -
#pragma mark Clean up
-(void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	self.tags=nil;
	self.tagFacade=nil;
	self.tagSearchBar = nil;
	self.footerView = nil;
	self.hover = nil;
	self.alphaArray = nil;
	self.sectionLabel = nil;
    [super dealloc];
}


@end

