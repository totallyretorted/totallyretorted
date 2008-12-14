//
//  TRRating.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TRRating : NSObject {
	/*
	NSNumber *positive;
	NSNumber *negative;
	NSNumber *rank;
	 */
	NSInteger positive;
	NSInteger negative;
	float rank;
}

//- (id)initWithPositive:(NSNumber *)posValue negative:(NSNumber *)negValue rank:(NSNumber *)rankValue;
- (id)initWithPositive:(NSInteger)posValue negative:(NSInteger)negValue rank:(float)rankValue;


@property NSInteger positive;
@property NSInteger negative;
@property float rank;

/*
@property (nonatomic, retain) NSNumber *positive;
@property (nonatomic, retain) NSNumber *negative;
@property (nonatomic, retain) NSNumber *rank;
 */
@end
