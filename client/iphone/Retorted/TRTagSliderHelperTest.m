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
@synthesize label1, imgView;

-(void) setUp{
	self.tags = [[NSMutableArray alloc] init];
	subject = [[TRTagSliderHelper alloc] initWithTagArray:self.tags];
	
	self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 40.0, 40.0)];
	self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(40.0, 40.0, 60.0, 10.0)];
	
}

-(void) tearDown{
	[subject release];
}


- (void) testSubViewRemovalWithSingleLabel {
	UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 80.0)];
	NSUInteger answer = 1;
	[aScrollView addSubview:self.label1];
	[aScrollView addSubview:self.imgView];
	STAssertEquals([[aScrollView subviews] count], (NSUInteger)2, nil);
	
	NSLog(@"subView Counts: %d", [[aScrollView subviews] count]);
	[subject removeOldSubViewsFromScrollView:aScrollView];
	
	STAssertEquals([[aScrollView subviews] count], answer, nil);
	
	//TODO: Test that the imageview is still there...
	
	NSLog(@"subView Counts: %d", [[aScrollView subviews] count]);
}



- (void) testSingleTagPlacement {
	//TRTag *aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:1] value:@"Test" weight:2 tagCloudValue:0];
	//self.tags
}

@end
