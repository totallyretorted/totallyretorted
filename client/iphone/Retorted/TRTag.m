//
//  TRTag.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRTag.h"


@implementation TRTag
@synthesize value;
@synthesize votes;
@synthesize tagCloudValue;


- (id) init {
	if (![super init])
		return nil;
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}
@end
