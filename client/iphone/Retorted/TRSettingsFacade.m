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
- (BOOL)saveAndLoginWithUserName:(NSString *)userName password:(NSString *)pwd {
	BOOL success = NO;
	BOOL saveUserSuccessful = NO;
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.currentUser = [[TRUser alloc] initWithUser:userName password:pwd];
	
	//Attempt to save user settings.
#if TARGET_IPHONE_SIMULATOR 
	JLog(@"Saving user: %@ to disk", [appDelegate.currentUser description]);
	saveUserSuccessful = [self saveUserToNSUserDefault:appDelegate.currentUser];
#else
	JLog(@"Saving user: %@ to keychain", [appDelegate.currentUser description]);
	saveUserSuccessful = [self saveUserToKeychain:appDelegate.currentUser];
#endif
	
	if (saveUserSuccessful) {
		success = [self loginWithUser:appDelegate.currentUser];
	}
	
//	[aUser release];
	return success;
}

// Attempts to login as user and sets TRUser property.
- (BOOL)loginWithUser:(TRUser *)aUser {
	TRAuthenticationHelper *authHelper = [[TRAuthenticationHelper alloc] init];
	BOOL success = NO;
	success = [authHelper connectAsUser:aUser];
	JLog(@"connecting as user: %@.  Success = %d", [aUser description], success);
	[aUser userValidationStatus:success];
	[authHelper release];
	return success;
}

//returns the username and password of the current user, if saved...
- (NSDictionary *)getStoredUserNameAndPasswordInDictionary {
	TRUser *aUser = nil;
	
	aUser = [self getStoredUser];
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:aUser.userName, @"name", aUser.password, @"password", nil];
	
	[dict autorelease];
	return dict;
}


//Retrieves the stored user name and password and returns in the form of a user object.
- (TRUser *)getStoredUser {
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
	
	NSString *uName = [keyHelper login];
	NSString *pwd = [keyHelper password];
	
	if (uName != nil && pwd != nil) {
		aUser = [[TRUser alloc] initWithUser:uName password:pwd];
		[aUser autorelease];
	}
	
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
		[aUser autorelease];
	}
	
	return aUser;
}



@end
