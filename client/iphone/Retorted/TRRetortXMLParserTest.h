//
//  TRRetortXMLParserTest.h
//  Retorted
//
//  Created by Adam Strickland on 12/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "TRRetortXMLParser.h"
#import "TRRetort.h"
#import "TRTag.h"
#import "TRRating.h"
#import "TRAttribution.h"

@interface TRRetortXMLParserTest : SenTestCase {
@private TRRetortXMLParser*	subject;
@private NSError *err;
}

- (void) testParseSuperSimpleXml;
- (void) testParseStandardXml;

@end
