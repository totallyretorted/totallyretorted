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

#define kLabelTag			4096

#import <UIKit/UIKit.h>


@interface SettingsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITextField *textFieldBeingEdited;
	NSMutableDictionary *tempValues;
}

@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) NSMutableDictionary *tempValues;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;

@end
