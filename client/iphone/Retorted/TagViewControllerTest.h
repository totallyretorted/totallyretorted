//
//  TagViewControllerTest.h
//  Retorted
//
//  Created by B.J. Ray on 1/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "GTMSenTestCase.h"


@interface TagViewControllerTest : SenTestCase {
	TagViewController* subject;
}
-(void) testLoadURL;
-(void) testHandleDataLoad;

@end
