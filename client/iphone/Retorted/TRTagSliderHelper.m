//
//  TRTagSliderHelper.m
//  Retorted
//
//  Created by B.J. Ray on 1/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRTagSliderHelper.h"
float const PADDING = 10.0;

@implementation TRTagSliderHelper
@synthesize tagArray, fontColor, backgroundColor, textCGSizes;
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
	NSUInteger index = 0;
	
	if (aScrollView == nil) {
		return;
	}
	
	//determine total width of content and adjust offset if necessary...
	float offset = [self getOffsetForTagsForScrollViewWidth:[aScrollView frame].size.width];
	xCoord += offset;
	
	//render tag slider view...
	for(NSString *item in self.tagArray) {
		CGSize textSize = [(NSValue *)[textCGSizes objectAtIndex:index] CGSizeValue];
		CGRect attrFrame = CGRectMake(xCoord, yCoord, textSize.width+PADDING, textSize.height);
		
		UILabel *itemLabel = [[UILabel alloc] initWithFrame:attrFrame];
		
		itemLabel.text = item;
		itemLabel.textAlignment = UITextAlignmentLeft;
		itemLabel.textColor = self.fontColor;
		itemLabel.backgroundColor = self.backgroundColor;
		itemLabel.font = [UIFont boldSystemFontOfSize:self.fontSize];
		[aScrollView addSubview:itemLabel];	//add as subview to scrollview
		[itemLabel release];
		xCoord += textSize.width + self.horizontalSpacer;
		index++;
	}
	//adjust the content size area for the scroller...
	CGSize scrollSize = CGSizeMake(xCoord, self.scrollerHeight);
	[aScrollView setContentSize:scrollSize];	
}

- (float)getOffsetForTagsForScrollViewWidth: (float)scrollWidth{
	float totalWidth = 0.0;
	float offset=0.0;
	self.textCGSizes = [[NSMutableArray alloc] init];
	
	for (NSString *item in self.tagArray) {
		CGSize textSize = [item sizeWithFont:[UIFont systemFontOfSize: self.fontSize]];
		[textCGSizes addObject: [NSValue valueWithCGSize: textSize]];
		totalWidth += textSize.width+PADDING+self.horizontalSpacer;
	}
	
	if(totalWidth < scrollWidth) {
		offset = (scrollWidth-totalWidth)/2;
	}
	
	return offset;
}

@end
