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
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	FEUrlHelper *aHelper = [[FEUrlHelper alloc] init];
	
	NSString *sUrl = [NSString stringWithFormat:@"%@/session/verify.xml", appDelegate.baseURL];
	JLog(@"Attempting to connect as %@ to url:%@", user, sUrl);
	
	NSURL *url = [[NSURL alloc] initWithString:sUrl];
	NSData *dataBody = [[NSData alloc] init];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
	[request addValue:[aHelper base64EncodedWithUserName:user.userName password:user.password] forHTTPHeaderField:@"Authorization"];
	[request setHTTPBody:dataBody];
	
	
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];

	NSData *responseData = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:&urlResponse 
															 error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData
											 encoding:NSUTF8StringEncoding];
	JLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] == 202 && error == nil) {
		success = YES;
	}
	
	//update user object and add to app delegate for session.
	[user userValidationStatus:success];
	appDelegate.currentUser = user;
	
	[aHelper release];
	[url release];
	[request release];
	[error release];
	[result release];
	
	return success;
}

- (void)dealloc {
	[super dealloc];
}

@end
