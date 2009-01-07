//
//  TRViewHelper.m
//  Retorted
//
//  Created by B.J. Ray on 12/16/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRViewHelper.h"

@implementation TRViewHelper
+ (float)calculateHeightOfText:(NSString *)text withFont:(UIFont *)aFont width:(float)aWidth lineBreakMode:(UILineBreakMode)lineBreak {
	[text retain];
	[aFont retain];
	CGSize suggestedSize = [text sizeWithFont:aFont constrainedToSize:CGSizeMake(aWidth, FLT_MAX) lineBreakMode:lineBreak];
	
	[text release];
	[aFont release];
	
	return suggestedSize.height;
}
@end
