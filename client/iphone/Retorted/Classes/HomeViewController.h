//
//  HomeViewController.h
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRRetortFacade;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
	IBOutlet UITableView *retortsView;
	IBOutlet UIWebView *tagCloud;
	NSMutableArray *retorts;
	TRRetortFacade *facade;
}

- (void)loadURL;
- (void)handleDataLoad;
@property (nonatomic, retain) TRRetortFacade *facade;
@property (nonatomic, retain) NSMutableArray *retorts;
@end
