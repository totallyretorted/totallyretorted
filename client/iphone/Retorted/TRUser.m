//
//  TRUser.m
//  Retorted
//
//  Created by B.J. Ray on 1/28/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRUser.h"

@interface TRUser()
@property BOOL isValid;

- (void)commitUserNameAndPasswordToKeychain;
- (void)retrieveUserNameAndPasswordFromKeychain;

@end

@implementation TRUser
@synthesize userName, password, isValid;

- (id)init {
	return [self initWithUser:nil password:nil];
}

- (id)initWithUser:(NSString *)user password:(NSString *)pwd {
	if (![super init]) {
		return nil;
	}
	
	self.userName = user;
	self.password = pwd;
	
	return self;
}

- (void)dealloc {
	self.userName = nil;
	self.password = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Public Methods
- (NSString *)description {
	return [NSString stringWithFormat:@"User: %@", self.userName];
}


#pragma mark -
#pragma mark Private Methods
- (void)commitUserNameAndPasswordToKeychain {
	JLog(@"Attempting to commit user: %@ with pwd: %@ to keychain.", self.userName, self.password);
}

- (void)retrieveUserNameAndPasswordFromKeychain {
	JLog(@"Attempting to retrieve user: %@ with pwd: %@ from keychain.", self.userName, self.password);
}

@end
