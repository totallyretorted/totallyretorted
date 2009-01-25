//
//  RetortByTagListVCTest.m
//  Retorted
//
//  Created by B.J. Ray on 1/23/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "RetortByTagListVCTest.h"
#import "RetortByTagListViewController.h"
#import "RetortCellView.h"

#import "TRTag.h"
#import "TRRetort.h"
#import "TRRating.h"

@implementation RetortByTagListVCTest
@synthesize tag1, tag2;

-(void) setUp{
	//subject = [[RetortByTagListViewController alloc] initWithNibName:@"RetortByTagView" bundle:nil];
	
	//self.tag1 = [[TRTag alloc] initWithId:1 value:@"Tag 1" weight:1 tagCloudValue:1];
	//self.tag2 = [[TRTag alloc] initWithId:2 value:@"Tag 2" weight:2 tagCloudValue:2];
	
}

-(void) tearDown{
	[subject release];
}

#pragma mark -
#pragma mark Tests
- (void)testRetortInTableViewCount {
//	//data setup
//	TRRetort *retort1 = [[TRRetort alloc] init];
//	TRRetort *retort2 = [[TRRetort alloc] init];
//	retort1.content = @"This is the first retort";
//	retort1.primaryId = [NSNumber numberWithInt:1];
//	retort1.tags = [self getSingleTagArray];
//	
//	retort2.content = @"This is the second retort";
//	retort2.primaryId = [NSNumber numberWithInt:1];
//	retort2.tags = [self getSingleTagArray];
//	
//	RetortCellView *retortCell = nil;
//	NSUInteger retortCount = 0;
//	[subject.retortsView reload];
//	retortCount = [subject.retortsView numberOfRowsInSection:0];
//	
//	STAssertEquals(retortCount, (NSUInteger)2, nil);
//	
//	//retortCell = [subject tableView:tableView cellForRowAtIndexPath:indexPath];
//	
//	
//	
//	retort1.attribution = nil;
//	retort1.rating = [[TRRating alloc] initWithPositive:1 negative:0 rank:1.0];
}

- (void)testZeroRetortCount {
	
}

- (void)testSingleTagHeader {
	
}

- (void)testMultipleTagHeader {
	
}

#pragma mark -
#pragma mark Helper Methods
- (NSArray *)getSingleTagArray {
	return [[NSArray alloc] initWithObjects:self.tag1, nil];
}

- (NSArray *)getMultipleTagArray {
	return [[NSArray alloc] initWithObjects:self.tag1, self.tag2, nil];
}

@end
