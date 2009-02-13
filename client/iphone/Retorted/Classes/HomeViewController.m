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
#import "TRTagButton.h"

// Model class inclusion
#import "TRRetort.h"
#import "TRTag.h"

	
#define kRetortPageSize 25				// The size of a full page of retorts
#define kFilteringFactor 0.1			// Constant for the high-pass filter.
#define kRequiredMaxAcceleration 1.25	// Constant for minimum acceleration required to qualify.
#define kRequiredShakeCount 3			// Constant for # of shakes required to qualify.

@interface HomeViewController()
- (void)setFooterView;
- (NSString *)singleTagUrl;
@property(nonatomic, retain) NSIndexPath *startPoint;
@end


@implementation HomeViewController
@synthesize retorts, facade, slider;
@synthesize retortsView, activityIndicator;
@synthesize loadFailureMessage, tagSlider, footerView;
@synthesize isSingleTag, selectedTag, tagId, currentPage;
@synthesize startPoint;

- (id)initWithCoder:(NSCoder *)coder { 
	JLog(@"Initializing");
	if (self = [super initWithCoder:coder]) {
		self.isSingleTag = NO;
		self.selectedTag = nil;
		self.tagId = nil;
		self.currentPage = 1;
	}
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	self.retortsView.hidden = YES;
	self.loadFailureMessage.hidden = YES;
	
	UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																					target:self 
																					action:@selector(refreshData)] autorelease];
	
	UIBarButtonItem *homeButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home.png"] 
																	style:UIBarButtonItemStylePlain 
																   target:self 
																   action:@selector(homeButtonClicked)] autorelease];
	

	self.navigationItem.rightBarButtonItem = refreshButton;
	self.navigationItem.leftBarButtonItem = homeButton;
	
	//set up accelerometer...
	UIAccelerometer *myAccel = [UIAccelerometer sharedAccelerometer];
	myAccel.updateInterval = .1;
	myAccel.delegate = self;
	
	//set up footer...
	self.retortsView.tableFooterView = self.footerView;

	//set self to receive callback notification...
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	
	//begin data loading process...
	[self loadDataWithUrl:@"retorts/screenzero.xml"];
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
	
	self.facade = nil;
	self.slider = nil;
	self.selectedTag = nil;
	self.tagId = nil;
	self.retorts = nil;
	self.footerView = nil;
	self.startPoint = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Methods
//deteremine whether or not to display the "get more retorts" button...
- (void)setFooterView {
	if (self.isSingleTag && [self.retorts count] == kRetortPageSize) {
		self.footerView.hidden = NO;
	} else {
		self.footerView.hidden = YES;
	}
}

//starts process of fetching retort content using the TRRetortFacade helper class.
- (void)loadDataWithUrl:(NSString *)relPath {
	JLog(@"Create instance of TRRetortFacade");
	self.facade = [[TRRetortFacade alloc] init];
	
	[self.activityIndicator startAnimating];
	[self.facade loadRetortsWithRelativePath:relPath];
	//[facade release];
	
}

//Called when all Retorts have been loaded.
- (void)handleDataLoad:(NSNotification *)note {
	JLog(@" handleDataLoad received.");
	TRRetortFacade *aFacade = [note object];
	[self.activityIndicator stopAnimating];
	
	if ((aFacade.loadSuccessful) && ([aFacade.retorts count] > 0)) {
		self.retorts = aFacade.retorts;
		JLog(@"Received retorts");
		[self.retortsView reloadData];	//starts UITableView reload process
		[self displayRetortsView];
	} else {
		JLog(@"Display connection failure.");
		self.retortsView.hidden = YES;
		self.loadFailureMessage.hidden = NO;
		self.loadFailureMessage.font = [UIFont systemFontOfSize:17.0];
		self.loadFailureMessage.text = NSLocalizedString(@"Unable to acquire data at this time.  Please shake to try again.", @"Message on Home list view to let the user know that data could not be received and they need to refresh.");
	}

	[self setFooterView];
	
	//facade is no longer needed...
	self.facade = nil;
	
	//remove self as observer of notifications...
	[self removeFromAllNotifications];
}

