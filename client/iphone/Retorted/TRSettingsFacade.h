//
//  TRSettingsFacade.h
//  Retorted
//
//  Created by B.J. Ray on 2/3/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TRUser;

@interface TRSettingsFacade : NSObject {

}
- (NSDictionary *)getStoredUserNameAndPasswordInDictionary;
- (BOOL)saveAndLoginWithUserName:(NSString *)userName password:(NSString *)pwd;
- (BOOL)loginWithUser:(TRUser *)aUser;		//does not save, just attempts to login.
- (TRUser *)getStoredUser;
@end
