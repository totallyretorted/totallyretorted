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
@synthesize primaryKey;

- (id) init {
	return [self initWithId:-1 Value:@"" Votes:0 TagCloudValue:0];
}

- (id) initWithId:(NSInteger)aPrimaryKey Value:(NSString *) aValue {
	
	return [self initWithId:primaryKey Value:aValue Votes:0 TagCloudValue:0];
}

//Designated initializer
- (id)initWithId:(NSInteger)aPrimaryKey Value:(NSString *)aValue Votes:(NSInteger)voteCount TagCloudValue:(NSInteger)cloudValue {
	if (![super init])
		return nil;
	
	self.primaryKey = aPrimaryKey;
	self.value = aValue;
	self.votes = voteCount;
	self.tagCloudValue = cloudValue;
	
	return self;
}

 
- (void)dealloc {
	[super dealloc];
}
@end
