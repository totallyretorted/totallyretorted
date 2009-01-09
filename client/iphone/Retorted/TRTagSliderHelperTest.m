//
//  TRTagSliderHelperTest.m
//  Retorted
//
//  Created by B.J. Ray on 1/9/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRTagSliderHelperTest.h"
#import "TRTagSliderHelper.h"
#import "TRTag.h"
#import <UIKit/UIKit.h>

@implementation TRTagSliderHelperTest
@synthesize tags;

-(void) setUp{
	self.tags = [[NSMutableArray alloc] init];
	subject = [[TRTagSliderHelper alloc] init];
}

-(void) tearDown{
	[subject release];
}


- (void) testSubViewRemoval {
	
}

- (void) testSingleTagPlacement {
	TRTag *aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:1] value:@"Test" weight:2 tagCloudValue:0];
	
}

@end
