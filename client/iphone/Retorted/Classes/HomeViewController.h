//
//  HomeViewController.h
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRNotificationInterface.h"

@class TRRetortFacade;
@class TRTagSliderHelper;
@class HoverView;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAccelerometerDelegate, TRNotificationInterface>  {
	IBOutlet UITableView *retortsView;			//list of retorts
	IBOutlet UITextView *loadFailureMessage;	//message if there is no data
	IBOutlet UIScrollView *tagSlider;			//tag slider control
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UIView *footerView;
	IBOutlet UIImageView *hover;
	
	//Handles details on getting data from internet, parsing XML, and populating model objects.
	TRRetortFacade *facade;

	TRTagSliderHelper *slider;
	
	//Used with paging
	NSInteger currentPage;
	
	// Array of TRRetort Objects...
	NSMutableArray *retorts;
	
	
	//Parent Tag Properties
	//		Used if view is in Tag-specific retorts view.  These values will be set either by parent Nav controller
	//		or by user click action.
	NSString *selectedTag;
	NSNumber *tagId;
	
	//Determines if the control is to render as a single tag-based retort list or not.
	//	This value is set programitically by the by the user click actions (handleTagSliderButtonClick & refreshDataClick).
	//	This value can also be set by a parent View Controller.  This is the case for the TagViewController.
	//	The default value is NO;
	BOOL isSingleTag;
	
	//Accelerometer properties
	//		Values are set by the iPhone's internal accelerometer.  These should not be set by any other methods
	UIAccelerationValue accelX;
	UIAccelerationValue accelY;
	NSTimeInterval lasttime;
	float lastX, lastY;
	float shakecount;
	float biggestshake;

@private
	//used to track the top of the table list so we can scroll back to it.
	NSIndexPath *startPoint;
}

// Handles the passoff to TRRetortFacade to begin data loading process.
- (void)loadDataWithUrl:(NSString *)relPath;

// The callback method that is fired (as a result of being registered with the NC) when data returns.
//		This method will either kick off the displayRetortsView: or present the missing data message
- (void)handleDataLoad:(NSNotification *)note;

// Handles basic UI preparation and calls displayRetortsForSingleTag: or displayRetortsForScreenZero:
- (void)displayRetortsView;

// Handles animating the interface from multitag retorts to single tag retorts and vice-versa. Not to be called externally.
- (void)displayRetortsForSingleTag;
- (void)displayRetortsForScreenZero;

// Interates through retort collection to build a TRTag object array and creates a tag slider with help
//		from the TRTagSliderHelper class.
- (void)buildTagSliderView;


//User Click actions
//	Occurs when user clicks refresh button on Nav Bar or the Shake is activiated.
- (void)refreshData;	

// Occurs when user clicks a specific Tag on the tag slider, if the tag slider is set in button mode (which it is by default).
- (void)handleTagSliderButtonClick:(id)sender;

// Occurs when the user clicks the "Get More Retorts" button.  This is caused when the list is filtered to a single tag and there are 25 items 
- (IBAction)nextPage:(id)sender;

@property (nonatomic, retain) TRRetortFacade *facade;
@property (nonatomic, retain) TRTagSliderHelper *slider;
@property (nonatomic, retain) NSMutableArray *retorts;
@property BOOL isSingleTag;
@property (nonatomic, retain) NSString *selectedTag;
@property (nonatomic, retain) NSNumber *tagId;
@property NSInteger currentPage;

@property (nonatomic, retain) UITableView *retortsView;
@property (nonatomic, retain) UITextView *loadFailureMessage;
@property (nonatomic, retain) UIScrollView *tagSlider;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) UIImageView *hover;
@end
