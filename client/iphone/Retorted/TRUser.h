//
//  TRUser.h
//  Retorted
//
//  Created by B.J. Ray on 1/28/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//
//	ABSTRACT:
//	A model object for a user.  
//	This class is responsible for saving and retrieving the user information from the keychain.
//

#import <Foundation/Foundation.h>


@interface TRUser : NSObject {
	NSString *userName;
	NSString *password;
	BOOL isValid;
}

- (id)initWithUser:(NSString *)user password:(NSString *)pwd;

// Seperate method was added to require explicit setting of this value.  Only the AuthenticationHelper should set this value.
- (void)userValidationStatus:(BOOL)status;

// Constructs the base portion a the url necessary to post data or login.
//EXAMPLE: http://shant.donabedian:durkadurka@totallyretorted.com/path/to/resource.xml
- (NSString *)userCredentialsURLBase;

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;
@property (readonly) BOOL isValid;
@end
