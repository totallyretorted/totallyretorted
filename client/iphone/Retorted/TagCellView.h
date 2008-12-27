//
//  TagCellView.h
//  Retorted - Custom cell view calls for TagView Controller.
//
//  Created by B.J. Ray on 12/26/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//


#import <UIKit/UIKit.h>
#define kTableCellViewRowHeight	65

@interface TagCellView : UITableViewCell {
	IBOutlet UILabel *tagName;
	IBOutlet UILabel *tagCount;
}

@property (nonatomic, retain) UILabel *tagName;
@property (nonatomic, retain) UILabel *tagCount;

@end
