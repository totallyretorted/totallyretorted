//
//  TRVoteCastingHelper.h
//  Retorted
//
//  Created by B.J. Ray on 1/29/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TRRetortVoteCastAsSucks  = -1,
    TRRetortVoteCastAsRocks   = 1,
} TRRetortVoteCast;

@interface TRVoteCastingHelper : NSObject {
	NSUInteger retortId;
	
}
@property NSUInteger retortId;

- (BOOL)castVote:(TRRetortVoteCast)voteCasted;

@end
