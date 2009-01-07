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

- (void) testParseSuperSimpleXml
{
	NSLog(@"Running testParseSuperSimpleXml test");
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

- (void) testParseStandardXml
{
	NSLog(@"Running testParseStandardXml test");
	NSData* input = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"TRRetortXMLParserTest_testStandardXml" ofType:@"xml"]];
	STAssertNil(err, nil);
	[subject parseRetortXML:input parseError:&err];
	//STAssertNotNil(err, nil);
	NSMutableArray* results = subject.retorts;
	STAssertNotNil(results, nil);
	STAssertEqualObjects([NSNumber numberWithUnsignedInt:[results count]], [NSNumber numberWithUnsignedInt:5], nil);
	TRRetort* retort = [results objectAtIndex:0];
	STAssertEquals([retort.primaryId intValue], 5, nil); 
	STAssertEqualObjects(retort.content, @"Hippies.They're everywhere. They wanna save the earth, but all they do is smoke pot and smell bad.", nil);

	STAssertEqualObjects(retort.attribution.who, @"Eric Cartman", nil);
	STAssertEqualObjects(retort.attribution.where, @"South Park", nil);

	STAssertEquals(retort.rating.positive, 3022, nil);
	STAssertEquals(retort.rating.negative, 3282, nil);
	float rank = (3022.0 / (3022.0 + 3282.0));
	STAssertEquals(retort.rating.rank, rank, @"Expected %f, found %f", rank, retort.rating.rank);
	
	NSMutableArray* tags = retort.tags;
	STAssertNotNil(tags, nil);
	STAssertEquals([tags count], (unsigned int) 2, nil);
	TRTag* tag = [tags objectAtIndex:0];
	STAssertEquals([tag.primaryId intValue], 1, nil);
	STAssertEquals(tag.weight, 6, nil);
	STAssertEqualObjects(tag.value, @"south_park", nil);
}

- (void) testTagOnlyXml
{
	
}
@end
