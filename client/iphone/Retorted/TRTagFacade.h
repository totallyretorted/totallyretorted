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

extern NSString * const TRTagDataDidFinishedNotification;

@interface TRTagFacade : NSObject <TRNotificationInterface> {
	NSMutableArray *tags;
	BOOL loadSucessful;
	NSDictionary *properties;
	TRRetortXMLParser *xmlParser;
}

@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) TRRetortXMLParser *xmlParser;
@property BOOL loadSucessful;

- (void)loadTags;
- (void)handleDataLoadFailure: (NSNotification *)note;
- (void)handleTagXMLLoad: (NSNotification *)note;
//- (void)handleTagObjectsLoad: (NSNotification *)note;


@end



