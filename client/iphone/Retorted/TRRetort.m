//
//  TRRetort.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetort.h"
#import "TRAttribution.h"
#import "TRRating.h"
#import "TRTag.h"

@implementation TRRetort
@synthesize content;
@synthesize attribution, tags, rating;

-(id)init {
	if (![super init])
		return nil;
	
	return self;
}

- (void)dealloc {
	[content release];
	[attribution release];
	[tags release];
	[rating release];
	[super dealloc];
}


@end
