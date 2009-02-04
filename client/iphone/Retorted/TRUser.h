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
@private
	BOOL isValid;
}

- (id)initWithUser:(NSString *)user password:(NSString *)pwd;

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *password;

@end
