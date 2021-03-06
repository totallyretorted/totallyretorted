//
//  UrlHelper.h
//  XmlReaderSpike
//
//  Created by B.J. Ray on 11/19/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const FEDataFinishedLoadingNotification;
extern NSString * const FEDataFailedLoadingNotification;

@interface FEUrlHelper : NSObject {
	NSMutableData *xmlData;
	NSInteger errorCode;
	NSString *errorMsg;
	BOOL ignoreBadCertificate;
}
- (void)loadURLFromString:(NSString *)sUrl;			//POST with standard HTML content-type
- (void)loadURLFromString:(NSString *)sUrl			//specify the httpmethod and content-type
		  withContentType:(NSString *)contentType 
			   HTTPMethod:(NSString *)method
					 body:(NSString *)httpBody;

- (NSString *)base64EncodedWithUserName:(NSString *)user password:(NSString *)pwd;

@property(nonatomic, retain) NSMutableData *xmlData;
@property(nonatomic, retain) NSString *errorMsg;
@property NSInteger errorCode;
@property BOOL ignoreBadCertificate;
@end
