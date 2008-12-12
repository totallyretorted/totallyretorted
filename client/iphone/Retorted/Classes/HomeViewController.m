//
//  HomeViewController.m
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import "HomeViewController.h"
#import "RetortViewController.h"
#import "TRRetortFacade.h"

// Model class inclusion
#import "TRRetort.h"


@implementation HomeViewController
@synthesize retorts, facade;
@synthesize retortsView;

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
	/*
	self.retorts = [[NSMutableArray alloc] initWithObjects:@"Too bad drinking Scotch isn't a paying job or Kenny's dad would be a millionaire!",
					@"Oh my God, they killed Kenny!",
					@"I've learned something today. You see, the basis of all reasoning is the mind's awareness of itself. What we think, the external objects we perceive, are all like actors that come on and off stage. But our consciousness, the stage itself, is always present to us.",
					@"Lick my chocolate salty balls",
					@"I can see Russia from my house!",
					nil];
	*/
	[tagCloud loadHTMLString:@"<html><body style=\"background-color: #000; color: #fff\"><h1>Shant is my hero!</h1><p>Call him at 832.878.5685</p></body></html>" baseURL:nil];
	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:self 
		   selector:@selector(handleDataLoad:) 
			   name:TRRetortDataFinishedLoadingNotification
			 object:nil];
	NSLog(@"Controller: Registered with notification center");
	[self loadURL];
	
	
	
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
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[retorts release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Methods
- (void)loadURL {
	NSLog(@"HomeViewController: Create instance of TRRetortFacade");
	self.facade = [[TRRetortFacade alloc] init];
	
	[self.facade loadRetorts];
	//[facade release];
	
}

- (void)handleDataLoad:(NSNotification *)note {
	NSLog(@"HomeViewController: handleDataLoad received.");
	TRRetortFacade *aFacade = [note object];
	
	self.retorts = aFacade.retorts;
	
	
	NSLog(@"received retorts");
	[self.retortsView reloadData];
	
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
	NSLog(@"indexPath.row: %d", indexPath.row);
	TRRetort *aRetort = [self.retorts objectAtIndex:indexPath.row];
	cell.text = aRetort.content;
    return cell;
}

#pragma mark TableView Delegate Methods

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	RetortViewController *retortVC = [[RetortViewController alloc] initWithNibName:@"RetortView" bundle:nil];
	retortVC.retortTitle = @"Retorts";
	retortVC.retort = [self.retorts objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:retortVC animated:YES];
	[retortVC release];
}

@end
