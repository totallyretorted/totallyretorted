//
//  HomeViewController.h
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRRetortFacade;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAccelerometerDelegate>  {
	IBOutlet UITableView *retortsView;
	IBOutlet UIWebView *tagCloud;
	IBOutlet UITextView *loadFailureMessage;
	
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

@property (nonatomic, retain) TRRetortFacade *facade;
@property (nonatomic, retain) NSMutableArray *retorts;

@property (nonatomic, retain) UITableView *retortsView;
@property (nonatomic, retain) UITextView *loadFailureMessage;
@property (nonatomic, retain) UIWebView *tagCloud;
@end
