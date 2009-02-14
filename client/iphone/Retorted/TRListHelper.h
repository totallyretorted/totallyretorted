//
//  TRListHelper.h
//  Retorted
//
//	Assists with managing Retort and Tag lists as the user requests more objects beyond the page size.
//
//  Created by B.J. Ray on 2/13/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NSUInteger const kMaxPageGroupSize = 4;		//controls the max page sets that are added to object array
NSUInteger const kPageSize = 25;

typedef enum {
    TRPageMoveDirectionForward  = -1,
    TRPageMoveDirectionBackwards   = 1,
} TRPageMoveDirection;


@interface TRListHelper : NSObject {
	//Handles paging through retorts / tags.
	NSUInteger currentPage;				//the current page based on latest request.
	NSUInteger totalPageCount;			//maxes out at either kMaxPageGroupSize
	
	// The page number whose objects are in object array where object array is Retorts or Tags
	NSUInteger highestPage;				//the highest number page 
	NSUInteger lowestPage;				//the lowest number page
	TRPageMoveDirection direction;		//the direction of the last page request
	
}

//Accepted params:
//	existing dataset
//	new dataset
//	direction
- (void)appendNewArray:(NSMutableArray *)newArr toBaseArray:(NSMutableArray *)baseArr inDirection:(TRPageMoveDirection)moveDirection;



@end
