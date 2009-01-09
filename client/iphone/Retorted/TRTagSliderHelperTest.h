//
//  TRTagSliderHelperTest.h
//  Retorted
//
//  Created by B.J. Ray on 1/9/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "GTMSenTestCase.h"
@class TRTagSliderHelper;
@class TRTag;

@interface TRTagSliderHelperTest : SenTestCase {
	TRTagSliderHelper *subject;
	NSMutableArray *tags;
}

@property (nonatomic, retain) NSMutableArray *tags;
@end
