//
//  TRVote.h
//  Retorted
//
//  Created by B.J. Ray on 1/29/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//
//	XML structure...
//	<vote>			// id=?  if updating
//		<value>1</value>  		// 1 or -1
//		<retort id="123"/>
//		<user>
//			<login>shant.donabedian</login>
//		</user>
//	</vote>

#import <Foundation/Foundation.h>
@class TRUser;

typedef enum {
    TRVoteValueNegative = -1,
	TRVoteValueNoVote = 0,
	TRVoteValuePositive = 1,
} TRVoteValue;

@interface TRVote : NSObject {
	NSInteger voteId;
	NSInteger retortId;
	TRUser *user;
	TRVoteValue value;
}

- (id)initWithUser:(TRUser *)user voteId:(NSInteger)vID retortId:(NSInteger)rID vote:(TRVoteValue)aVote;

@property TRVoteValue value;
@property NSInteger voteId;
@property NSInteger retortId;
@property (nonatomic, retain) TRUser *user;

@end
