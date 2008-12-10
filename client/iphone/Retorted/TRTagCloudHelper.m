//
//  TRTagCloudHelper.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRTagCloudHelper.h"
#import "TRTag.h"

const NSInteger quantas = 5;

@implementation TRTagCloudHelper
@synthesize tags;

- (id)initWithTagsArray:(NSArray *)tagArray {
	if (![super init])
		return nil;

	self.tags = tagArray;
	
	return self;
}

- (void)levelCloud {
	
}

- (NSString *)tagCloud {
	NSString *html = nil;
	
	return html;
}

- (void)dealloc {
	[super dealloc];
}


@end
