//
//  TRViewHelper.h
//  Retorted
//
//  Created by B.J. Ray on 12/16/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TRViewHelper : NSObject {

}
+ (float)calculateHeightOfText:(NSString *)text withFont:(UIFont *)aFont width:(float)aWidth lineBreakMode:(UILineBreakMode)lineBreak;
@end
