//
//  TRNotificationInterface.h
//  Retorted
//
//	A very basic interface to ensure classes adhere to this contract.
//
//  Created by B.J. Ray on 12/31/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TRNotificationInterface

// Removes the object from the notification center
- (void)removeFromAllNotifications;

// Adds object to the default notification center with a given selector and notification name.
- (void)addToNotificationWithSelector:(SEL)selector notificationName:(NSString *)name;

@end
