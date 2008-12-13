//
//  JayTest.h
//  Retorted
//
//  Created by Jay Walker on 12/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const TRXMLRetortDataFinishedLoadingNotification;

@class TRRetort;
@class TRTag;
@class TRAttribution;
@class TRRating;

@interface JayTest : NSObject {
	NSMutableArray* retorts;
	TRRetort* currentRetort;
	TRTag* currentTag;
	NSMutableString* currentTextNode;
	
	BOOL canAppend;
}

- (void)parseRetortXML:(NSData *)xmlData parseError:(NSError **)error;

@property (nonatomic, retain) NSMutableArray *retorts;
@property (nonatomic, retain) TRRetort* currentRetort;
@property (nonatomic, retain) TRTag* currentTag;
@property (nonatomic, retain) NSMutableString* currentTextNode;
@property (nonatomic, readwrite) BOOL canAppend;
@end
