//
//  TRTagFacade.h
//  Retorted
//
//  Created by a on 12/23/08.
//  Copyright 2008 Forward Echo LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRNotificationInterface.h"

@class TRRetortXMLParser;
@class Statistic;			//used for performance testing...
@class PerformanceStats;	//used for performance testing...

extern NSString * const TRTagDataDidFinishedNotification;

@interface TRTagFacade : NSObject <TRNotificationInterface> {
	NSMutableArray *tags;
	BOOL loadSucessful;
	NSDictionary *properties;
	TRRetortXMLParser *xmlParser;
	
@private
	// ---- PERFORMANCE TESTING ----
	Statistic *parseStat;
	Statistic *downloadStat;
	PerformanceStats *statHelper;
}

@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) TRRetortXMLParser *xmlParser;
@property BOOL loadSucessful;

- (void)loadTags;
- (void)handleDataLoadFailure: (NSNotification *)note;
- (void)handleTagXMLLoad: (NSNotification *)note;
- (void)loadTagsMatchingString:(NSString *)searchText;

@end



