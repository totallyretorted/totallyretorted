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
- (NSDictionary *)getCurrentUserNameAndPasswordInDictionary;
- (BOOL)loginWithUserName:(NSString *)userName password:(NSString *)pwd;

- (TRUser *)retrieveStoredUser;
@end
