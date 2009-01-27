//
//  SettingsViewController.m
//  Retorted
//
//  Created by B.J. Ray on 12/12/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "SettingsViewController.h"
#import "PerformanceStats.h"

//private methods and classes
@interface SettingsViewController()
@property BOOL refeshTableNeeded;

- (void)setupSettingsCell:(UITableViewCell *)cell;
- (void)configureSettingsCell:(UITableViewCell *)cell atRow:(NSUInteger)row;

- (void)setupStatsCell:(UITableViewCell *)cell;
- (void)configureStatsCell:(UITableViewCell *)cell atRow:(NSUInteger)row;
@end


@implementation SettingsViewController
@synthesize textFieldBeingEdited, tempValues;
@synthesize footerView, reset, sendStats, statsHelper;
@synthesize refeshTableNeeded;


- (void)viewDidLoad {
	self.title = NSLocalizedString(@"Settings", @"Title for the nav bar on the settings view screen");
	self.view.backgroundColor = [UIColor blackColor];

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithTitle:NSLocalizedString(@"Save", @"Nav bar button to save the user's settings")
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	// set up the table's footer view based on our UIView 'myFooterView' outlet
	CGRect newFrame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width-20.0, self.footerView.frame.size.height);
	//self.footerView.backgroundColor = [UIColor clearColor];
	self.footerView.frame = newFrame;
	
	self.tableView.tableFooterView = self.footerView;	// note this will override UITableView's 'sectionFooterHeight' property
	
	//initialize stats helper...
	self.statsHelper = [[PerformanceStats alloc] init];
	self.refeshTableNeeded = NO;
	
}



- (void)viewWillAppear:(BOOL)animated {
	if (self.refeshTableNeeded) {
		[self.tableView reloadData];
	}
	
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	JLog(@"Refreshing tableview");
	self.refeshTableNeeded = YES;
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
		return kNumberOfEditableRows;
	} else {
		return 5;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"User Settings";
	} else {
		return @"Data Statistics";
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingsCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		if (indexPath.section == 0) {
			//user settings...
			[self setupSettingsCell:cell];
		} else {
			//statistical information...
			[self setupStatsCell:cell];
		}
    }
	NSUInteger row = [indexPath row];
	if (indexPath.section == 0) {
		[self configureSettingsCell:cell atRow:row];
	} else {
		[self configureStatsCell:cell atRow:row];
	}
	
	
	
	return cell;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here. Create and push another view controller.
//	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
//	// [self.navigationController pushViewController:anotherViewController];
//	// [anotherViewController release];
//}




#pragma mark -
#pragma mark Table Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}
#pragma mark Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.textFieldBeingEdited = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
	[tempValues setObject:textField.text forKey:tagAsNum];
	[tagAsNum release];		
}


- (void)dealloc {
	[textFieldBeingEdited release];
	[tempValues release];
	[statsHelper release];
    [super dealloc];
}

#pragma mark -
#pragma mark Custom Helper Methods

//Adds a UILabel and UITextView to cell's content view, to prepare it for the actual data values...
- (void)setupSettingsCell:(UITableViewCell *)cell {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 25)];
	label.textAlignment = UITextAlignmentRight;
	label.tag = kLabelTag;
	label.font = [UIFont boldSystemFontOfSize:14];
	[cell.contentView addSubview:label];
	[label release];
	
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 200, 25)];
	textField.clearsOnBeginEditing = NO;
	[textField setDelegate:self];
	//textField.returnKeyType = UIReturnKeyDone;
	[textField addTarget:self 
				  action:@selector(textFieldDone:) 
		forControlEvents:UIControlEventEditingDidEndOnExit];
	[cell.contentView addSubview:textField];	
	[textField release];
}

