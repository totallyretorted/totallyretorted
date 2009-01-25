//
//  StatsView.h
//  Retorted
//
//  Created by B.J. Ray on 1/25/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatsView : UIView {
	IBOutlet UILabel *avgTotalDuration;
	IBOutlet UILabel *avgParseDuration;
	IBOutlet UILabel *avgDownloadDuration;
	IBOutlet UILabel *runCount;
	
}

@end
