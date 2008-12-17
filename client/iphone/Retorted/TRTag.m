//
//  TRTag.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRTag.h"
#import "TRRating.h"

@implementation TRTag
@synthesize value;
@synthesize weight;
@synthesize tagCloudValue;
@synthesize primaryId;

- (id) init {
	return [self initWithId:[NSNumber numberWithInt: -1] value:@"" weight:0 tagCloudValue:0];
}

- (id) initWithId:(NSNumber *)aPrimaryId value:(NSString *) aValue {
	
	return [self initWithId:aPrimaryId value:aValue weight:0 tagCloudValue:0];
}

//Designated initializer
- (id)initWithId:(NSNumber *)aPrimaryId value:(NSString *)aValue weight:(NSInteger)voteCount tagCloudValue:(NSInteger)cloudValue {
	if (![super init])
		return nil;
	
	self.primaryId = aPrimaryId;
	self.value = aValue;
	self.weight = voteCount;
	self.tagCloudValue = cloudValue;
	
	return self;
}

*/
- (NSString *)description {
	return [NSString stringWithFormat:@"%@", self.value];
}
 
- (void)dealloc {
	[super dealloc];
}
@end
