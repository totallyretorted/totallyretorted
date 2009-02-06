//
//  UrlHelper.m
//  XmlReaderSpike
//
//  Created by B.J. Ray on 11/19/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "FEUrlHelper.h"
NSString * const FEDataFinishedLoadingNotification = @"DWDataFinishedLoading";
NSString * const FEDataFailedLoadingNotification = @"DWDataFailedLoading";


@implementation FEUrlHelper
@synthesize xmlData, errorMsg, errorCode, ignoreBadCertificate;

- (id)init {
	if (![super init]) {
		return nil;
	}
	self.xmlData = [[NSMutableData alloc]init];
	self.errorMsg = nil;
	self.errorCode = 0;
	self.ignoreBadCertificate = NO;
	return self;
}

- (void)loadURLFromString:(NSString *)sUrl withContentType:(NSString *)contentType HTTPMethod:(NSString *)method body:(NSString *)httpBody {
	JLog(@"Start download process.");
	NSURL *url = [[NSURL alloc] initWithString:sUrl];
	JLog(@"Created url: %@ with port: %@", url, [url port]);
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	JLog(@"Created request...");
	
//	TODO: May not need - leave code in until we finish SSL and test
//	if (self.ignoreBadCertificate) {
//		// Use the private method setAllowsAnyHTTPSCertificate:forHost:
//		// to not validate the HTTPS certificate.
//		[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
//	}
	
	[request setHTTPMethod:method];												//for example, POST or GET
	[request setValue:contentType forHTTPHeaderField:@"Content-Type"];			//for example: @"application/xml"
	
	
	if ((httpBody != nil) && ([httpBody length] > 0)) {
		[request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	JLog(@"Created connection...");
	[connection release];
	[request release];
	[url release];
}


- (void)loadURLFromString: (NSString *) sUrl {
	[self loadURLFromString:sUrl withContentType:@"text/html" HTTPMethod:@"GET" body:nil];
}

- (NSString *)base64EncodedWithUserName:(NSString *)user password:(NSString *)pwd {
	NSString *format = [NSString stringWithFormat:@"%@:%@", user, pwd];
	return [NSString stringWithFormat:@"Basic %@",[format base64Encoding]];
}

#pragma mark -
#pragma mark Async Connection delegate methods
- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:FEDataFinishedLoadingNotification object:self];
	JLog(@"Sending finished notification: FEDataFinishedLoadingNotification - Call back after url done loading notification.");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.xmlData appendData:data];
	JLog(@"Receiving data - Data byte length: %d", data.length);
}
	
- (void)connection: (NSURLConnection *)connection didFailWithError: (NSError *)error {

	JLog(@"Error encountered: Failed loading with code: %d and description: %@", [error code], [error localizedDescription]);
	self.errorMsg = [error localizedDescription];
	self.errorCode = [error code];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	JLog(@"Sending failure notification");
	[nc postNotificationName:FEDataFailedLoadingNotification object:self];

}


#pragma mark -
#pragma mark Password Challenge  Delegate Methods


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)aChallenge {
	//NSString *username = nil;
	//NSString *password = nil;
	
	if ([aChallenge previousFailureCount] != 0)  {
		
	} else {
		
	}
	
	
	//or to cancel

}

//call to attempt to authenticate
- (void) handleAuthenticationOKForChallenge: (NSURLAuthenticationChallenge *) aChallenge
								   withUser: (NSString*) username
								   password: (NSString*) password {
	// try to reply to challenge
	NSURLCredential *credential = [[NSURLCredential alloc]
								   initWithUser:username
								   password:password
								   persistence:NSURLCredentialPersistenceForSession];
	[[aChallenge sender] useCredential:credential forAuthenticationChallenge:aChallenge];
	[credential release];
	JLog(@"Sending authentication credential");
}


//call to cancel attempt to authenticate
- (void) handleAuthenticationCancelForChallenge: (NSURLAuthenticationChallenge *) aChallenge {
	[[aChallenge sender] cancelAuthenticationChallenge: aChallenge];
}

- (NSString *)description {
	return @"UrlHelper";
}

- (void)dealloc {
	[xmlData release];
	[super dealloc];
}

@end
