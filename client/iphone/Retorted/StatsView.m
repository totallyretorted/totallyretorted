//
//  StatsView.m
//  Retorted
//
//  Created by B.J. Ray on 1/25/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "StatsView.h"


@implementation StatsView
@synthesize avgTotalDuration, avgParseDuration, avgDownloadDuration, runCount;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)resetStatisticsDB:(id)sender {
	NSLog(@"Reset Statistics button clicked");
}

@end
