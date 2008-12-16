//
//  TRRetortXMLParserTest.m
//  Retorted
//
//  Created by Adam Strickland on 12/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TRRetortXMLParserTest.h"




@implementation TRRetortXMLParserTest

/*
- (id) init
{
	
}
 */

- (void) setUp
{
	subject = [[TRRetortXMLParser alloc] init];
	err = nil;
}

- (void) tearDown
{
	[subject release];
}

- (void) testSuperSimpleParseXml
{
	NSString * inputXml = @"<retorts><retort id=\"999\"><content>This is a simple test</content></retort></retorts>";
	NSData* input = [NSData dataWithBytes:inputXml length:[inputXml length]];
	
	STAssertNil(err, nil);
	
	[subject parseRetortXML:input parseError:&err];
	
	//STAssertNil(err, @"NSError object is not nil.  Error: '%@', Suggested Recovery: '%@'", [err localizedFailureReason], [err localizedRecoverySuggestion]);	

	NSMutableArray* results = subject.retorts;
	
	STAssertNotNil(results, nil);
	STAssertEqualObjects([NSNumber numberWithUnsignedInt:[results count]], [NSNumber numberWithUnsignedInt:1], nil);
	
	TRRetort* control = [[TRRetort alloc] init];
	control.primaryId = [NSNumber numberWithInt:999];
	control.content = @"This is a simple test";
	
	STAssertEqualObjects(control, [results objectAtIndex:0], nil);
	
	[results release];
	[control dealloc];	
	[input dealloc];
}

- (void) testStandardXml
{
	NSData* input = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"StaticScreenzero" ofType:@"xml"]];
	STAssertNil(err, nil);
	[subject parseRetortXML:input parseError:&err];
	STAssertNotNil(err, nil);
	NSMutableArray* results = subject.retorts;
	STAssertNotNil(results, nil);
	STAssertEqualObjects([NSNumber numberWithUnsignedInt:[results count]], [NSNumber numberWithUnsignedInt:5], nil);
	TRRetort* retort = [results objectAtIndex:0];
	STAssertEquals(retort.primaryId, 5, nil);
	[input dealloc];
	
}
@end
