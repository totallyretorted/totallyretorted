//
//  TRTagSorter.h
//  Retorted
//
//  Created by B.J. Ray on 12/10/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRTag;


typedef enum  {
	VoteCountDesc = 0
	, VoteCountAsc
	, AlphaAsc
	, AlphaDesc
} TagSortOrder;

@interface TRTagSorter : NSObject {

}

- (NSInteger)sortViewByVoteAscendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight;
- (NSInteger)sortViewByVoteDescendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight;


- (NSInteger)sortViewByAlphaAscendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight;
- (NSInteger)sortViewByAlphaDescendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight;


@end
