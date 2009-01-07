//
//  TRTagSliderHelper.m
//  Retorted
//
//  Created by B.J. Ray on 1/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRTagSliderHelper.h"


@implementation TRTagSliderHelper
@synthesize tagArray, fontColor, backgroundColor;
@synthesize fontSize, horizontalSpacer, scrollerHeight;
@synthesize origin;

- (id)init {
	[self dealloc];
	@throw [NSException exceptionWithName:@"TRBadInitCall" 
								   reason:@"A Tag array must be passed.  Use initWithTagArray" 
								 userInfo:nil];
	return nil;
}

- (id)initWithTagArray:(NSArray *)tags {
	if(![super init]){
		return nil;
	}
	
	self.tagArray = tags;
	self.origin = NSMakePoint(20.0, 20.0);
	self.fontSize = 21.0;
	self.horizontalSpacer = 30.0;
	self.scrollerHeight = 61.0;
	self.fontColor = [UIColor blackColor];
	self.backgroundColor = [UIColor whiteColor];

	return self;
}

// Applies object properties to stylize the scroll view passed to the method and populates with the object's tag array.
- (void)buildTagScroller:(UIScrollView *)aScrollView {
	float xCoord = self.origin.x;
	float yCoord = self.origin.y;
	
	if (aScrollView == nil) {
		return;
	}
	
	for(NSString *item in self.tagArray) {
		CGSize textSize = [item sizeWithFont:[UIFont systemFontOfSize: self.fontSize]];
		CGRect attrFrame = CGRectMake(xCoord, yCoord, textSize.width+10.0, textSize.height);
		
		UILabel *itemLabel = [[UILabel alloc] initWithFrame:attrFrame];
		
		itemLabel.text = item;
		itemLabel.textAlignment = UITextAlignmentLeft;
		itemLabel.textColor = self.fontColor;
		itemLabel.backgroundColor = self.backgroundColor;
		itemLabel.font = [UIFont boldSystemFontOfSize:self.fontSize];
		[aScrollView addSubview:itemLabel];	//add as subview to scrollview
		[itemLabel release];
		xCoord += textSize.width + self.horizontalSpacer;
	}
	//adjust the content size area for the scroller...
	CGSize scrollSize = CGSizeMake(xCoord, self.scrollerHeight);
	[aScrollView setContentSize:scrollSize];	
}

- (BOOL)didOriginGetAdjusted {
	BOOL result = NO;
	
	
	return result;
}

@end
