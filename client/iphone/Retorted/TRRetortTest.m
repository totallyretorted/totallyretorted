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
	subject = [[TRRetort alloc] init];
}

- (void) tearDown{
	[subject release];
}
@end
