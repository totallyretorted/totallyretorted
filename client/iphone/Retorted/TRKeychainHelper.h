//
//  TRKeychainHelper.h
//  Retorted
//
//  Created by B.J. Ray on 2/2/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TRKeychainHelper : NSObject {
	NSMutableDictionary *keychainData;            // The actual Keychain data backing store.
    NSMutableDictionary *genericPasswordQuery;    // A placeholder for a generic Keychain Item query.
}

@property (nonatomic, retain) NSMutableDictionary *keychainData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;

- (BOOL)setLogin:(id)inLogin password:(id)inPassword;
- (id)objectForKey:(id)key;
- (NSString *)login;
- (NSString *)password;

// Initializes and resets the default generic Keychain Item data.
- (void)resetKeychainItem;

@end
