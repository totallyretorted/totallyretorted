//
//  RetortViewController.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRRetort;

#define kMinimumPinchDelta 100		//defines the minimum distance that constitues a pinch

@interface RetortViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UITextView *retortText;
	IBOutlet UIWebView *tagCloud;
	IBOutlet UISegmentedControl *ratingVote;
	
	TRRetort *retort;
	NSString *retortTitle;		//Temp holder until we get REST up and running.
	
	CGFloat initialDistance;	//used for pinch gesture.
}

- (IBAction)ratingChanged:(id)sender;

@property (nonatomic, retain) TRRetort *retort;
@property (nonatomic, retain) NSString *retortTitle;
@property CGFloat initialDistance;
@end
