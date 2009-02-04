//
//  TRTagSliderHelperTest.m
//  Retorted
//
//  Created by B.J. Ray on 1/9/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRTagSliderHelperTest.h"
#import "TRTagSliderHelper.h"
#import "TRTag.h"
#import "TRTagButton.h"

@implementation TRTagSliderHelperTest
//@synthesize tags;
@synthesize label1, imgView, btn1;

-(void) setUp{
	//self.tags = [[NSMutableArray alloc] init];
	NSMutableArray *tags = [[NSMutableArray alloc] init];
	subject = [[TRTagSliderHelper alloc] initWithTagArray:tags];
	[tags release];
	
	self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 40.0, 30.0)];
	self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(70.0, 20.0, 60.0, 10.0)];
	self.btn1 = [[TRTagButton alloc] initWithFrame:CGRectMake(200.0, 20.0, 40.0, 30.0)];
	
}

-(void) tearDown{
	//self.tags = nil;
	self.label1 = nil;
	self.imgView= nil;
	self.btn1 = nil;
	[subject release];
}

#pragma mark -
#pragma mark Unit Tests
- (void) testSubViewRemovalWithSingleLabel {
	UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 80.0)];
	
	//TEST 1: Check for zero subviews
	STAssertEquals([[aScrollView subviews] count], (NSUInteger)0, nil);
	
	//TEST 2: Add two subviews and validate
	[aScrollView addSubview:self.label1];
	[aScrollView addSubview:self.imgView];
	STAssertEquals([[aScrollView subviews] count], (NSUInteger)2, nil);
	

	//TEST 3: Remove labels and verify that there is only one subview left.
	//PRIVATE METHOD - IGNORE WARNING
	[subject removeOldLabelSubViewsFromScrollView:aScrollView];
	STAssertEquals([[aScrollView subviews] count], (NSUInteger)1, nil);
	
	//TEST 4: Verify that imageview is still there...
	STAssertEquals([[[aScrollView subviews] objectAtIndex:0] isMemberOfClass:[UIImageView class]], YES, nil);
	
	[aScrollView release];
}

- (void) testSubViewRemovalWithSingleButton {
	UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 80.0)];
	
	//TEST 1: Check for zero subviews
	STAssertEquals([[aScrollView subviews] count], (NSUInteger)0, nil);
	
	//TEST 2: Add two subviews and validate
	[aScrollView addSubview:self.label1];
	[aScrollView addSubview:self.btn1];
	STAssertEquals([[aScrollView subviews] count], (NSUInteger)2, nil);
	
	//TEST 3: Remove labels and verify that there is only one subview left.
	//PRIVATE METHOD - IGNORE WARNING
	[subject removeOldButtonSubViewsFromScrollView:aScrollView];
	STAssertEquals([[aScrollView subviews] count], (NSUInteger)1, nil);
	
	//TEST 4: Verify that imageview is still there...
	STAssertEquals([[[aScrollView subviews] objectAtIndex:0] isMemberOfClass:[UILabel class]], YES, nil);
	
	[aScrollView release];
}

- (void)testTagRenderAsLabel {
	//NSArray *tags = [[NSArray alloc] initWithObjects:[self getShortNameTag], nil];
	//PRIVATE METHOD - IGNORE WARNING
	UILabel *testLabel = nil;
	CGFloat x = 20.0;
	CGFloat y = 20.0;
	testLabel = [subject getLabelFromTag:[self getShortNameTag] 
									 atX:x 
									   y:y];

	//TEST 1: Verify that a UILabel object is returned
	STAssertEquals([testLabel isMemberOfClass:[UILabel class]], YES, nil);
	
	//TEST 2: Verify that the UILabel has the correct attributes
	STAssertEquals(testLabel.textColor == [UIColor blackColor], 1, nil);		//not sure why YES doesn't work here
	STAssertEquals(subject.backgroundColor == [UIColor clearColor], 1, nil);
	
	//NOT SURE WHY TEST DOESN'T WORK - THE RESULT IS A COLOR THAT MATCHES THE subject.backgroundColor
	//JLog(@"subject.backgroundColor: %@", subject.backgroundColor);
	//JLog(@"testLabel.backgroundColor: %@", testLabel.backgroundColor);
	//STAssertEquals(testLabel.backgroundColor == [UIColor whiteColor], 1, nil);
	STAssertEquals([testLabel frame].origin.x == 20.0, 1, nil);
	STAssertEquals([testLabel frame].origin.y == 20.0, 1, nil);
	STAssertEquals(testLabel.text == @"Bush", 1, nil);
	
}

