//
//  TRRetortXMLParser.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRRating;

extern NSString * const TRXMLRetortDataFinishedLoadingNotification;


@interface TRRetortXMLParser : NSObject {
	NSMutableString *currentProperty;
	NSMutableDictionary *currentRetort;
	NSMutableDictionary *currentTag;
	TRRating *currentRating;
	//NSMutableDictionary *currentRating;
	NSMutableDictionary *currentAttribution;
	
	NSMutableArray *retorts;
	NSMutableArray *tags;
	
	BOOL canAppend;
}

- (void)parseRetortXML:(NSData *)xmlData parseError:(NSError **)error;


@property (nonatomic, retain) NSMutableString *currentProperty;

@property (nonatomic, retain) NSMutableArray *retorts;

@property (nonatomic, retain) NSMutableDictionary *currentRetort;
@property (nonatomic, retain) NSMutableDictionary *currentTag;
//@property (nonatomic, retain) NSMutableDictionary *currentRating;
@property (nonatomic, retain) TRRating *currentRating;
@property (nonatomic, retain) NSMutableDictionary *currentAttribution;
@property (nonatomic, retain) NSMutableArray *tags;

@property (nonatomic, readwrite) BOOL canAppend;
@end
