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

	//run on seperate thread, so create autorelease pool...
	NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
	TRSettingsFacade *aFacade = [[TRSettingsFacade alloc] init];
	//TRUser *aUser = [aFacade getStoredUser];
	self.currentUser = [aFacade getStoredUser];
	[aFacade loginWithUser:self.currentUser];
	//self.currentUser = aUser;
	JLog(@"AppDelegate current user: %@", self.currentUser);
	[aFacade release];
	[autoreleasepool release];

}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[NSThread detachNewThreadSelector:@selector(authenticateUser) toTarget:self withObject:nil];
	
	// Add the tab bar controller's current view as a subview of the window
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque]; 
    self.baseURL = [self fetchBaseURL];
	[window addSubview:tabBarController.view];
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

