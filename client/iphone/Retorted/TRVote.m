//
//  TRVote.m
//  Retorted
//
//  Created by B.J. Ray on 1/29/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRVote.h"
#import "TRUser.h"

@implementation TRVote
@synthesize value, voteId, user, retortId;

- (id)init {
	if (![super init]) {
		return nil;
	}

	return [self initWithUser:nil voteId:-1 retortId:-1 vote:TRVoteValueNoVote];
}

- (id)initWithUser:(TRUser *)aUser voteId:(NSInteger)vID retortId:(NSInteger)rID vote:(TRVoteValue)aVote {
	if (![super init]) {
		return nil;
	}
	
	self.value = aVote;
	self.voteId = vID;
	self.retortId = rID;
	self.user = aUser;
	
	return self;
}

- (void)dealloc {
	self.user = nil;
	[super dealloc];
}
@end
