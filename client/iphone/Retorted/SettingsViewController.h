//
//  SettingsViewController.h
//  Retorted
//
//  Created by B.J. Ray on 12/12/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#define kNumberOfEditableRows	2		//total number of rows to edit.
#define kEmailRowIndex			0
#define kPasswordRowIndex		1
										//add more as needed

#define kLabelTag			4096		//tag for label on left side
#define kResultTag			2058		//tag for lable used to list stats

#import <UIKit/UIKit.h>
@class PerformanceStats;

@interface SettingsViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
	UITextField *textFieldBeingEdited;
	IBOutlet UIView *footerView;
	IBOutlet UIButton *reset;
	IBOutlet UIButton *sendStats;
	
	NSMutableDictionary *tempValues;
	PerformanceStats *statsHelper;
@private
	BOOL refeshTableNeeded;
}

@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) UIButton *reset;
@property (nonatomic, retain) UIButton *sendStats;
@property (nonatomic, retain) PerformanceStats *statsHelper;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (IBAction)resetDB:(id)sender;
- (IBAction)sendStatsToServer:(id)sender;

@end
