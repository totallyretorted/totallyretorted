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

@interface RetortViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	//UI componenets
	IBOutlet UIScrollView *retortContainer;		//container for retort text and retort attributions
	IBOutlet UIScrollView *tagSlider;			//list of tags associated with the retort
	IBOutlet UISegmentedControl *ratingVote;	//rocks vs sucks
	UIBarButtonItem *retortActionButton;		//activates a uiactionsheet to allow the user to add to favorites (eventually facebook)
	
	TRRetort *retort;
	NSString *retortTitle;		//Temp holder until we get REST up and running.
	
	CGFloat initialDistance;	//used for pinch gesture.
}

- (IBAction)ratingChanged:(id)sender;
- (IBAction)retortActionClick;
- (void)buildTagSliderView;

@property (nonatomic, retain) UIBarButtonItem *retortActionButton;
@property (nonatomic, retain) TRRetort *retort;
@property (nonatomic, retain) NSString *retortTitle;
@property (nonatomic, retain) UIScrollView *tagSlider;
@property CGFloat initialDistance;
@end
