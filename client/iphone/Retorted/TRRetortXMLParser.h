//
//  TRRetortXMLParser.h
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TRRetortXMLParser : NSObject {

}

- (void)parseRetortXML:(NSData *)xmlData parseError:(NSError **)error;

@end
