//
//  TRAttribution.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TRAttribution : NSObject {
	NSString *who;
	NSString *what;
	NSString *when;
	NSString *where;
	NSString *how;
	NSInteger retortId;
}

@property(nonatomic, retain) NSString *who;
@property(nonatomic, retain) NSString *what;
@property(nonatomic, retain) NSString *when;
@property(nonatomic, retain) NSString *where;
@property(nonatomic, retain) NSString *how;
@property NSInteger retortId;

@end
