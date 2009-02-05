//
//  TRAuthenticationHelper.m
//  Retorted
//
//  Created by B.J. Ray on 1/28/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRAuthenticationHelper.h"
#import "TRUser.h"
#import "FEUrlHelper.h"
#import "RetortedAppDelegate.h"

@implementation TRAuthenticationHelper

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	return self;
}

- (BOOL)connectAsUser:(TRUser *)user {
	BOOL success = NO;
	
	
	NSString *sUrl = [NSString stringWithFormat:@"%@/session/verify.xml", [user userCredentialsURLBase]];

	JLog(@"Attempting to connect as %@ to url:%@", user, sUrl);
	NSURL *url = [[NSURL alloc] initWithString:sUrl];
	//NSString *body = @"";
	NSData *dataBody = [[NSData alloc] init];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	//NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	//[request setHTTPBody:[body dataUsingEncoding: NSUTF8StringEncoding]];
	[request setHTTPBody:dataBody];
	
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];

	NSData *responseData = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:&urlResponse 
															 error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData
											 encoding:NSUTF8StringEncoding];
	JLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] == 202 && error != nil) {
		success = YES;
	}
	
	//update user object and add to app delegate for session.
	[user userValidationStatus:success];
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.currentUser = user;
	
	[url release];
	[request release];
	[error release];
	[result release];
	
	return success;
}

////Return the appropriate url based on simulator vs device for a given user.
//- (NSString *)URLForUser:(TRUser *)user {
//	NSString *urlScheme = nil;
//	NSString *urlHost = nil;
//	NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" 
//																										  ofType:@"plist"]]; 
//	
//#if TARGET_CPU_ARM
//	urlScheme = [properties valueForKey:@"Retorted.Scheme"];
//	urlHost = [properties valueForKey:@"Retorted.Host"];
//#else
//	urlScheme = [properties valueForKey:@"Simulator.Scheme"];
//	urlHost = [properties valueForKey:@"Simulator.Host"];
//#endif
//	
//	//EXAMPLE: http://shant.donabedian:durkadurka@totallyretorted.com/path/to/resource.xml
//	return [NSString stringWithFormat:@"%@%@:%@@%@", urlScheme, user.userName, user.password, urlHost];
//}

- (void)dealloc {
	[super dealloc];
}

@end
