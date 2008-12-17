//
//  TRAttributionTest.m
//  Retorted
//
//  Created by Adam Strickland on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TRAttributionTest.h"


@implementation TRAttributionTest

- (void)setUp {
	subject = [[TRAttribution alloc] init];
}

- (void)tearDown {
	[subject release];
}

#pragma mark -
#pragma mark Tests
- (void)testAttributionListAsStringArray {
	subject.who = @"who";
	subject.what = @"what";
	subject.where = @"where";
	subject.when  = @"when";
	subject.how = @"how";
	
	
	NSArray *results = [subject attributionListAsStringArray];
	
	//ensure this is not nil
	STAssertNotNil(results, nil);

	//ensure we have correct count
	STAssertEquals([results count], (unsigned int) 5, nil);
	
	STAssertEquals([results objectAtIndex:0], @"who", nil);
	STAssertEquals([results objectAtIndex:1], @"what", nil);
	STAssertEquals([results objectAtIndex:2], @"when", nil);
	STAssertEquals([results objectAtIndex:3], @"where", nil);
	STAssertEquals([results objectAtIndex:4], @"how", nil);
}

- (void)testAttributionListAsStringArrayPartial {
	subject.what = @"what";
	subject.where = @"where";
	
	NSArray *results = [subject attributionListAsStringArray];
	
	//ensure this is not nil
	STAssertNotNil(results, nil);
	
	//ensure we have correct count
	STAssertEquals([results count], (unsigned int) 2, nil);
	
	STAssertEquals([results objectAtIndex:0], @"what", nil);
	STAssertEquals([results objectAtIndex:1], @"where", nil);
}
@end
