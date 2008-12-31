//
//  FEUrlHelperTest.h
//  Retorted
//
//  Created by Adam Strickland on 12/17/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "FEUrlHelper.h"


@interface FEUrlHelperTest : SenTestCase {
	FEUrlHelper* subject;
	NSNotificationCenter *nc;
}
- (void) testLoadURLFromString;
//- (void) completeTestLoadURLFromString:(NSNotification*) note;
- (void) completeLoadURLFromString:(NSNotification*) note;

@end
