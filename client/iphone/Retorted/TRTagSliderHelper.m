//
//  TRTagSliderHelper.m
//  Retorted
//
//  Created by B.J. Ray on 1/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRTagSliderHelper.h"
#import "TRTag.h"
#import "TRTagButton.h"

float const PADDING = 10.0;

@implementation TRTagSliderHelper
@synthesize tagArray, fontColor, backgroundColor;
@synthesize horizontalSpacer, scrollerHeight;
@synthesize origin, font;

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
	controlType = TRTagSliderControlsAsLabels;
	self.origin = CGPointMake(20.0, 20.0);
	self.font = [UIFont systemFontOfSize:21.0];
	self.horizontalSpacer = 30.0;
	self.scrollerHeight = 61.0;
	self.fontColor = [UIColor blackColor];
	self.backgroundColor = [UIColor whiteColor];
	tagButtonTarget = nil;
	tagButtonSelector = NULL;

	return self;
}

- (void)controlTypeAsButtonWithTarget:(id)aTarget selector:(SEL)aSelector {
	[aTarget retain];
	[tagButtonTarget release];
	tagButtonTarget = aTarget;
	
	tagButtonSelector = aSelector;
	controlType = TRTagSliderControlsAsButtons;
}


// Applies object properties to stylize the scroll view passed to the method and populates with the object's tag array.
- (void)buildTagScroller:(UIScrollView *)aScrollView {
	float xCoord = self.origin.x;
	float yCoord = self.origin.y;
	
	if (aScrollView == nil) {
		return;
	}
	JLog(@"Subview count: %d", [[aScrollView subviews] count]);
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
		//if ([aSubView isMemberOfClass:[UIButton class]]) {
		if ([aSubView isMemberOfClass:[TRTagButton class]]) {
			[aSubView removeFromSuperview];
		}
	}
}

- (float)getOffsetForTagsForScrollViewWidth: (float)scrollWidth{
	float totalWidth = 0.0;
	float offset=0.0;
	
	for (NSUInteger i = 0; i< [self.tagArray count]; i++) {
		id aTagItem = [self.tagArray objectAtIndex:i];
		if ([aTagItem isMemberOfClass:[TRTag class]]) {
			
			CGSize size = [(TRTag *)aTagItem sizeOfNonWrappingTagWithFont:self.font];
			totalWidth += size.width+PADDING+self.horizontalSpacer;
		}
	}
	
	if(totalWidth < scrollWidth) {
		offset = (scrollWidth-totalWidth)/2;
	}
	
	return offset;
}
- (TRTagButton *)getButtonFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord {
	TRTagButton *button = nil;
	CGSize size = [tag sizeOfNonWrappingTagWithFont:self.font];
	UIImage *image = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"blueButton.png"];
	
	CGRect lblFrame = CGRectMake(xCoord, yCoord, size.width+PADDING, size.height);
	button = [[TRTagButton alloc] initWithFrame:lblFrame];
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	JLog(@"tag: %@", tag);
	[button setTitle:tag.value forState:UIControlStateNormal];	
	[button setTitleColor: self.fontColor forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	[button addTarget:tagButtonTarget action:tagButtonSelector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = self.backgroundColor; //[UIColor clearColor];
	button.tagId = tag.primaryId;
	
	[button autorelease];
	return button;
}

- (UILabel *)getLabelFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord {
	UILabel *itemLabel = nil;
	CGSize size = [tag sizeOfNonWrappingTagWithFont:self.font];
	
	
	CGRect lblFrame = CGRectMake(xCoord, yCoord, size.width+PADDING, size.height);
	itemLabel = [[UILabel alloc] initWithFrame:lblFrame];
	itemLabel.text = tag.value;
	JLog(@"tag: %@", tag);
	itemLabel.textAlignment = UITextAlignmentLeft;
	itemLabel.textColor = self.fontColor;
	itemLabel.backgroundColor = self.backgroundColor;
	itemLabel.font = [UIFont boldSystemFontOfSize:self.font.pointSize];
	[itemLabel autorelease];
	return itemLabel;
}


- (void)dealloc {
	self.font = nil;
	self.fontColor = nil;
	self.backgroundColor = nil;
	self.tagArray = nil;
	[super dealloc];
}


@end
