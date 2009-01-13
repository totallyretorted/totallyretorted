//
//  TRTagButton.h
//  Retorted
//
//  Created by B.J. Ray on 1/13/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TRTagButton : UIButton {
	NSNumber *tagId;
}
@property (nonatomic, retain) NSNumber *tagId;
@end
