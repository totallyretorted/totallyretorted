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

@implementation TagViewController
@synthesize tags, tagFacade, tagsView, loadFailurelbl;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	NSNotificationCenter *nc =[NSNotificationCenter defaultCenter];
	[nc addObserver:self 
           selector:@selector(handleDataLoad:) 
			   name:TRTagDataDidFinishedNotification 
			 object:nil];
	
	self.title = @"Tags";
	[self loadURL];
	
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
    return [self.tags count];
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
    TRTag *aTag = [self.tags objectAtIndex:indexPath.row];
	
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
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	RetortByTagListViewController *retortVC = [[RetortByTagListViewController alloc] initWithNibName:@"RetortByTagView" bundle:nil];
	TRTag *aTag = [tags objectAtIndex:indexPath.row];
	retortVC.selectedTag = aTag.value;
	retortVC.tagId = aTag.primaryId;
	
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
#pragma mark -
#pragma mark Custom Methods
-(void)loadURL{
	self.tagFacade = [[TRTagFacade alloc] init];
	[self.tagFacade loadTags];
}

-(void)handleDataLoad: (NSNotification *)note{
	TRTagFacade *tagF=[note object];
	
	if(tagF.loadSucessful && [tagF.tags count]>0)
	{
		self.tagsView.hidden=NO;
		
		self.loadFailurelbl.hidden=YES;
		self.tags=tagF.tags;
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
		self.loadFailurelbl.text = @"Unable to acquire data.  Reboot the internet.";
	}
}

#pragma mark -
#pragma mark Clean up
-(void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	self.tags=nil;
	self.tagFacade=nil;
    [super dealloc];
}


@end

