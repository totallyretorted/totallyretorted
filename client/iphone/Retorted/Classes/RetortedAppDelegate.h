//
//  RetortedAppDelegate.h
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PerformanceStats;
@class Statistic;

@interface RetortedAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	PerformanceStats *statHelper;
}

//pushes the stat to the appropriate "current" property set on the PerformanceStat class
- (void)addParserStatistic:(Statistic *)stat;		
- (void)addDownloadStatistic:(Statistic *)stat;

//instructs the PerformanceStats class to save the "current" property sets to the database
- (void)saveStatistic;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) PerformanceStats *statHelper;

@end
