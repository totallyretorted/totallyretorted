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
	
}

- (void)tearDown {
	self.subject = nil;
}


@end
