//
//  RetortViewController.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRRetort;

@interface RetortViewController : UIViewController {
	IBOutlet UITextView *retortText;
	IBOutlet UIWebView *tagCloud;
	IBOutlet UISegmentedControl *ratingVote;
	
	TRRetort *retort;
	NSString *retortTitle;		//Temp holder until we get REST up and running.
	
}

- (IBAction)ratingChanged:(id)sender;

@property (nonatomic, retain) TRRetort *retort;
@property (nonatomic, retain) NSString *retortTitle;
@end
