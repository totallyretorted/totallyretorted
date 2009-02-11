//
//  TagViewController.h
//  Retorted
//
//  Created by a on 12/23/08.
//  Copyright 2008 Forward Echo LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRNotificationInterface.h"
@class TRTagFacade;

@interface TagViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TRNotificationInterface> {
	IBOutlet UILabel *loadFailurelbl;						//failure message in the event we do not reach the url
	IBOutlet UITableView *tagsView;							//the table view containing the list of tags
	IBOutlet UIActivityIndicatorView *activityIndicator;	//indicator for arriving data
	IBOutlet UISearchBar *tagSearchBar;
	
	NSMutableArray *tags;			// an array of TRTag objects
	TRTagFacade *tagFacade;			//Handles details on getting data from internet, parsing XML, and populating model objects.
}

@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) TRTagFacade *tagFacade;
@property (nonatomic, retain) UITableView *tagsView;
@property (nonatomic, retain) UILabel *loadFailurelbl;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UISearchBar *tagSearchBar;

-(void) loadURL;
-(void) handleDataLoad:(NSNotification *)note;
-(void) cleanTags: (NSMutableArray *)ts;

@end
