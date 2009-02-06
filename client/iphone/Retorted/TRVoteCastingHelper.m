//
//  TRVoteCastingHelper.m
//  Retorted
//
//  Created by B.J. Ray on 1/29/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRVoteCastingHelper.h"
#import "RetortedAppDelegate.h"
#import "TRUser.h"
#import "FEUrlHelper.h"

@interface TRVoteCastingHelper()

- (NSString *)urlForVote;
- (NSString *)votePayloadForVote:(TRRetortVoteCast)aVote;
@end


@implementation TRVoteCastingHelper
@synthesize retortId;

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	return self;
}

- (BOOL)castVote:(TRRetortVoteCast)voteCasted {
	BOOL success = NO;
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	FEUrlHelper *aHelper = [[FEUrlHelper alloc] init];
	
	//determine the url we are sending vote to...
	NSString *sUrl = [self urlForVote];
	
	NSString *payload = [self votePayloadForVote:voteCasted];
	JLog(@"Payload: %@ sent to URL: %@", payload, sUrl);
	
	//prepare connection information...
	NSURL *url = [[NSURL alloc] initWithString:sUrl];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[payload dataUsingEncoding: NSUTF8StringEncoding]];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
	[request addValue:[aHelper base64EncodedWithUserName: appDelegate.currentUser.userName password:appDelegate.currentUser.password] forHTTPHeaderField:@"Authorization"];
	
	NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init];
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:&urlResponse 
															 error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData
											 encoding:NSUTF8StringEncoding];
	JLog(@"Response Code: %d", [urlResponse statusCode]);
	if ([urlResponse statusCode] == 201 && error == nil) {
		success = YES;
	}
	
	[aHelper release];
	[url release];
	[request release];
	[error release];
	[result release];
	
	return success;
}

- (NSString *)votePayloadForVote:(TRRetortVoteCast)aVote {
	return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><vote><value>%d</value></vote>", aVote];
}

- (NSString *)urlForVote {
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];	
	return [NSString stringWithFormat:@"%@/retorts/%d/votes.xml", appDelegate.baseURL, self.retortId];
}


- (void)dealloc {
	[super dealloc];
}
@end
