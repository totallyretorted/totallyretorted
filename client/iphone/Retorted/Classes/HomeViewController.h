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
@class FETabScrollView;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAccelerometerDelegate, TRNotificationInterface>  {
	IBOutlet UITableView *retortsView;
	IBOutlet UITextView *loadFailureMessage;
	IBOutlet FETabScrollView *tagSlider;
	
	NSMutableArray *retorts;
	TRRetortFacade *facade;
	
	UIAccelerationValue accelX;
	UIAccelerationValue accelY;
	NSTimeInterval lasttime;
	float shakecount;
	float biggestshake;
	float lastX, lastY;
}

- (void)loadURL;
- (void)handleDataLoad:(NSNotification *)note;
- (void)buildTagSliderView;
- (void)refreshData;


@property (nonatomic, retain) TRRetortFacade *facade;
@property (nonatomic, retain) NSMutableArray *retorts;

@property (nonatomic, retain) UITableView *retortsView;
@property (nonatomic, retain) UITextView *loadFailureMessage;
@property (nonatomic, retain) FETabScrollView *tagSlider;
@end
