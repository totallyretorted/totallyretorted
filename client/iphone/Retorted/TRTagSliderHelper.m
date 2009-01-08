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
	NSUInteger subViewIndex = 0;
	NSUInteger subViewCount = 0;
	BOOL usingExistingSubView = NO;
	
	if (aScrollView == nil) {
		return;
	}
	subViewCount = [[aScrollView subviews] count];
	
	//determine total width of content and adjust offset if necessary...
	float offset = [self getOffsetForTagsForScrollViewWidth:[aScrollView frame].size.width];
	xCoord += offset;
	
	//loop through all tags that need to be added to tag slider...
	for(NSString *item in self.tagArray) {
		usingExistingSubView = NO;
		UILabel *itemLabel = nil;
		CGSize textSize = [(NSValue *)[textCGSizes objectAtIndex:index] CGSizeValue];
		CGRect lblFrame = CGRectMake(xCoord, yCoord, textSize.width+PADDING, textSize.height);
		
		//check if subviews exist...try and reuse them, if possible...
		for (NSUInteger i = subViewIndex; i<subViewCount; i++) {
			id aSubView = [[aScrollView subviews] objectAtIndex:subViewIndex];
			
			if ([aSubView isMemberOfClass:[UILabel class]]) {
				//reuse this object!
				itemLabel = aSubView;
				itemLabel.frame = lblFrame;	//adjust the frame accordingly...
				subViewIndex++;	
				usingExistingSubView = YES;
				i = subViewCount;	//exit loop
			}
		}
		
		if (itemLabel == nil) {
			//no subview found
			itemLabel = [[UILabel alloc] initWithFrame:lblFrame];
		}
		
		itemLabel.text = item;
		NSLog(@"tag: %@", item);
		itemLabel.textAlignment = UITextAlignmentLeft;
		itemLabel.textColor = self.fontColor;
		itemLabel.backgroundColor = self.backgroundColor;
		itemLabel.font = [UIFont boldSystemFontOfSize:self.fontSize];
		
		if (!usingExistingSubView) {
			[aScrollView addSubview:itemLabel];	//add as subview to scrollview
			[itemLabel release];
		}
		xCoord += textSize.width + self.horizontalSpacer;
		index++;
	}
	
	//remove any remaining uilabel subviews...
	if (subViewIndex < subViewCount) {
		for (NSUInteger i = subViewIndex; i<subViewCount; i++) {
			id aSubView = [[aScrollView subviews] objectAtIndex:subViewIndex];
			if ([aSubView isMemberOfClass:[UILabel class]]) {
				[aSubView removeFromSuperview];
			}
		}
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
