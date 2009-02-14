//
//  TRRetortXMLParser.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRRetort;
@class TRTag;
@class TRAttribution;

extern NSString * const TRXMLRetortDataFinishedLoadingNotification;


@interface TRRetortXMLParser : NSObject {
	NSMutableString *currentTextNode;
	NSMutableArray *retorts;
	NSMutableArray *tags;		//hold as independent array when only parsing tags, not retorts
	NSMutableArray *alphaArray;	//holds a list of letters that have tags associated with them.
	NSMutableArray *records;	//Used for top_n_by_alpha xml.  Holds groupings of Tag objects.

	BOOL canAppend;
	BOOL isTagData;
	TRRetort *currentRetort;
	TRTag *currentTag;
	TRAttribution *currentAttribution;
	

}

- (void)parseRetortXML:(NSData *)xmlData parseError:(NSError **)error;


@property (nonatomic, retain) NSMutableString *currentTextNode;
@property (nonatomic, retain) NSMutableArray *retorts;
@property (nonatomic, retain) NSMutableArray *tags;

@property (nonatomic, retain) TRRetort *currentRetort;
@property (nonatomic, retain) TRTag *currentTag;
@property (nonatomic, retain) TRAttribution *currentAttribution;
@property (nonatomic, retain) NSMutableArray *alphaArray;
@property (nonatomic, retain) NSMutableArray *records;

@property BOOL canAppend;
@property BOOL isTagData;
@end
