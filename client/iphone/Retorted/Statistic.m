//
//  Statistic.m
//  Retorted
//
//  Created by B.J. Ray on 1/24/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "Statistic.h"


@implementation Statistic
@synthesize start, end, byteCount, url;
- (id)init {
	if (![super init]) {
		return nil;
	}
	
	self.start = 0.0;
	self.end = 0.0;
	self.byteCount = 0;
	self.url = nil;
	
	return self;
}

- (double)duration {
	return end - start;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"started at %f, ended at %f, for a total of %f", self.start, self.end, [self duration]];
}

- (void)dealloc {
	self.url = nil;
	[super dealloc];
}
@end
