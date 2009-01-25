//
//  RetortByTagListVCTest.h
//  Retorted
//
//  Created by B.J. Ray on 1/23/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "GTMSenTestCase.h"
@class RetortByTagListViewController;
@class TRTag;

@interface RetortByTagListVCTest : SenTestCase {
	RetortByTagListViewController *subject;
	TRTag *tag1;
	TRTag *tag2;
}

@property (nonatomic, retain) TRTag *tag1;
@property (nonatomic, retain) TRTag *tag2;



@end
