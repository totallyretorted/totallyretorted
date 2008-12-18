//
//  TRRetortFacade.h
//  Retorted
//
//  Created by B.J. Ray on 12/11/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TRRetortDataFinishedLoadingNotification;


@interface TRRetortFacade : NSObject {
	NSMutableArray *retorts;	
	NSDictionary *properties;
	BOOL loadSuccessful;
}

@property (nonatomic, retain) NSMutableArray *retorts;
@property BOOL loadSuccessful;

- (void)loadRetorts;
- (void)handleDataLoadFailure: (NSNotification *)note;
- (void)handleRetortXMLLoad: (NSNotification *)note;
- (void)handleRetortObjectsLoad: (NSNotification *)note;
@end
