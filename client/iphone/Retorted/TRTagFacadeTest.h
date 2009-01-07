//
//  TRTagFacadeTest.h
//  Retorted
//
//  Created by a on 12/23/08.
//  Copyright 2008 Forward Echo LLC. All rights reserved.
//

#import "GTMSenTestCase.h"

@class TRTagFacade;

@interface TRTagFacadeTest : SenTestCase {
	TRTagFacade *subject;
}

- (void) testLoadTags;
- (void) testHandleDataLoadFailure;
- (void) testHandleTagXMLLoad;



@end
