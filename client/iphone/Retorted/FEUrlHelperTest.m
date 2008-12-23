//
//  FEUrlHelperTest.m
//  Retorted
//
//  Created by Adam Strickland on 12/17/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "FEUrlHelperTest.h"


@implementation FEUrlHelperTest

- (void) setUp
{
	subject = [[FEUrlHelper alloc] init];
	nc = [NSNotificationCenter defaultCenter];
}

- (void) tearDown
{
	[nc removeObserver:self];
	[subject release];
	//[subject release];
}
/*
- (void) testLoadURLFromString
{	
	[nc addObserver:self 
		   selector:@selector(completeTestLoadURLFromString:) 
			   name:FEDataFinishedLoadingNotification 
			 object:nil];
	
	[subject loadURLFromString:@"http://localhost:3000/retorts/screenzero.xml"];
}

- (void) completeTestLoadURLFromString: (NSNotification *) note
{
	FEUrlHelper* notified_subject  = [note object];
	NSMutableData* result_data = [notified_subject.xmlData mutableBytes];
	STAssertNotNil(result_data, nil);
	NSString* results = [[NSString alloc] initWithData:result_data encoding:NSUnicodeStringEncoding];
	STAssertEqualObjects([results substringToIndex:10], [@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" substringToIndex:1], nil);
}
*/


- (void) testLoadURLFromString
{
	NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:3000/retorts/screenzero.xml"];	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[connection release];
	[request release];
	[url release];	
}

/*
- (void) testLoadURLFromString
{	
	[subject loadURLFromString:@"http://localhost:3000/retorts/screenzero"];	 
	 //NSString* results = [[NSString alloc] initWithData:[subject.xmlData mutableBytes] encoding:NSUTF8StringEncoding];
	 NSMutableData* results = [subject.xmlData mutableBytes];
	 STAssertNotNil(results, nil);
	 NSString* control_string = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
	 const char* control_string_utf8 = [control_string UTF8String];
	 NSMutableData* control = [NSMutableData dataWithBytes:control_string_utf8 length:strlen(control_string_utf8)];
	 STAssertEqualObjects(results, control, nil);	 
	 //NSString* results = [[NSString alloc] initWithData:result_data encoding:NSUnicodeStringEncoding];
	 //STAssertEqualObjects([results substringToIndex:10], [@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" substringToIndex:10], nil);
	
}
 */

- (void) completeTestLoadURLFromString: (NSNotification *) note{

}
@end
