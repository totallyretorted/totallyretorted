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

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAccelerometerDelegate, TRNotificationInterface>  {
	IBOutlet UITableView *retortsView;
	IBOutlet UITextView *loadFailureMessage;
	IBOutlet UIScrollView *tagSlider;
	
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
//- (void)removeFromAllNotifications;
//- (void)addToNotificationWithSelector:(SEL)selector notificationName:(NSString *)name;


@property (nonatomic, retain) TRRetortFacade *facade;
@property (nonatomic, retain) NSMutableArray *retorts;

@property (nonatomic, retain) UITableView *retortsView;
@property (nonatomic, retain) UITextView *loadFailureMessage;
//@property (nonatomic, retain) UIWebView *tagCloud;
@property (nonatomic, retain) UIScrollView *tagSlider;
@end
