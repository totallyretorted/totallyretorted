//
//  TRRetort.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRAttribution;

@interface TRRetort : NSObject {
	NSString *content;
	TRAttribution *attribution;
	NSMutableArray *tags;
	NSNumber *primaryId;
	NSUInteger positive;
	NSUInteger negative;
}

- (NSArray *)attributionListAsStringArray;		//convenience method so classes don't have to know about attribution

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) TRAttribution *attribution;
@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) NSNumber *primaryId;
@property NSUInteger positive;
@property NSUInteger negative;
@end
