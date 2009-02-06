//
//  RetortedAppDelegate.m
//  Retorted
//
//  Created by B.J. Ray on 12/2/08.
//  Copyright Forward Echo, LLC 2008. All rights reserved.
//

#import "RetortedAppDelegate.h"
#import "Statistic.h"
#import "TRUser.h"
#import "TRSettingsFacade.h"

@interface RetortedAppDelegate()
- (NSString *)fetchBaseURL;
@end


@implementation RetortedAppDelegate

@synthesize window, tabBarController, currentUser, baseURL;

- (void)authenticateUser {
	TRSettingsFacade *aFacade = [[TRSettingsFacade alloc] init];
	TRUser *aUser = [aFacade getStoredUser];
	[aFacade loginWithUser:aUser];
	self.currentUser = aUser;
	JLog(@"AppDelegate current user: %@", self.currentUser);
	[aFacade release];
//	JLog(@"I'm here!");
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Add the tab bar controller's current view as a subview of the window
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
    [window addSubview:tabBarController.view];

	self.baseURL = [self fetchBaseURL];
	
	
	[self authenticateUser];
	//[NSThread detachNewThreadSelector:@selector(authenticateUser) toTarget:self withObject:nil];
}

- (NSString *)fetchBaseURL {
	NSString *urlScheme = nil;
	NSString *urlHost = nil;
	NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" 
																										  ofType:@"plist"]];
	
#if TARGET_CPU_ARM
	urlScheme = [properties valueForKey:@"Retorted.Scheme"];
	urlHost = [properties valueForKey:@"Retorted.Host"];
#else
	urlScheme = [properties valueForKey:@"Simulator.Scheme"];
	urlHost = [properties valueForKey:@"Simulator.Host"];
#endif
	
	return [NSString stringWithFormat:@"%@%@", urlScheme, urlHost];
	
}



- (void)dealloc {
	//[statHelper release];
	[currentUser release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

