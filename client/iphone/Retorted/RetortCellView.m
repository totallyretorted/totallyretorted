//
//  RetortCellView.m
//  Retorted
//
//  Created by B.J. Ray on 1/7/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "RetortCellView.h"


@implementation RetortCellView
@synthesize retortValue, rankIndicator;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
