//
//  TRAttribution.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRAttribution.h"


@implementation TRAttribution
@synthesize who, what, when, where, how;
@synthesize retortId;


- (id)init {
	if (![super init])
		return nil;
	
	
	return self;
}

- (void)dealloc {
	[who release];
	[what release];
	[when release];
	[where release];
	[how release];
	[retortId release];
	
	[super dealloc];
}
@end
