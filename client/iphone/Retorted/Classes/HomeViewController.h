//
//  HomeViewController.h
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
	IBOutlet UITableView *retortsView;
	IBOutlet UIWebView *tagCloud;
	NSMutableArray *retorts;
	
}

@property (nonatomic, retain) NSMutableArray *retorts;
@end
