//
//  RetortCellView.h
//  Retorted
//
//  Created by B.J. Ray on 1/7/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RetortCellView : UITableViewCell {
	IBOutlet UILabel *retortValue;
	IBOutlet UIImageView *rankIndicator;
}

@property (nonatomic, retain) UILabel *retortValue;
@property (nonatomic, retain) UIImageView *rankIndicator;

@end
