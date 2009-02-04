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

@interface TRTagSliderHelper()
//INTERNAL METHODS
// Calculates the x-offset if all tags are viewable (i.e. an attempt to center)
- (float)getOffsetForTagsForScrollViewWidth: (float)scrollWidth;

// Adds a background image to the scrill view
-(void)addTiledImageForScrollView:(UIScrollView *)aScrollView;

// Creates a UILabel at a given point from a given TRTag object.
- (UILabel *)getLabelFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord;

// Creates a TRTagButton at a given point from a given TRTag object.
- (TRTagButton *)getButtonFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord;

// Removes old UILabel subviews from UIScrolView
- (void)removeOldLabelSubViewsFromScrollView:(UIScrollView *)aScrollView;

// Removes old TRTagButton subviews from UIScrolView
- (void)removeOldButtonSubViewsFromScrollView:(UIScrollView *)aScrollView;

@end


@implementation TRTagSliderHelper
@synthesize tagArray, fontColor, backgroundColor;
@synthesize horizontalSpacer, scrollerHeight;
@synthesize origin, font, displayBackgroundImage;

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
	self.font = [UIFont fontWithName:@"Georgia" size:21.0];
	self.horizontalSpacer = 30.0;
	self.scrollerHeight = 61.0;
	self.fontColor = [UIColor blackColor];
	self.backgroundColor = [UIColor clearColor];
	tagButtonTarget = nil;
	tagButtonSelector = NULL;
	self.displayBackgroundImage = NO;
	return self;
}

- (void)controlTypeAsButtonWithTarget:(id)aTarget selector:(SEL)aSelector {
	[aTarget retain];
	[tagButtonTarget release];
	tagButtonTarget = aTarget;
	
	tagButtonSelector = aSelector;
	controlType = TRTagSliderControlsAsButtons;
}


//applies a gradient background image to the scrollview.
-(void)addTiledImageForScrollView:(UIScrollView *)aScrollView {
	if (!aScrollView.backgroundColor) {
		UIImage *img = [UIImage imageNamed:@"slider-bg.png"];
		aScrollView.backgroundColor = [UIColor colorWithPatternImage:img];
		[img release];
	}	
}

//applies left and right scroll arrows if the content area is larger than the view
//	Not sure how to determine what is visible in the view
- (void)addScrollArrows:(UIScrollView *)aScrollView {
	//Try these methods: 
	//	CGRectOffset:		Returns a rectangle with an origin that is offset from that of the source rectangle.
	//	CGRectUnion:		Returns the smallest rectangle that contains the two provided rectangles.
	//	CGRectIntersection: Returns the intersection of two rectangles.
	//	CGRectGetMaxX:		Returns the x-coordinate that establishes the right edge of a rectangle
	//	CGRectGetMinX:		Returns the x-coordinate that establishes the left edge of a rectangle.
	
	//CGSize aSize = aScrollView.contentSize;  Gives me height and width
	//aScrollView.contentOffset;	The point at which the origin of the content view is offset from the origin of the scroll view.
	//CGRect visibleRect = [aScrollView
	
	UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider-left.png"]];
	UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider-right.png"]];
	
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
	
	if (self.displayBackgroundImage) {
		//add background image to view...
		[self addTiledImageForScrollView:aScrollView];
	}
	

	
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
	
	JLog(@"FIND ME: Content width of scrollview: %f", scrollSize.width);
	[aScrollView setContentSize:scrollSize];	
	
//	aScrollView.backgroundColor = [UIColor clearColor];
//	JLog(@"superviews: %@", aScrollView.superview);
//	aScrollView.opaque = NO;
//	for (UIView *aView in aScrollView.subviews) {
//		JLog(@"aView: %@", aView);
//		if ([aView isMemberOfClass:[UIImageView class]]) {
//			aView.alpha = 0.1;
//		}
//	}
//	//aScrollView.subviews = 0.1;
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
	JLog(@"subViewCount: %d", subViewCount);
	for (NSInteger i=subViewCount-1; i>-1; i--) {
		id aSubView = [[aScrollView subviews] objectAtIndex:i];
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
	JLog(@"FIND ME: Total Width of scrollview: %f", totalWidth);
	if(totalWidth < scrollWidth) {
		offset = (scrollWidth-totalWidth)/2;
	}
	
	return offset;
}

- (TRTagButton *)getButtonFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord {
	TRTagButton *button = nil;
	CGSize size = [tag sizeOfNonWrappingTagWithFont:self.font];
	//UIImage *image = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *image = [UIImage imageNamed:@"clearButton.png"];
	UIImage *imagePressed = [UIImage imageNamed:@"blueButton.png"];
	
	CGRect lblFrame = CGRectMake(xCoord, yCoord, size.width+PADDING, size.height);
	button = [[TRTagButton alloc] initWithFrame:lblFrame];
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	JLog(@"tag: %@", tag);
	[button setTitle:tag.value forState:UIControlStateNormal];	
	[button setTitleColor: self.fontColor forState:UIControlStateNormal];
	[button setFont:font];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	[button addTarget:tagButtonTarget action:tagButtonSelector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
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
	itemLabel.font = font;//[UIFont boldSystemFontOfSize:self.font.pointSize];
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
