//
//  TagCellView.m
//  Retorted
//
//  Created by B.J. Ray on 12/26/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TagCellView.h"


@implementation TagCellView
@synthesize tagName, tagCount;


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
