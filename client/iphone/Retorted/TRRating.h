//
//  TRRating.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TRRating : NSObject {
	NSNumber *positive;
	NSNumber *negative;
}

@property (nonatomic, retain) NSNumber *positive;
@property (nonatomic, retain) NSNumber *negative;

@end
