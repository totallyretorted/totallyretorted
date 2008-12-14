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
@synthesize votes;
@synthesize tagCloudValue;
@synthesize primaryKey;

- (id) init {
	return [self initWithId:[NSNumber numberWithInt: -1] Value:@"" Votes:0 TagCloudValue:0];
}

- (id) initWithId:(NSNumber *)aPrimaryKey Value:(NSString *) aValue {
	
	return [self initWithId:primaryKey Value:aValue Votes:0 TagCloudValue:0];
}

//Designated initializer
- (id)initWithId:(NSNumber *)aPrimaryKey Value:(NSString *)aValue Votes:(NSInteger)voteCount TagCloudValue:(NSInteger)cloudValue {
	if (![super init])
		return nil;
	
	self.primaryKey = aPrimaryKey;
	self.value = aValue;
	self.votes = voteCount;
	self.tagCloudValue = cloudValue;
	
	return self;
}

- (id)initWithDictionary:(NSDictionary *)aDictionary {
	if (![super init])
		return nil;
	//NSString *str = [aDictionary objectForKey:@"id"];
	
	
	self.primaryKey = [aDictionary objectForKey:@"id"];
	self.value = [aDictionary objectForKey:@"value"];
	NSNumber *weight = [aDictionary objectForKey:@"votes"];
	
	self.votes = [weight integerValue];
	//self.votes = [(NSNumber)[aDictionary objectForKey:@"votes"] integerValue];
	self.tagCloudValue = 0;
	
	NSLog(@"TRTag: Init tag: %@", self.value);
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@", self.value];
}
 
- (void)dealloc {
	[super dealloc];
}
@end
