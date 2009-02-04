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

@implementation TRAuthenticationHelper

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	return self;
}

- (BOOL)connectAsUser:(TRUser *)user {
	BOOL success = NO;
	JLog(@"Attempting to connect as %@", user);
	
//	FEUrlHelper *urlHelper = [[FEUrlHelper alloc] init];
//	[urlHelper loadURLFromString:<#(NSString *)sUrl#> withContentType:<#(NSString *)contentType#> HTTPMethod:<#(NSString *)method#> body:<#(NSString *)httpBody#>
	
	NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"]]; 
#if TARGET_CPU_ARM
	NSString* sURL = [NSString stringWithFormat:@"http://%@:%@@totallyretorted.com/path/to/resource.xml", 
					  user.userName,
					  user.password];
#else
	NSString* sUrl = [NSString stringWithFormat:@"http://%@:%@@localhost:3000/path/to/resource.xml", 
					  user.userName,
					  user.password,
					  [properties valueForKey:@"Simulator.Host"]];
#endif

	JLog(@"URL: %@", sUrl);
	NSURL *url = [[NSURL alloc] initWithString:sUrl];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];

	NSData *responseData = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:&urlResponse 
															 error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData
											 encoding:NSUTF8StringEncoding];
	JLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300 && error != nil)
		success = YES;
	
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
