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

- (NSInteger)sortViewByWeightAscendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight {
	int wgtLeft = [tagLeft weight];
    int wgtRight = [tagRight weight];
    NSComparisonResult result;
	if (wgtLeft < wgtRight)
        result = NSOrderedAscending;
    else if (wgtLeft > wgtRight)
        result = NSOrderedDescending;
    else
        result = NSOrderedSame;
	
	return result;
	
}

- (NSInteger)sortViewByWeightDescendingWithLeftTag:(TRTag *)tagLeft rightTag:(TRTag *)tagRight {
	return (-[self sortViewByWeightAscendingWithLeftTag:tagLeft rightTag:tagRight]);
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
