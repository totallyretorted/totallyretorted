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
#import "TRTagSliderHelper.h"
#import "RetortCellView.h"		//our custom cell view class

// Model class inclusion
#import "TRRetort.h"
#import "TRTag.h"
#import "TRRating.h"


// Constant for maximum acceleration.
#define kMaxAcceleration 3.0
// Constant for the high-pass filter.
#define kFilteringFactor 0.1


@implementation HomeViewController
@synthesize retorts, facade;
@synthesize retortsView;
@synthesize loadFailureMessage, tagSlider;

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
	self.retortsView.hidden = NO;
	self.loadFailureMessage.hidden = YES;
	
	UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh 
																					target:self 
																					action:@selector(refreshData)] autorelease];
	
	
	self.navigationItem.rightBarButtonItem = refreshButton;
	
	//set up accelerometer...
	UIAccelerometer *myAccel = [UIAccelerometer sharedAccelerometer];
	myAccel.updateInterval = .1;
	myAccel.delegate = self;
	
	
	//register with notification center to receive callback
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	NSLog(@"Controller: Registered with notification center");
	[self loadURL];
	
	//[super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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

- (void)refreshData {
	//now go fetch the data!
	[self.retorts release];
	
	//register with notification center to receive callback
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	NSLog(@"refetching data");
	[self loadURL];
}

//starts process of fetching retort content using the TRRetortFacade helper class.
- (void)loadURL {
	NSLog(@"HomeViewController: Create instance of TRRetortFacade");
	self.facade = [[TRRetortFacade alloc] init];
	
	[self.facade loadRetorts];
	//[facade release];
	
}

//Called when all Retorts have been loaded.
- (void)handleDataLoad:(NSNotification *)note {
	NSLog(@"HomeViewController: handleDataLoad received.");
	TRRetortFacade *aFacade = [note object];
	
	if ((aFacade.loadSuccessful) && ([aFacade.retorts count] > 0)) {
		self.retortsView.hidden = NO;
		self.loadFailureMessage.hidden = YES;
		
		self.retorts = aFacade.retorts;
		NSLog(@"received retorts");
		[self.retortsView reloadData];
		[self buildTagSliderView];
	} else {
		NSLog(@"Display connection failure.");
		self.retortsView.hidden = YES;
		self.loadFailureMessage.hidden = NO;
		self.loadFailureMessage.font = [UIFont systemFontOfSize:17.0];
		self.loadFailureMessage.text = @"Unable to acquire data at this time.  Please shake to try again.";
	}

	//facade is no longer needed...
	self.facade = nil;
	
	//remove self as observer of notifications...
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
	NSLog(@"HomeViewController: Unregistered with notification center.");
}


//adds tags to tag slider
- (void)buildTagSliderView {
	
	NSMutableArray *tags = [[NSMutableArray alloc] init];
	for(TRRetort *aRetort in self.retorts) {
		for (TRTag *tag in aRetort.tags) {
			
			//in the future, consider a way to use localizedCaseInsensitiveCompare
			if ([tags indexOfObject:tag] == NSNotFound) {
				//found a new Tag!
				[tags addObject:tag];
			}
		}
	}
	
	TRTagSliderHelper *slider = [[TRTagSliderHelper alloc] initWithTagArray:tags];
	slider.font = [UIFont systemFontOfSize:21.0];
	slider.fontColor = [UIColor whiteColor];
	slider.backgroundColor = [UIColor blackColor];
	[tags release];
	
	[slider buildTagScroller:self.tagSlider];
}



#pragma mark -
#pragma mark Shake-Shake motion
- (BOOL)didShake:(UIAcceleration *)acceleration {
	accelX = ((acceleration.x * kFilteringFactor) + (accelX * (1 - kFilteringFactor))); 
	float moveX = acceleration.x - accelX; 
	accelY = ((acceleration.x * kFilteringFactor) + (accelY * (1 - kFilteringFactor))); 
	float moveY = acceleration.x - accelY; 
	if (lasttime && acceleration.timestamp > lasttime + .25) { 
		BOOL result;
		if (shakecount >= 3 && biggestshake >= 1.25) {
			result = YES;
		} else {
			result = NO;
		}
		lasttime = 0;
		shakecount = 0;
		biggestshake = 0;
		return result;
	} else { 
		if (fabs(moveX) >= fabs(moveY)) {
			if ((fabs(moveX) > .75) && (moveX * lastX <= 0)) {
				lasttime = acceleration.timestamp;
				shakecount++;
				lastX = moveX;
				if (fabs(moveX) > biggestshake) biggestshake = fabs(moveX);
			}
		} else { 
			if ((fabs(moveY) > .75) && (moveY * lastY <= 0)) {
				lasttime = acceleration.timestamp;
				shakecount++;
				lastY = moveY;
				if (fabs(moveY) > biggestshake) biggestshake = fabs(moveY);
			}
		}
		return NO;
	}
}

#pragma mark -
#pragma mark UIAcceleration delegate method
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	if ([self didShake:(UIAcceleration *)acceleration]) {
		
		[self refreshData];
	}
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
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	RetortCellView *cell = (RetortCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RetortCellView" owner:self options:nil];
		for (NSUInteger i=0; i< [nib count]; i++) {
			id obj = [nib objectAtIndex:i];
			if ([obj isMemberOfClass:[RetortCellView class]]) {
				cell = obj;
			}
		}
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
	
	//TRRetort *aRetort = [self.retorts objectAtIndex:indexPath.row];
	//cell.text = aRetort.content;
    return cell;
}

#pragma mark TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80; //kTableCellViewRowHeight;
}

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
