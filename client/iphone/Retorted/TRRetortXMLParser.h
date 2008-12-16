//
//  TRRetortXMLParser.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRRating;
@class TRRetort;
@class TRTag;
@class TRAttribution;

extern NSString * const TRXMLRetortDataFinishedLoadingNotification;


@interface TRRetortXMLParser : NSObject {
	//NSMutableDictionary *currentRetort;
	//NSMutableDictionary *currentTag;
	//NSMutableDictionary *currentRating;
	//NSMutableDictionary *currentAttribution;
	//NSMutableArray *tags;
	
	NSMutableString *currentTextNode;
	NSMutableArray *retorts;

	BOOL canAppend;
	
	TRRetort *currentRetort;
	TRTag *currentTag;
	TRRating *currentRating;
	TRAttribution *currentAttribution;
	

}

- (void)parseRetortXML:(NSData *)xmlData parseError:(NSError **)error;


@property (nonatomic, retain) NSMutableString *currentTextNode;
@property (nonatomic, retain) NSMutableArray *retorts;

//@property (nonatomic, retain) NSMutableDictionary *currentRetort;
//@property (nonatomic, retain) NSMutableDictionary *currentTag;
//@property (nonatomic, retain) NSMutableDictionary *currentRating;
//@property (nonatomic, retain) NSMutableArray *tags;
//@property (nonatomic, retain) NSMutableDictionary *currentAttribution;

@property (nonatomic, retain) TRRetort *currentRetort;
@property (nonatomic, retain) TRTag *currentTag;
@property (nonatomic, retain) TRRating *currentRating;
@property (nonatomic, retain) TRAttribution *currentAttribution;


@property (nonatomic, readwrite) BOOL canAppend;
@end
