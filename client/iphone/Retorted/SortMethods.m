//
//  SortMethods.m
//  Retorted
//
//  Created by Jay Walker on 12/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//These are general methods and are not part of a class.

#import "SortMethods.h"
#import "TRTag.h"


NSInteger tagVoteSortAsc(id tagLeft, id tagRight, void *ignore) {
	
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
	return -tagVoteSortAsc(tagLeft, tagRight, ignore);
}



NSInteger tagAlphaSortAsc(id tagLeft, id tagRight, void *reverse) {	
	NSComparisonResult result;
	NSString* tl = [tagLeft value];
	NSString* tr = [tagRight value];
	result = [tl localizedCaseInsensitiveCompare:tr];
	
	return result;
}


NSInteger tagAlphaSortDesc(id tagLeft, id tagRight, void* ignore)
{
	return -tagAlphaSortAsc(tagLeft, tagRight, ignore);
}
