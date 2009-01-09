//
//  TRTagSliderHelper.h
//  Retorted
//
//  Created by B.J. Ray on 1/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TRTag;

@interface TRTagSliderHelper : NSObject {
	//float fontSize;
	float horizontalSpacer;
	float scrollerHeight;
	
	NSPoint origin;
	
	UIColor *fontColor;
	UIColor *backgroundColor;
	NSArray *tagArray;
	NSMutableArray *textCGSizes;
	UIFont *font;
}
- (id)initWithTagArray:(NSArray *)tags;
- (void)buildTagScroller:(UIScrollView *)aScrollView;
- (float)getOffsetForTagsForScrollViewWidth: (float)scrollWidth;

- (UILabel *)getLabelFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord;
- (void)removeOldSubViewsFromScrollView:(UIScrollView *)aScrollView;

//@property float fontSize;
@property float horizontalSpacer;
@property float scrollerHeight;
@property NSPoint origin;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, retain) NSArray *tagArray;
@property (nonatomic, retain) NSMutableArray *textCGSizes;
@property (nonatomic, retain) UIColor *backgroundColor;

@end
