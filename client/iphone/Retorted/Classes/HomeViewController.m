//
//  HomeViewController.m
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import "HomeViewController.h"
#import "RetortViewController.h"

// Model class inclusion
#import "TRRetort.h"


@implementation HomeViewController
@synthesize retorts;

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
    self.title = @"Home";
	self.retorts = [[NSMutableArray alloc] initWithObjects:@"Too bad drinking Scotch isn't a paying job or Kenny's dad would be a millionaire!",
					@"Oh my God, they killed Kenny!",
					@"I've learned something today. You see, the basis of all reasoning is the mind's awareness of itself. What we think, the external objects we perceive, are all like actors that come on and off stage. But our consciousness, the stage itself, is always present to us.",
					@"Lick my chocolate salty balls",
					@"I can see Russia from my house!",
					nil];
	//[super viewDidLoad];
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
	[retorts release];
    [super dealloc];
}

#pragma mark -
#pragma mark TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.retorts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell
	
	cell.text = [retorts objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark TableView Delegate Methods

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	RetortViewController *retortVC = [[RetortViewController alloc] initWithNibName:@"RetortView" bundle:nil];
	retortVC.retortTitle = [retorts objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:retortVC animated:YES];
	[retortVC release];
}

@end
