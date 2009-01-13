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
@class TRTagButton;

//Controls how this helper renders the TagSlider
typedef enum {
    TRTagSliderControlsAsButtons  = 0,
    TRTagSliderControlsAsLabels   = 1,
} TRTagSliderControls;


@interface TRTagSliderHelper : NSObject {

	//Controls the layout and spacing of the Tag buttons or labels.  These all have default values.
	//	If you need to set these values to something other than the default, do so before 
	//	calling buildTagScroller:
	float horizontalSpacer;			// 30.0
	float scrollerHeight;			// 61.0
	NSPoint origin;					// 20.0, 20.0
	UIColor *fontColor;				// black
	UIColor *backgroundColor;		// white
	UIFont *font;					// systemFontOfSize 21
	
	//This parameter should not be set externally.  To configure, use
	//	the method - controlTypeAsButtonWithTarget: selector:
	TRTagSliderControls controlType;
	id tagButtonTarget;
	SEL tagButtonSelector;
	
	//The array of TRTag objects
	NSArray *tagArray;
}
// Designated initializer.  An exception will be thrown if you use init:
- (id)initWithTagArray:(NSArray *)tags;

// Defines the object and method that should be called when the user clicks a button.
- (void)controlTypeAsButtonWithTarget:(id)aTarget selector:(SEL)aSelector;

// Begins the process of building the slider by removing old views and adding new controls
//	as subviews to the UIScrollView that is passed in.
- (void)buildTagScroller:(UIScrollView *)aScrollView;


//INTERNAL METHODS - SHOULD NOT BE CALLED DIRECTLY
// Calculates the x-offset if all tags are viewable (i.e. an attempt to center)
- (float)getOffsetForTagsForScrollViewWidth: (float)scrollWidth;

// Creates a UILabel at a given point from a given TRTag object.
- (UILabel *)getLabelFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord;

// Creates a TRTagButton at a given point from a given TRTag object.
- (TRTagButton *)getButtonFromTag:(TRTag *)tag atX:(CGFloat)xCoord y:(CGFloat)yCoord;

// Removes old UILabel subviews from UIScrolView
- (void)removeOldLabelSubViewsFromScrollView:(UIScrollView *)aScrollView;

// Removes old TRTagButton subviews from UIScrolView
- (void)removeOldButtonSubViewsFromScrollView:(UIScrollView *)aScrollView;

@property float horizontalSpacer;
@property float scrollerHeight;
@property NSPoint origin;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *fontColor;
@property (nonatomic, retain) NSArray *tagArray;
@property (nonatomic, retain) UIColor *backgroundColor;

@end
