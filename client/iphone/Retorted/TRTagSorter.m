//
//  TRTagSorter.m
//  Retorted
//
//  Created by B.J. Ray on 12/10/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRTagSorter.h"
#import "TRTag.h"

@implementation TRTagSorter

- (NSInteger)sortViewByVoteAscendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight {
	int vl = [tagLeft votes];
    int vr = [tagRight votes];
    NSComparisonResult result;
	if (vl < vr)
        result = NSOrderedAscending;
    else if (vl > vr)
        result = NSOrderedDescending;
    else
        result = NSOrderedSame;
	
	return result;
	
}

- (NSInteger)sortViewByVoteDescendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight {
	return (-[self sortViewByVoteAscendingWithLeftTag:tagLeft rightTag:tagRight]);
}

- (NSInteger)sortViewByAlphaAscendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight {
	NSComparisonResult result;
	NSString* tl = [tagLeft value];
	NSString* tr = [tagRight value];
	result = [tl localizedCaseInsensitiveCompare:tr];
	
	return result;
}

- (NSInteger)sortViewByAlphaDescendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight {
	return (-[self sortViewByAlphaAscendingWithLeftTag:tagLeft rightTag:tagRight]);
}

@end
