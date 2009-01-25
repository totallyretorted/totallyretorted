//
//  RetortedAppDelegate.m
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import "RetortedAppDelegate.h"
#import "PerformanceStats.h"
#import "Statistic.h"

@implementation RetortedAppDelegate

@synthesize window, tabBarController;
@synthesize statHelper; 


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	self.statHelper = [[PerformanceStats alloc] init];
	
	
    // Add the tab bar controller's current view as a subview of the window
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
    [window addSubview:tabBarController.view];
}

- (void)addParserStatistic:(Statistic *)stat {
	self.statHelper.parserStat = stat;
	NSLog(@"RetortedAppDelegate: Parser: %@", stat);
}

- (void)addDownloadStatistic:(Statistic *)stat {
	self.statHelper.downloadStat = stat;
	NSLog(@"RetortedAppDelegate: Download: %@", stat);
}

- (void)saveStatistic {
	[self.statHelper saveCurrentStatistics];
}

- (double)getMeanParseTime {
	double parseTime = [self.statHelper meanParseTime];
	[self.statHelper cleanupDBConnection:[self.statHelper getOpenDB]];
	
	return parseTime;
}

- (double)getMeanParseTimeForUrl:(NSString *) aUrl {
	double parseTime = [self.statHelper meanParseTimeForUrl: aUrl];
	[self.statHelper cleanupDBConnection:[self.statHelper getOpenDB]];
	
	return parseTime;
}
/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
	[statHelper release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

