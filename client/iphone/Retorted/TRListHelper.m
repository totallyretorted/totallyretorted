//
//  TRListHelper.m
//  Retorted
//
//  Created by B.J. Ray on 2/13/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRListHelper.h"


@implementation TRListHelper

- (void)appendNewArray:(NSMutableArray *)newArr toBaseArray:(NSMutableArray *)baseArr inDirection:(TRPageMoveDirection)moveDirection {
	if (moveDirection == TRPageMoveDirectionForward) {
		[baseArr addObjectsFromArray:newArr];
		//do objects need to be removed?
	} else {
		
	}

}


- (void)removeObjectsFromArray:(NSMutableArray *)arr atStartLocation:(NSUInteger)loc {
	NSRange range = NSMakeRange(loc, kPageSize);
	
	//- (void)removeObjectsInRange:(NSRange)aRange
}
@end
