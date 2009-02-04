//
//  TRSettingsFacade.m
//  Retorted
//
//  Created by B.J. Ray on 2/3/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRSettingsFacade.h"
#import "TRUser.h"
#import "TRKeychainHelper.h"
#import "TRAuthenticationHelper.h"
#import "RetortedAppDelegate.h"

@interface TRSettingsFacade()
// Used if TARGET_CPU_ARM
- (BOOL)saveUserToKeychain:(TRUser *)aUser;
- (TRUser *)retrieveStoredUserFromKeychain;


// Used if TARGET_IPHONE_SIMULATOR
- (BOOL)saveUserToNSUserDefault:(TRUser *)aUser;
- (TRUser *)retrieveStoredUserFromNSUserDefault;

@end


@implementation TRSettingsFacade

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	return self;
}

//saves and validates login
- (BOOL)loginWithUserName:(NSString *)userName password:(NSString *)pwd {
	BOOL success = NO;
	BOOL saveUserSuccessful = NO;
	TRUser *aUser = [[TRUser alloc] initWithUser:userName password:pwd];
	TRAuthenticationHelper *authHelper = [[TRAuthenticationHelper alloc] init];
	
#if TARGET_IPHONE_SIMULATOR 
	JLog(@"Saving user: %@ to disk", [aUser description]);
	saveUserSuccessful = [self saveUserToNSUserDefault:aUser];
#else
	JLog(@"Saving user: %@ to keychain", [aUser description]);
	saveUserSuccessful = [self saveUserToKeychain:aUser];
#endif
	
	if (saveUserSuccessful) {
		success = [authHelper connectAsUser:aUser];
	}
	
	[aUser release];
	[authHelper release];
	return success;
}

//returns the username and password of the current user, if saved...
- (NSDictionary *)getCurrentUserNameAndPasswordInDictionary {
	TRUser *aUser = nil;
	
	aUser = [self retrieveStoredUser];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:aUser.userName, @"name", aUser.password, @"password", nil];
	
	[dict autorelease];
	return dict;
}



- (TRUser *)retrieveStoredUser {
	TRUser *aUser = nil;
	
#if TARGET_IPHONE_SIMULATOR
	aUser = [self retrieveStoredUserFromNSUserDefault];
	JLog(@"Retreived user: %@ from disk", [aUser description]);
#else
	aUser = [self retrieveStoredUserFromKeychain];
	JLog(@"Retreived user: %@ from keychain", [aUser description]);
#endif
	
	return aUser;
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Private Methods

#pragma mark Device Methods
- (BOOL)saveUserToKeychain:(TRUser *)aUser {
	BOOL success = NO;
	TRKeychainHelper *keyHelper = [[TRKeychainHelper alloc] init];
	
	success = [keyHelper setLogin:aUser.userName password:aUser.password];
	
	[keyHelper release];
	return success;
}

- (TRUser *)retrieveStoredUserFromKeychain {
	TRUser *aUser = nil;
	TRKeychainHelper *keyHelper = [[TRKeychainHelper alloc] init];
	
	//TODO: Add retrieval method in TRKeychainHelper class
	
	[keyHelper release];
	return aUser;
}


#pragma mark Simulator Methods
- (BOOL)saveUserToNSUserDefault:(TRUser *)aUser {
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	[myDefaults setObject:aUser.userName forKey:@"userName"];
	[myDefaults setObject:aUser.password forKey:@"password"];
	
	//synchronize database...
	[NSUserDefaults resetStandardUserDefaults];
	return YES;
}

- (TRUser *)retrieveStoredUserFromNSUserDefault {
	TRUser *aUser = nil;
	NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
	NSString *uName = [myDefaults objectForKey:@"userName"];
	NSString *pwd = [myDefaults objectForKey:@"password"];
	
	if (uName != nil && pwd != nil) {
		aUser = [[TRUser alloc] initWithUser:uName password:pwd];
	}
	
	return aUser;
}



@end
