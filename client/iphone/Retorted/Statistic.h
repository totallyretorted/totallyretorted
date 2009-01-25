//
//  Statistic.h
//  Retorted
//
//  Created by B.J. Ray on 1/24/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Statistic : NSObject {
	NSTimeInterval start;
	NSTimeInterval end;
	NSString *url;
	NSUInteger byteCount;
}

@property NSTimeInterval start;
@property NSTimeInterval end;
@property NSUInteger byteCount;
@property (nonatomic, retain) NSString *url;

- (double)duration;
@end
