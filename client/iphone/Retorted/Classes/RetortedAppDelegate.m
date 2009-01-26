//
//  RetortedAppDelegate.m
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import "RetortedAppDelegate.h"
#import "Statistic.h"

@implementation RetortedAppDelegate

@synthesize window, tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Add the tab bar controller's current view as a subview of the window
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
    [window addSubview:tabBarController.view];
}

- (void)dealloc {
	//[statHelper release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

