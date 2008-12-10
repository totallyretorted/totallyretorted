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
	NSInteger votes;			//used for tagCould...
	NSInteger tagCloudValue;	//used for tagCloud...
	NSInteger primaryKey;
}

- (id) initWithId:(NSInteger)aPrimaryKey Value:(NSString *) aValue;
- (id)initWithId:(NSInteger)aPrimaryKey Value:(NSString *)aValue Votes:(NSInteger)voteCount TagCloudValue:(NSInteger)cloudValue;

@property (nonatomic, retain) NSString *value;
@property NSInteger votes;
@property NSInteger tagCloudValue;
@property NSInteger primaryKey;
@end
