//
//  TRRetort.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetort.h"


@implementation TRRetort
@synthesize content;

-(id)init {
	if (![super init])
		return nil;
	
	return self;
}

- (void)dealloc {
	[content release];
	[super dealloc];
}

@end
