//
//  RetortViewController.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#define kStdWidth			204.0		//width for our content within the scroll view
#define kStdOriginX			10.0		//how far to inset our text within the scroll view
#define kStdOriginY			0.0			//how far to inset our text within the scroll view
#define kAttrHeight			14.0		//the height of our attribution labels
#define kAttrFontSize		12.0
#define kStdFontSize		16.0		//the font size for our retort content
#define kAttrSpacing		4.0			//spacing between attribution items
#define kRetortBottomSpace	6.0

#import "RetortViewController.h"
#import "TRRetort.h"
#import "CGPointUtils.h"		//calculates distance between points for pinches
#import "TRViewHelper.h"		//use to determine size of label

@implementation RetortViewController
@synthesize retort, retortTitle;
@synthesize initialDistance;
@synthesize retortActionButton;


/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
	[super loadView];
	
	self.retortActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																			target:self 
																			action:@selector(retortActionClick)];
	
	//prepare retort content view
	int nextY = 0;	//holds the current height...

	//calculate size of content...
	float heightOfContent = [TRViewHelper calculateHeightOfText:self.retort.content 
													   withFont:[UIFont systemFontOfSize:kStdFontSize] 
														  width:kStdWidth 
												  lineBreakMode:UILineBreakModeWordWrap];
	
	int rowsOfContent = ceil(heightOfContent / kStdFontSize);
	nextY = heightOfContent + kRetortBottomSpace;	//sets the next origin y-point at kRetortBottomSpace pixels below the main content (retort).
	NSLog(@"heightOfContent: %f, rows: %d", heightOfContent, rowsOfContent);
	
	//create a new content rect size based on size of retort...
	CGRect retortContentFrame = CGRectMake(kStdOriginX, kStdOriginY, kStdWidth, heightOfContent);
	
	UILabel *retortLabel = [[UILabel alloc] initWithFrame:retortContentFrame];
	//set up main content...
	retortLabel.numberOfLines = rowsOfContent;
	retortLabel.text = self.retort.content;
	[retortContainer addSubview:retortLabel];
	[retortLabel release];
	//Do I need to adjust the size of the retort Rect?
	
	//set up attribution objects...
	CGRect attrFrame;
	for(NSString *attr in [self.retort attributionListAsStringArray]) {
		//reuse heightOfContent
		
		heightOfContent = [TRViewHelper calculateHeightOfText:attr 
													 withFont:[UIFont systemFontOfSize:kAttrFontSize] 
														width:kStdWidth 
												lineBreakMode:UILineBreakModeWordWrap];
		
		//attrFrame = CGRectMake(kStdOriginX, nextY, kStdWidth, kAttrHeight);
		attrFrame = CGRectMake(kStdOriginX, nextY, kStdWidth, heightOfContent);
		UILabel *attrLabel = [[UILabel alloc] initWithFrame:attrFrame];
		
		attrLabel.numberOfLines = ceil(heightOfContent/kAttrFontSize);
		attrLabel.text = attr;
		attrLabel.textAlignment = UITextAlignmentRight;
		attrLabel.textColor = [UIColor blueColor];
		attrLabel.font = [UIFont boldSystemFontOfSize:kAttrFontSize];
		[retortContainer addSubview:attrLabel];	//add as subview to scrollview
		[attrLabel release];
		
		nextY = nextY + heightOfContent + kAttrSpacing;
	}
	
	NSLog(@"nextY: %d", nextY);
	//determine overflow size of scroll view...
	CGSize scrollSize = CGSizeMake(kStdWidth, nextY);
	
	//set up scroll view...
	//[retortContainer setBackgroundColor:[UIColor blackColor]];
	//retortContainer.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	[retortContainer setContentSize:scrollSize];
	
}



// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	//retortText.text = self.retort.content;
    //[super viewDidLoad];
	
	self.title = @"Retort";
	//[[self.view subviews] count]
	//tagCloud.backgroundColor = [UIColor blackColor];
	[tagCloud loadHTMLString:@"<html><body style=\"background-color: #000; color: #fff\"><h1><a href=\"tag:shant\">Shant</a> is my hero!</h1><p>Call him at 832.878.5685</p></body></html>" baseURL:nil];

	self.navigationItem.rightBarButtonItem = self.retortActionButton;
	
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

#pragma mark -
#pragma mark WebView Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSURL *url = [request URL];
	NSLog(@"Absolute URL: %@", [url absoluteString]);
	return NO;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	
	if (buttonIndex == 0)
	{
		NSLog(@"favorites");
	}
	else if (buttonIndex == 1)
	{
		NSLog(@"facebook");
	} else  {
		NSLog(@"cancel");
	}
}


#pragma mark -
#pragma mark User Action methods
- (IBAction)ratingChanged:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSInteger segment = segmentedControl.selectedSegmentIndex;
	
	if (segment == 0) {
		NSLog(@"Your vote is Awesome!");
	} else {
		NSLog(@"Your vote is Sucks!");
	}
}

- (IBAction)retortActionClick {
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self 
													cancelButtonTitle:@"Cancel" 
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Add to Favorites", @"Add To Facebook Wall", nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	//actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
	[actionSheet showInView:self.view];
	[actionSheet release];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches count] == 2) {
		NSArray *twoTouches = [touches allObjects];
		UITouch *firstTouch = [twoTouches objectAtIndex:0];
		UITouch *secondTouch = [twoTouches objectAtIndex:1];
		initialDistance = distanceBetweenPoints([firstTouch locationInView:self.view], [secondTouch locationInView:self.view]);
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches count] == 2) {
		NSArray *twoTouches = [touches allObjects];
		UITouch *firstTouch = [twoTouches objectAtIndex:0];
		UITouch *secondTouch = [twoTouches objectAtIndex:1];
		CGFloat currentDistance = distanceBetweenPoints([firstTouch locationInView:self.view], [secondTouch locationInView:self.view]);
		
		if (initialDistance == 0) {
			initialDistance = currentDistance;
		} else if (currentDistance - initialDistance > kMinimumPinchDelta) {
			//grow
			NSLog(@"grow tag cloud");
		} else if (initialDistance - currentDistance > kMinimumPinchDelta) {
			//shrink
			NSLog(@"shrink tag cloud");
		}
	} else {
		UITouch *singleTouch = [[touches allObjects] objectAtIndex:0];
		CGPoint point = [singleTouch locationInView:self.view];
		NSLog(@"x=%f, d=%f", point.x, point.y);
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	initialDistance = 0;
}
*/

@end
