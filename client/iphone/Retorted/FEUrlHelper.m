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
	NSLog(@"UrlHelper: loadUrlFromString: called");
	NSURL *url = [[NSURL alloc] initWithString:sUrl];
	NSLog(@"UrlHelper: created url...");
	NSLog(@"UrlHelper: url port: %@", [url port]);
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	NSLog(@"UrlHelper: created request...");
	if (self.ignoreBadCertificate) {
		// Use the private method setAllowsAnyHTTPSCertificate:forHost:
		// to not validate the HTTPS certificate.
		[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
	}
	
	[request setHTTPMethod:method];												//for example, POST or GET
	[request setValue:contentType forHTTPHeaderField:@"Content-Type"];			//for example: @"application/xml"
	
	
	if ((httpBody != nil) && ([httpBody length] > 0)) {
		[request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	//[request setHTTPBody:[[self xml] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"UrlHelper: created connection...");
	[connection release];
	[request release];
	[url release];
}

/*
Issue: NSURLRequest will not handle XML, so we will need to use NSXMLParser.  
 
 
 See the SeismicXML example for further details.
*/
- (void)loadURLFromString: (NSString *) sUrl {
	[self loadURLFromString:sUrl withContentType:@"text/html" HTTPMethod:@"GET" body:nil];
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSLog(@"URLHelper: Sending finished notification: FEDataFinishedLoadingNotification");
	NSLog(@"URLHelper: total data byte length: %d", self.xmlData.length);
	[nc postNotificationName:FEDataFinishedLoadingNotification object:self];
	NSLog(@"URLHelper: call back after url done loading notification.");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"URLHelper: receiving data");
	[self.xmlData appendData:data];
	NSLog(@"URLHelper: data byte length: %d", data.length);
}
	
- (void)connection: (NSURLConnection *)connection didFailWithError: (NSError *)error {

	NSLog(@"URLHelper: Error encountered: Failed loading with code: %d and description: %@", [error code], [error localizedDescription]);
	self.errorMsg = [error localizedDescription];
	self.errorCode = [error code];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSLog(@"URLHelper: Sending failure notification");
	[nc postNotificationName:FEDataFailedLoadingNotification object:self];

}


#pragma mark -
#pragma mark Cassword Challenge  Delegate Methods


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
	NSLog(@"Sending authentication credential");
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
