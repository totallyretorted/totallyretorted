//
//  TRTagSliderHelper.h
//  Retorted
//
//  Created by B.J. Ray on 1/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TRTagSliderHelper : NSObject {
	float fontSize;
	float horizontalSpacer;
	float scrollerHeight;
	
	NSPoint origin;
	
	UIColor *fontColor;
	UIColor *backgroundColor;
	NSArray *tagArray;
	NSMutableArray *textCGSizes;
}
- (id)initWithTagArray:(NSArray *)tags;
- (void)buildTagScroller:(UIScrollView *)aScrollView;
- (float)getOffsetForTagsForScrollViewWidth: (float)scrollWidth;
 
@property float fontSize;
@property float horizontalSpacer;
@property float scrollerHeight;
@property NSPoint origin;
@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, retain) NSArray *tagArray;
@property (nonatomic, retain) NSMutableArray *textCGSizes;
@property (nonatomic, retain) UIColor *backgroundColor;

@end
