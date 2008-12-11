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
}

@property (nonatomic, retain) NSMutableArray *retorts;
- (void)loadRetorts;
@end
