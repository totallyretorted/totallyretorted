//
//  TRKeychainHelper.m
//  Retorted
//
//  Created by B.J. Ray on 2/2/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import "TRKeychainHelper.h"
#import <Security/Security.h>

static const UInt8 kKeychainIdentifier[]    = "com.forwardecho.retorted\0";

/*
 These are the default constants and their respective types,
 available for the kSecClassGenericPassword Keychain Item class:
 
 kSecAttrCreationDate        -        CFDateRef
 kSecAttrModificationDate    -        CFDateRef
 kSecAttrDescription        -        CFStringRef
 kSecAttrComment            -        CFStringRef
 kSecAttrCreator            -        CFNumberRef
 kSecAttrType                -        CFNumberRef
 kSecAttrLabel                -        CFStringRef
 kSecAttrIsInvisible        -        CFBooleanRef
 kSecAttrIsNegative            -        CFBooleanRef
 kSecAttrAccount            -        CFStringRef
 kSecAttrService            -        CFStringRef
 kSecAttrGeneric            -        CFDataRef

*/
@interface TRKeychainHelper()


- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (BOOL)writeToKeychain;
@end

@implementation TRKeychainHelper
@synthesize keychainData, genericPasswordQuery;

#pragma mark -
#pragma mark IPHONE SIMULATOR TARGET METHODS
// If the simulator is the target, then all of the methods are simply stubs
#if TARGET_IPHONE_SIMULATOR
- (BOOL)setLogin:(id)inLogin password:(id)inPassword { return NO; }
- (id)objectForKey:(id)key { return nil; }

- (void)resetKeychainItem {}
- (BOOL)writeToKeychain { return NO; }
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {return nil;}
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {return nil;} 
#else
#pragma mark -
#pragma mark DEVICE TARGET METHODS
- (id) init {
	if (![super init]) {
		return nil;
	}
	
	self.genericPasswordQuery = [[NSMutableDictionary alloc] init];
	[self.genericPasswordQuery setObject:kSecClassGenericPassword forKey:kSecClass];
	
	NSData *keychainType = [NSData dataWithBytes:kKeychainIdentifier length:strlen((const char *)kKeychainIdentifier)];
	[self.genericPasswordQuery setObject:keychainType forKey:(id)kSecAttrGeneric];
	
	
	// Use the proper search constants, return only the attributes of the first match.
	[self.genericPasswordQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	[self.genericPasswordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	
	
	NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:genericPasswordQuery];
	
	NSMutableDictionary *outDictionary = nil;
	
	if (! SecItemCopyMatching((CFDictionaryRef)tempQuery, (CFTypeRef *)&outDictionary) == noErr)
	{
		// Stick these default values into Keychain if nothing found.
		[self resetKeychainItem];
	}
	else
	{
		// load the saved data from Keychain.
		self.keychainData = [self secItemFormatToDictionary:outDictionary];
	}
	[outDictionary release];
	
	return self;
}

- (BOOL)setLogin:(id)inLogin password:(id)inPassword {
	BOOL doWrite = NO;
	BOOL success = NO;
	if (inLogin == nil || inPassword == nil) return;
	
	id currentLogin = [keychainData objectForKey:(id)kSecAttrLabel];
	id currentPwd = [keychainData objectForKey:(id)kSecValueData];
	
	if ([currentLogin isEqual:inLogin] && [currentPwd isEqual:inPassword]) {
		JLog(@"Login already exists in keychain.");
		success = YES;
	}
	
	if (![currentLogin isEqual:inLogin]) {
		[keychainData setObject:inLogin forKey:(id)kSecAttrLabel];
		doWrite = YES;
	}
	
	if (![currentPwd isEqual:inPassword]) {
		[keychainData setObject:inPassword forKey:(id)kSecValueData];
		doWrite = YES;
	}
	
	if (doWrite) {
		success = [self writeToKeychain];
	} 
	
	return success;
}

- (NSString *)login {
	return (NSString *)[self objectForKey:(id)kSecAttrLabel];
}

- (NSString *)password {
	return (NSString *)[self objectForKey:(id)kSecValueData];
}

- (id)objectForKey:(id)key {
    return [keychainData objectForKey:key];
}

- (void)resetKeychainItem {
	OSStatus junk = noErr;
    if (!keychainData) 
    {
        self.keychainData = [[NSMutableDictionary alloc] init];
    }
    else if (keychainData)
    {
        NSMutableDictionary *tmpDictionary = [self dictionaryToSecItemFormat:keychainData];
		junk = SecItemDelete((CFDictionaryRef)tmpDictionary);
        NSAssert( junk == noErr || junk == errSecItemNotFound, @"Problem deleting current dictionary." );
    }
    
    // Default generic data for Keychain Item.
	[keychainData setObject:@"Name" forKey:(id)kSecAttrLabel];
	[keychainData setObject:@"psswd" forKey:(id)kSecValueData];
}

#pragma mark Private methods
- (BOOL)writeToKeychain {
	OSStatus errorCode;
	BOOL success = NO;
    NSDictionary *attributes = NULL;
    NSMutableDictionary *updateItem = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef)genericPasswordQuery, (CFTypeRef *)&attributes) == noErr)
    {
        // First we need the attributes from the Keychain.
        updateItem = [NSMutableDictionary dictionaryWithDictionary:attributes];
        // Second we need to add the appropriate search key/values.
        [updateItem setObject:[genericPasswordQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        // Lastly, we need to set up the updated attribute list being careful to remove the class.
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:keychainData];
        [tempCheck removeObjectForKey:(id)kSecClass];
        
        // An implicit assumption is that you can only update a single item at a time.
		errorCode = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck);
		if (errorCode == noErr) {
			JLog(@"Updated values in keychain.");
			success = YES;
		} else {
			JLog(@"Couldn't update the Keychain Item.");
		}
//        NSAssert( SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck) == noErr, 
//                 @"Couldn't update the Keychain Item." );
    }
    else
    {
		// No previous item found, add the new one.
		errorCode = SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:keychainData], NULL);
		if (errorCode == noErr) {
			JLog(@"Added values to keychain.");
			success = YES;
		} else {
			JLog(@"Couldn't add the Keychain Item.");
		}
        
