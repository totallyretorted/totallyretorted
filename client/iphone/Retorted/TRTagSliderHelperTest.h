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
	UILabel *label1;
	UIImageView *imgView;
}

@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, retain) UIImageView *imgView;
@end