//determines the appropriate view to display
- (void)displayRetortsView {
	self.retortsView.hidden = NO;
	self.loadFailureMessage.hidden = YES;
	
	if (self.isSingleTag) {
		[self displayRetortsForSingleTag];		
	} else {
		[self buildTagSliderView];
		[self displayRetortsForScreenZero];
	}
	
	[self.retortsView scrollToRowAtIndexPath:self.startPoint atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)displayRetortsForSingleTag {
	[UIView beginAnimations:@"singleTag" context:nil];
	
	self.title = self.selectedTag;
	self.tagSlider.hidden = YES;
	
	CGRect newFrame = [self.retortsView superview].frame;
	self.retortsView.frame = newFrame;
	
	[UIView commitAnimations]; 
}

- (void)displayRetortsForScreenZero {
	[UIView beginAnimations:@"multiTags" context:nil];
	
	self.title = NSLocalizedString(@"Home", @"Used to label the nav bar on the home screen");//@"Home";
	self.tagSlider.hidden = NO;
	
	CGRect newFrame = self.retortsView.frame;
	CGFloat sliderHeight = self.tagSlider.frame.size.height;
	CGFloat superHeight = [self.retortsView superview].frame.size.height;
	newFrame.size.height = superHeight - sliderHeight;
	
	self.retortsView.frame = newFrame;
	
	[UIView commitAnimations]; 
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
	
	if (self.slider == nil) {
		self.slider = [[TRTagSliderHelper alloc] initWithTagArray:tags];
		//self.slider.font = [UIFont systemFontOfSize:21.0];
		self.slider.fontColor = [UIColor whiteColor];
		//self.slider.backgroundColor = [UIColor blackColor];
		self.slider.displayBackgroundImage = YES;
		[self.slider controlTypeAsButtonWithTarget:self selector:@selector(handleTagSliderButtonClick:)];
	} else {
		self.slider.tagArray = tags;
	}
	
	[tags release];
	[self.slider buildTagScroller:self.tagSlider];
}

- (NSString *)singleTagUrl {
	return [NSString stringWithFormat:@"tags/%d/retorts.xml?page=%d", [self.tagId intValue], currentPage];
}

#pragma mark -
#pragma mark User Click Actions
- (void)handleTagSliderButtonClick:(id)sender {
	TRTagButton *btn = (TRTagButton *)sender;
	self.isSingleTag = YES;
	self.selectedTag = btn.currentTitle;
	self.tagId = btn.tagId;
	
	//set self to receive callback notification...
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	

	[self loadDataWithUrl:[self singleTagUrl]];
}

- (void)refreshData {
	
	//set self to receive callback notification...
	[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
	
	
	
	if (self.isSingleTag) {
		[self loadDataWithUrl:[self singleTagUrl]];
	} else {
		[self loadDataWithUrl:@"retorts/screenzero.xml"];
	}
}

//only refresh the data if the user was previously viewing the single tag view.
- (void)homeButtonClicked {
	if (self.isSingleTag) {
		self.isSingleTag = NO;
		self.selectedTag = nil;
		self.tagId = nil;
		
		//set self to receive callback notification...
		[self addToNotificationWithSelector:@selector(handleDataLoad:) notificationName:TRRetortDataFinishedLoadingNotification];
		
		[self loadDataWithUrl:@"retorts/screenzero.xml"];
	}
}

- (IBAction)nextPage:(id)sender {
	//increment page number and reload list...
	self.currentPage++;
	JLog(@"More retorts button pressed");
	[self refreshData];
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
#pragma mark User Shake-Shake motion
- (BOOL)didShake:(UIAcceleration *)acceleration {
	accelX = ((acceleration.x * kFilteringFactor) + (accelX * (1 - kFilteringFactor))); 
	float moveX = acceleration.x - accelX; 
	accelY = ((acceleration.x * kFilteringFactor) + (accelY * (1 - kFilteringFactor))); 
	float moveY = acceleration.x - accelY; 
	if (lasttime && acceleration.timestamp > lasttime + .25) { 
		BOOL result;
		if (shakecount >= kRequiredShakeCount && biggestshake >= kRequiredMaxAcceleration) {
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
		JLog(@"Shake detected");
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
	cell.retortValue.text = aRetort.content;

	if (indexPath.row == 0) {
		self.startPoint = indexPath;
	}
	
    return cell;
}

#pragma mark TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 94; //kTableCellViewRowHeight;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	RetortViewController *retortVC = [[RetortViewController alloc] initWithNibName:@"RetortView" bundle:nil];
	retortVC.retortTitle = NSLocalizedString(@"Retorts", @"Title for the nav bar on the retorts view screen");
	retortVC.retort = [self.retorts objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:retortVC animated:YES];
	[retortVC release];
}

@end
