//
//  TRTagSliderHelper.m
//  Retorted
//
//  Created by B.J. Ray on 1/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRTagSliderHelper.h"
#import "TRTag.h"

float const PADDING = 10.0;

@implementation TRTagSliderHelper
@synthesize tagArray, fontColor, backgroundColor, textCGSizes;
@synthesize horizontalSpacer, scrollerHeight;//, fontSize;
@synthesize origin, font, controlType;

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
	self.controlType = TRTagSliderControlsAsButtons;
	self.origin = NSMakePoint(20.0, 20.0);
	self.font = [UIFont systemFontOfSize:21.0];
	//self.fontSize = 21.0;
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
	NSLog(@"subview count: %d", [[aScrollView subviews] count]);
	//get rid of older subviews...
	if (controlType == TRTagSliderControlsAsLabels) {
		[self removeOldLabelSubViewsFromScrollView:aScrollView];
	} else {
		[self removeOldButtonSubViewsFromScrollView:aScrollView];
	}
	
	//determine total width of content and adjust offset if necessary...
	float offset = [self getOffsetForTagsForScrollViewWidth:[aScrollView frame].size.width];
	xCoord += offset;
	
	//add all tags to scrollview
	for (NSUInteger i=0; i< [self.tagArray count]; i++) {
		id item = nil;
		if (controlType == TRTagSliderControlsAsLabels) {
			item = [self getLabelFromTag:[self.tagArray objectAtIndex:i] atX:xCoord y:yCoord];
		} else {
			item = [self getButtonFromTag:[self.tagArray objectAtIndex:i] atX:xCoord y:yCoord];
		}
			
		[aScrollView addSubview:item];
		xCoord += [item frame].size.width+self.horizontalSpacer;
	}
	
	//adjust the content size area for the scroller...
	CGSize scrollSize = CGSizeMake(xCoord, self.scrollerHeight);
	[aScrollView setContentSize:scrollSize];	
}

- (void)removeOldLabelSubViewsFromScrollView:(UIScrollView *)aScrollView {
	NSInteger subViewCount = [[aScrollView subviews] count];
	
	for (NSInteger i=subViewCount-1; i>-1; i--) {
		id aSubView = [[aScrollView subviews] objectAtIndex:i];
		if ([aSubView isMemberOfClass:[UILabel class]]) {
			[aSubView removeFromSuperview];
		}
	}
}

- (void)removeOldButtonSubViewsFromScrollView:(UIScrollView *)aScrollView {
	NSInteger subViewCount = [[aScrollView subviews] count];
	
	for (NSInteger i=subViewCount-1; i>-1; i--) {
		id aSubView = [[aScrollView subviews] objectAtIndex:i];
		if ([aSubView isMemberOfClass:[UIButton class]]) {
			[aSubView removeFromSuperview];
		}
	}
}

- (float)getOffsetForTagsForScrollViewWidth: (float)scrollWidth{
	float totalWidth = 0.0;
	float offset=0.0;
	//self.textCGSizes = [[NSMutableArray alloc] init];
	
	for (NSUInteger i = 0; i< [self.tagArray count]; i++) {
		id aTagItem = [self.tagArray objectAtIndex:i];
		if ([aTagItem isMemberOfClass:[TRTag class]]) {
			
			CGSize size = [(TRTag *)aTagItem sizeOfNonWrappingTagWithFont:self.font];
			totalWidth += size.width+PADDING+self.horizontalSpacer;
		}
	}
	
	/*			
	 for (NSString *item in self.tagArray) {
	 CGSize textSize = [item sizeWithFont:[UIFont systemFontOfSize: self.fontSize]];
	 [textCGSizes addObject: [NSValue valueWithCGSize: textSize]];
	 totalWidth += textSize.width+PADDING+self.horizontalSpacer;
	 }
	 */	
	if(totalWidth < scrollWidth) {
		offset = (scrollWidth-totalWidth)/2;
	}
	
	return offset;
}

- (UIButton *)getButtonFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord {
	UIButton *button = nil;
	CGSize size = [tag sizeOfNonWrappingTagWithFont:self.font];
	UIImage *image = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"blueButton.png"];
	
	CGRect lblFrame = CGRectMake(xCoord, yCoord, size.width+PADDING, size.height);
	button = [[UIButton alloc] initWithFrame:lblFrame];
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	NSLog(@"tag: %@", tag);
	[button setTitle:tag.value forState:UIControlStateNormal];	
	[button setTitleColor: self.fontColor forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	//[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = self.backgroundColor; //[UIColor clearColor];

	[button autorelease];
	return button;
}


- (UILabel *)getLabelFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord {
	UILabel *itemLabel = nil;
	CGSize size = [tag sizeOfNonWrappingTagWithFont:self.font];
	
	
	CGRect lblFrame = CGRectMake(xCoord, yCoord, size.width+PADDING, size.height);
	itemLabel = [[UILabel alloc] initWithFrame:lblFrame];
	itemLabel.text = tag.value;
	NSLog(@"tag: %@", tag);
	itemLabel.textAlignment = UITextAlignmentLeft;
	itemLabel.textColor = self.fontColor;
	itemLabel.backgroundColor = self.backgroundColor;
	itemLabel.font = [UIFont boldSystemFontOfSize:self.font.pointSize];
	[itemLabel autorelease];
	return itemLabel;
}


/*
- (void)addNewSubViewsToScrollView:(UIScrollView *)aScrollView atX:(float)xCoord y:(float)yCoord {
	NSUInteger index = 0;
	//float yCoord = self.origin.y;
	
	//loop through all tags that need to be added to tag slider...
	for(NSString *item in self.tagArray) {
		UILabel *itemLabel = nil;
		CGSize textSize = [(NSValue *)[textCGSizes objectAtIndex:index] CGSizeValue];
		CGRect lblFrame = CGRectMake(xCoord, yCoord, textSize.width+PADDING, textSize.height);
		
		itemLabel = [[UILabel alloc] initWithFrame:lblFrame];
		itemLabel.text = item;
		NSLog(@"tag: %@", item);
		itemLabel.textAlignment = UITextAlignmentLeft;
		itemLabel.textColor = self.fontColor;
		itemLabel.backgroundColor = self.backgroundColor;
		itemLabel.font = [UIFont boldSystemFontOfSize:self.fontSize];
		
		[aScrollView addSubview:itemLabel];	//add as subview to scrollview
		[itemLabel release];
		xCoord += textSize.width + self.horizontalSpacer;
		index++;
	}
}

*/





/*
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
*/



@end