//        NSAssert( SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:keychainData], NULL) == noErr, 
//                 @"Couldn't add the Keychain Item." );
    }
	
	return success;
}

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert {
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for a SecItem.
    
    // Create returning dictionary populated with the attributes.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the Keychain Item class as well as the generic attribute.
    NSData *keychainType = [NSData dataWithBytes:kKeychainIdentifier length:strlen((const char *)kKeychainIdentifier)];
    [returnDictionary setObject:keychainType forKey:(id)kSecAttrGeneric];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Convert the NSString to NSData to fit the API paradigm.
    NSString *passwordString = [dictionaryToConvert objectForKey:(id)kSecValueData];
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
    
    return returnDictionary;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert {
    // The assumption is that this method will be called with a properly populated dictionary
    // containing all the right key/value pairs for the UI element.
    
    // Remove the generic attribute which distinguishes this Keychain Item with this
    // application.
    // Create returning dictionary populated with the attributes.
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    // Add the proper search key and class attribute.
    [returnDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [returnDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    // Acquire the password data from the attributes.
    NSData *passwordData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)returnDictionary, (CFTypeRef *)&passwordData) == noErr)
    {
        // Remove the search, class, and identifier key/value, we don't need them anymore.
        [returnDictionary removeObjectForKey:(id)kSecReturnData];
        
        // Add the password to the dictionary.
        NSString *password = [[[NSString alloc] initWithBytes:[passwordData bytes] length:[passwordData length] 
                                                     encoding:NSUTF8StringEncoding] autorelease];
        [returnDictionary setObject:password forKey:(id)kSecValueData];
    }
    else
    {
        // Don't do anything if nothing is found.
        NSAssert(NO, @"Serious error, nothing is found in the Keychain.\n");
    }
    
    [passwordData release];
    return returnDictionary;
}
#endif

- (void)dealloc {
	self.keychainData = nil;
	self.genericPasswordQuery = nil;
	[super dealloc];
}
@end
