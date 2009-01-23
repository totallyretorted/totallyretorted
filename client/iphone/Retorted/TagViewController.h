//
//  TagViewController.h
//  Retorted
//
//  Created by a on 12/23/08.
//  Copyright 2008 Forward Echo LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRTagFacade;

@interface TagViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *tags;
	TRTagFacade *tagFacade;
	IBOutlet UILabel *loadFailurelbl;
	IBOutlet UITableView *tagsView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
}

@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) TRTagFacade *tagFacade;
@property (nonatomic, retain) UITableView *tagsView;
@property (nonatomic, retain) UILabel *loadFailurelbl;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void) loadURL;
-(void) handleDataLoad:(NSNotification *)note;
-(void) cleanTags: (NSMutableArray *)ts;

@end
