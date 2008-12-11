//
//  SortMethods.m
//  Retorted
//
//  Created by Jay Walker on 12/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//These are general methods and do not belong to a class.

#import "TRTag.h"

NSInteger tagVoteSort(id tagLeft, id tagRight, void *ignore) {
	//
	
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


NSInteger tagVoteSortDesc(id tagLeft, id tagRight, void* ignore)
{
	return -tagVoteSort(tagLeft, tagRight, ignore);
}
