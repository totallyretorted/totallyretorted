//
//  TRRetort.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetort.h"
#import "TRAttribution.h"
#import "TRTag.h"

@implementation TRRetort
@synthesize content;
@synthesize attribution, tags, positive, negative;
@synthesize primaryId;

-(id)init {
	if (![super init])
		return nil;
	
	return self;
}

- (NSArray *)attributionListAsStringArray {
	
	return [self.attribution attributionListAsStringArray];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Retort Id: %@ has %d tags", self.primaryId, [self.tags count]];
}

- (void)dealloc {
	[content release];
	[attribution release];
	[tags release];
	[primaryId release];
	
	[super dealloc];
}


@end
