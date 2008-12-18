//
//  TRFavoriteFacade.h
//  Retorted
//
//  Created by B.J. Ray on 12/17/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TRRetort;

@interface TRFavoriteFacade : NSObject {
	NSMutableDictionary *favoriteRetorts;
}

- (BOOL)getFavoritesFromLocal;
- (BOOL)getFavoritesFromNetwork;
- (void)addFavoriteRetort:(TRRetort *)favRetort;
- (BOOL)saveRetortsToLocal;
- (BOOL)saveRetortsToNetwork;


@end