//Adds the actual data to the cell and it's contents that were set up by setupSettingsCell: method.
- (void)configureSettingsCell:(UITableViewCell *)cell atRow:(NSUInteger)row {
	UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
	UITextField *textField = nil;
	for (UIView *oneView in cell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextField class]])
			textField = (UITextField *)oneView;
	}
	
	NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
    
	switch (row) {
		case kEmailRowIndex:
			label.text = NSLocalizedString(@"Email", @"The label 'Email' for the settings table cell");
			textField.keyboardType = UIKeyboardTypeEmailAddress;
			textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			
			if ([[tempValues allKeys] containsObject:rowAsNum]) {
				textField.text = [tempValues objectForKey:rowAsNum];
			} else {
				textField.placeholder = NSLocalizedString(@"Enter Email Here","Placeholder text requesting email address in settings table cell");
			}
			break;
		case kPasswordRowIndex:
			label.text = NSLocalizedString(@"Password", @"The label 'Password' for settings table cell");
			textField.keyboardType = UIKeyboardTypeDefault;
			textField.secureTextEntry = YES;
			if ([[tempValues allKeys] containsObject:rowAsNum])
				textField.text = [tempValues objectForKey:rowAsNum];
			else
				//textField.text = @"Test Data";
				textField.placeholder = NSLocalizedString(@"Enter Password Here", "Placeholder text requesting password in settings table cell");
			break;
		default:
			break;
	}
	if (textFieldBeingEdited == textField)
		textFieldBeingEdited = nil;
	
	textField.tag = row;
	[rowAsNum release];
}

//Adds two UILabels to cell's content view, to prepare it for the actual data values...
- (void)setupStatsCell:(UITableViewCell *)cell {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 149, 25)];
	label.textAlignment = UITextAlignmentRight;
	label.tag = kLabelTag;
	label.font = [UIFont boldSystemFontOfSize:14];
	[cell.contentView addSubview:label];
	[label release];
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(177, 10, 123, 25)];
	label.textAlignment = UITextAlignmentLeft;
	label.tag = kResultTag;
	label.font = [UIFont systemFontOfSize:14];
	label.textColor = [UIColor blueColor];
	[cell.contentView addSubview:label];
	[label release];
}

//adds the content to the four statistics cells
- (void)configureStatsCell:(UITableViewCell *)cell atRow:(NSUInteger)row {
	UILabel *titleLbl = (UILabel *)[cell viewWithTag:kLabelTag];
	UILabel *valueLbl = (UILabel *)[cell viewWithTag:kResultTag];


	switch (row) {
		case 0:
			titleLbl.text = @"Run Count:";
			valueLbl.text = [NSString stringWithFormat:@"%d", [self.statsHelper totalRecordCount]];
			break;
		case 1:
			titleLbl.text = @"Avg. Download Time:";
			valueLbl.text = [NSString stringWithFormat:@"%.2f sec.", [self.statsHelper meanDownloadTime]];
			break;
		case 2:
			titleLbl.text = @"Avg. Parse Time:";
			valueLbl.text = [NSString stringWithFormat:@"%.2f sec.", [self.statsHelper meanParseTime]];
			break;
		case 3:
			titleLbl.text = @"Avg. Total Time:";
			valueLbl.text = [NSString stringWithFormat:@"%.2f sec.", [self.statsHelper meanTotalTime]];
			break;
		case 4:
			titleLbl.text = @"Avg. Total Bytes:";
			valueLbl.text = [NSString stringWithFormat:@"%d bytes.", [self.statsHelper meanByteCount]];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark VC custom event methods

- (IBAction)cancel:(id)sender {
	JLog(@"Cancel action");
	[textFieldBeingEdited resignFirstResponder];
	
}

- (IBAction)save:(id)sender {
	JLog(@"Initiate save action");
	[textFieldBeingEdited resignFirstResponder];
}

- (IBAction)textFieldDone:(id)sender {
	UITableViewCell *cell = (UITableViewCell *)[[(UIView *)sender superview] superview];
	UITableView *table = (UITableView *)[cell superview];
	NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
	NSUInteger row = [textFieldIndexPath row];
	row++;
	if (row >= kNumberOfEditableRows)
		row = 0;
	NSUInteger newIndex[] = {0, row};
	NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
	UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:newPath];
	UITextField *nextField = nil;
	for (UIView *oneView in nextCell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextField class]])
			nextField = (UITextField *)oneView;
	}
	[nextField becomeFirstResponder];
}

- (IBAction)sendStatsToServer:(id)sender {
	JLog(@"Sending stats to server...");
}

- (IBAction)resetDB:(id)sender {
	JLog(@"Reseting local stats database...");
	BOOL result = [self.statsHelper resetPerformanceStatsDatabase];
	
	// open an alert with just an OK button
	NSString *msg = nil;
	if (result) {
		msg = [NSString stringWithFormat:@"Successful reseting statistics database."];
	} else {
		msg = [NSString stringWithFormat:@"Failed reseting statistics database."];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Stats DB" message:msg
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	JLog(@"%@", buttonIndex);
	[self.tableView reloadData];
}
@end

