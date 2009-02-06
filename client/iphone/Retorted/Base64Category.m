//
//  Base64Category.m
//  Retorted
//
//  Created by B.J. Ray on 2/6/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "Base64Category.h"
#include "base64.h"
#include <string.h>


@implementation NSString (Base64Category)
- (NSString *)base64Encoding {
    char *inputString = [self UTF8String];
    char *encodedString;
    base64_encode(inputString, strlen(inputString), &encodedString);
    return [NSString stringWithUTF8String:encodedString];
}
@end
//
//@implementation Base64Category
//
//@end
