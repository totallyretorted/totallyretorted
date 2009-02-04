//
//  TRAuthenticationHelper.h
//  Retorted
//
//  Created by B.J. Ray on 1/28/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//
//	ABSTRACT:
//	Responsible for handling the authentication between the iPhone app and the server.
//	This amounts to establishing the connection, passing the user credentials, and verifying the response.
//
//
//	Either:
//		Send request to "http://#{login}:#{password}@totallyretorted.com/path/to/resource.xml"
//
//  Or:
//		Send request to "http://totallyretorted.com/path/to/resource.xml" and add to the request the 
//		HTTP_AUTHORIZATION header with the value "Basic "+Base64::encode64("#{login}:#{password}").  
//		It should end up looking like:
//			HTTP_AUTHORIZATION: Basic KJIUDFGIOUREHOEIX()Y*&TU9qwjGIYBAKHSBFG&7ty7&IUHU
//
//	NOTE: To my knowledge there is no base64 encoding schema available on the iPhone.  Perhaps use openSSL
//		or http://colloquy.info/project/browser/trunk/NSDataAdditions.m?rev=2254 
//		or http://www.cocoadev.com/index.pl?BaseSixtyFour
//

#import <Foundation/Foundation.h>
@class TRUser;

@interface TRAuthenticationHelper : NSObject {

}

- (BOOL)connectAsUser:(TRUser *)user;

@end
