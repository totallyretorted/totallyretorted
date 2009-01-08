//
//  RetortByTagListViewController.h
//  Retorted
//
//  Created by B.J. Ray on 1/7/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRNotificationInterface.h"

@class TRRetortFacade;

@interface RetortByTagListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAccelerometerDelegate, TRNotificationInterface> {
	IBOutlet UITableView *retortsView;
	IBOutlet UITextView *loadFailureMessage;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	NSMutableArray *retorts;
	TRRetortFacade *facade;
	NSString *selectedTag;
	NSNumber *tagId;
	
	UIAccelerationValue accelX;
	UIAccelerationValue accelY;
	NSTimeInterval lasttime;
	float shakecount;
	float biggestshake;
	float lastX, lastY;
}

- (void)loadURL;
- (void)handleDataLoad:(NSNotification *)note;
- (void)refreshData;

@property (nonatomic, retain) TRRetortFacade *facade;
@property (nonatomic, retain) NSMutableArray *retorts;
@property (nonatomic, retain) NSString *selectedTag;
@property (nonatomic, retain) NSNumber *tagId;

@property (nonatomic, retain) UITableView *retortsView;
@property (nonatomic, retain) UITextView *loadFailureMessage;
@end
