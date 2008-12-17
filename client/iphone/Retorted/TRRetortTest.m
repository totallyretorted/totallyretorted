//
//  TRRetortTest.m
//  Retorted
//
//  Created by Adam Strickland on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TRRetortTest.h"


@implementation TRRetortTest
- (void) setUp{
}

- (void) tearDown{
	[subject release];
}

- (void) testInitWIthDictionary
{
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
	subject = [[TRRetort alloc] initWithDictionary:dict];
	
}

- (void) testInitWIthDictionarySparse
{
	
}

- (void) testInitWIthDictionaryBad
{
	subject = [[TRRetort alloc] initWithDictionary:nil];
	STAssertNil(subject, nil);
}
@end