- (void)testTagsRenderAsTRTagButtons {
	TRTagButton *testButton = nil;
	
	testButton = [subject getButtonFromTag:[self getShortNameTag] 
									 atX:20.0 
									   y:20.0];
	
	//TEST 1: Verify that a TRTagButton object is returned
	STAssertEquals([testButton isMemberOfClass:[TRTagButton class]], YES, nil);
	
	//TEST 2: Verify that the TRTagButton has the correct attributes
	STAssertEquals([testButton frame].origin.x == 20.0, 1, nil);
	STAssertEquals([testButton frame].origin.y == 20.0, 1, nil);
	STAssertEquals(testButton.currentTitle == @"Bush", 1, nil);
	STAssertEquals(testButton.currentTitleColor == [UIColor blackColor], 1, nil);
	STAssertEquals(testButton.tagId == [self getShortNameTag].primaryId, 1, nil);
	
	//TEST 3: Verify that the TRTagButton has no target
	NSSet *targets = [testButton allTargets];
	STAssertEquals([targets count] == 0, 1, nil);
}

- (void)testTagsRenderAsTRTagButtonsHaveTarget {
	TRTagButton *testButton = nil;
	[subject controlTypeAsButtonWithTarget:self selector:@selector(getLongNameTag)];
	
	testButton = [subject getButtonFromTag:[self getShortNameTag] 
									   atX:20.0 
										 y:20.0];
	
	//TEST 1: Test setting of target
	NSSet *targets = [testButton allTargets];
	STAssertEquals([targets count] == 1, 1, nil);
	
	//TEST 2: Test that target is self
	STAssertEquals([[targets anyObject] isEqual:self], YES, nil);
	
	//TEST 3: Test actions as a result of setting Targets of button.
	NSArray *actions = [testButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
	STAssertEquals([actions count] == 1, 1, nil);
	STAssertEquals([[actions objectAtIndex:0] isEqual: @"getLongNameTag"], YES, nil);
	
}



- (void) testSingleTagPlacementAsButton {
	//TODO: Write this test
	
	//TRTag *aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:1] value:@"Test" weight:2 tagCloudValue:0];
	//self.tags
}

- (void) testSingleTagPlacementAsLabel {
	//TODO: Write this test
	
	//TRTag *aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:1] value:@"Test" weight:2 tagCloudValue:0];
	//self.tags
}

- (void)testGetOffsetFoTagsForScrollViewWidth {
	// TODO: Write this test
}
 

#pragma mark -
#pragma mark Helper Methods
//Helper methods
- (TRTag *)getShortNameTag {
	TRTag *aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:1] 
									  value:@"Bush" 
									 weight:(NSInteger)2 
							  tagCloudValue:(NSInteger)4];
	[aTag autorelease];
	return aTag;
}

- (TRTag *)getLongNameTag {
	TRTag *aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:1] 
									  value:@"BushWasPresidentFromJanuary2001toJanuary2009" 
									 weight:(NSInteger)2 
							  tagCloudValue:(NSInteger)4];
	[aTag autorelease];
	return aTag;
}

- (NSArray *)getThreeTagObjects {
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
	
	TRTag *aTag = nil;
	aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:2] 
									  value:@"Power2" 
									 weight:(NSInteger)2 
							  tagCloudValue:(NSInteger)4];
	[array addObject:aTag];
	[aTag release];
	
	aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:3] 
							   value:@"Power3" 
							  weight:(NSInteger)3 
					   tagCloudValue:(NSInteger)9];
	[array addObject:aTag];
	[aTag release];
	
	aTag = [[TRTag alloc] initWithId:[NSNumber numberWithInt:1] 
							   value:@"Power4" 
							  weight:(NSInteger)4 
					   tagCloudValue:(NSInteger)16];
	[array addObject:aTag];
	[aTag release];
	
	return array;
}

- (NSString *)description {
	return @"TRTagSliderHelperTest";
}

@end
