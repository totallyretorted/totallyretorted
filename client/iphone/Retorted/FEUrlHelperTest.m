//
//  FEUrlHelperTest.m
//  Retorted
//
//  Created by B.J. Ray on 12/17/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "FEUrlHelperTest.h"
#import "FEUrlHelper.h"

@implementation FEUrlHelperTest
@synthesize subject;

- (void)setUp {
	self.subject = [[FEUrlHelper alloc] init];
	//subject = [[FEUrlHelper alloc] init];
	
}

- (void)tearDown {
	self.subject = nil;
	//[subject release];
}


- (void) testLoadURLFromString
{
	NSLog(@"FEUrlHelperTest: testLoadURLFromString");
	[self.subject loadURLFromString:@"http://localhost:3000/retorts/screenzero.xml"];
	NSString* results = [[NSString alloc] initWithData:[self.subject.xmlData mutableBytes] encoding:NSUTF8StringEncoding];
	
	NSLog(@"substring: %@", [results substringToIndex:10]);

	//STAssertEqualObjects([results substringToIndex:10], [@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" substringToIndex:10], nil);
}


@end
