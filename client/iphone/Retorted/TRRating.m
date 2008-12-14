//
//  TRRating.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRating.h"


@implementation TRRating
@synthesize positive, negative, rank;

- (id) init {
	return [self initWithPositive:0 negative:0 rank:0.0];
}



//- (id)initWithPositive:(NSNumber *)posValue negative:(NSNumber *)negValue rank:(NSNumber *)rankValue {
- (id)initWithPositive:(NSInteger)posValue negative:(NSInteger)negValue rank:(float)rankValue {
	if (![super init])
		return nil;
	
	self.positive = posValue;
	self.negative = negValue;
	self.rank = rankValue;
	
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"TRRating: Positive:%d  Negative:%d  Rank:%f", self.positive, self.negative, self.rank];
}

- (void)dealloc {
	
	[super dealloc];
}
@end
