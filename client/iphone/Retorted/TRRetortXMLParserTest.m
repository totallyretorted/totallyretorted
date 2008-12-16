//
//  TRRetortXMLParserTest.m
//  Retorted
//
//  Created by Adam Strickland on 12/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TRRetortXMLParserTest.h"




@implementation TRRetortXMLParserTest

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
	NSData* input = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"TRRetortXMLParserTest_testSuperSimpleXML" ofType:@"xml"]];	
	STAssertNil(err, nil);
	[subject parseRetortXML:input parseError:&err];
	//STAssertNil(err, nil);
	NSMutableArray* results = subject.retorts;
	STAssertNotNil(results, nil);
	STAssertEqualObjects([NSNumber numberWithUnsignedInt:[results count]], [NSNumber numberWithUnsignedInt:1], nil);
	TRRetort* retort = [results objectAtIndex:0];	
	STAssertEquals([retort.primaryId intValue], 999, nil);
	STAssertEqualObjects(retort.content, @"This is a simple test", nil);}

- (void) testStandardXml
{
	NSData* input = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"TRRetortXMLParserTest_testStandardXml" ofType:@"xml"]];
	STAssertNil(err, nil);
	[subject parseRetortXML:input parseError:&err];
	//STAssertNotNil(err, nil);
	NSMutableArray* results = subject.retorts;
	STAssertNotNil(results, nil);
	STAssertEqualObjects([NSNumber numberWithUnsignedInt:[results count]], [NSNumber numberWithUnsignedInt:5], nil);
	TRRetort* retort = [results objectAtIndex:0];
	STAssertEquals([retort.primaryId intValue], 5, nil); 
}
@end
