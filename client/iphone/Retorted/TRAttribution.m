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

- (NSArray *)attributionListAsStringArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	if ([self.who length] > 0) {
		[array addObject:self.who];
	}
	
	if ([self.what length] > 0) {
		[array addObject:self.what];
	}
	if ([self.when length] > 0) {
		[array addObject:self.when];
	}
	if ([self.where length] > 0) {
		[array addObject:self.where];
	}
	if ([self.how length] > 0) {
		[array addObject:self.how];
	}
	
	[array autorelease];
	return array;
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
