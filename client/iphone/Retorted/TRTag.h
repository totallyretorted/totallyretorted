//
//  TRTag.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TRTag : NSObject {
	NSString *value;
	NSInteger weight;			//used for tagCould...
	NSInteger tagCloudValue;	//used for tagCloud...
	NSNumber *primaryId;
}

- (id)initWithId:(NSNumber *)aPrimaryKey value:(NSString *)aValue;
- (id)initWithId:(NSNumber *)aPrimaryKey value:(NSString *)aValue weight:(NSInteger)wgt tagCloudValue:(NSInteger)cloudValue;
- (CGSize)sizeOfNonWrappingTagWithFont:(UIFont *)font;

@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSNumber *primaryId;

@property NSInteger weight;
@property NSInteger tagCloudValue;
@end
