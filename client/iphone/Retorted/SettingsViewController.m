//
//  SettingsViewController.m
//  Retorted
//
//  Created by B.J. Ray on 12/12/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController
@synthesize textFieldBeingEdited, tempValues;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
	self.title = @"Settings";
	self.view.backgroundColor = [UIColor blackColor];
	/*
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
									 initWithTitle:@"Cancel"
									 style:UIBarButtonItemStylePlain
									 target:self
									 action:@selector(cancel:)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	*/
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Save" 
								   style:UIBarButtonItemStyleDone
								   target:self
								   action:@selector(save:)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfEditableRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingsCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
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
    }
	NSUInteger row = [indexPath row];
	
	UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
	UITextField *textField = nil;
	for (UIView *oneView in cell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextField class]])
			textField = (UITextField *)oneView;
	}
	
	//label.text = [fieldLabels objectAtIndex:row];
	NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
    
	switch (row) {
		case kEmailRowIndex:
			label.text = @"Email";
			textField.keyboardType = UIKeyboardTypeEmailAddress;
			textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			
			if ([[tempValues allKeys] containsObject:rowAsNum]) {
				textField.text = [tempValues objectForKey:rowAsNum];
			} else {
				textField.placeholder = @"Enter Email Here";
			}
			break;
		case kPasswordRowIndex:
			label.text = @"Password";
			textField.keyboardType = UIKeyboardTypeDefault;
			textField.secureTextEntry = YES;
			if ([[tempValues allKeys] containsObject:rowAsNum])
				textField.text = [tempValues objectForKey:rowAsNum];
			else
				//textField.text = @"Test Data";
				textField.placeholder = @"Enter Password Here";
			break;
		default:
			break;
	}
	if (textFieldBeingEdited == textField)
		textFieldBeingEdited = nil;
	
	textField.tag = row;
	[rowAsNum release];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    [super dealloc];
}

#pragma mark -
#pragma mark VC custom event methods

- (IBAction)cancel:(id)sender {
	NSLog(@"Cancel action");
	[textFieldBeingEdited resignFirstResponder];
	
}

- (IBAction)save:(id)sender {
	NSLog(@"Initiate save action");
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

@end

