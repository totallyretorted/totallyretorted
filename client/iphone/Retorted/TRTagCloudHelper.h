//
//  TRTagCloudHelper.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TRTagCloudHelper : NSObject {
	NSArray *tags;
	NSInteger max;
	NSInteger min;
}
- (NSString *)tagCloud;

@property (nonatomic, retain) NSArray *tags;
@end
