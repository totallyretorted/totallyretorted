/*
 *  SortMethods.h
 *  Retorted
 *
 *  Created by Jay Walker on 12/10/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

//#import "TRTag.h"


enum TagSortOrder {
	VoteCountDesc = 0
	, VoteCountAsc
	, AlphaAsc
	, AlphaDesc
} var;


NSInteger tagVoteSortAsc(id tagLeft, id tagRight, void *ignore);
NSInteger tagVoteSortDesc(id tagLeft, id tagRight, void* ignore);
NSInteger tagAlphaSortAsc(id tagLeft, id tagRight, void *reverse);
NSInteger tagAlphaSortDesc(id tagLeft, id tagRight, void* ignore);
