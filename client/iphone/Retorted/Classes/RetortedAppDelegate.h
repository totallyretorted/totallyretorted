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
@class TRUser;

@interface RetortedAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	TRUser *currentUser;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) TRUser *currentUser;
@end
