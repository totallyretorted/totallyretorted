//
//  TRFavoriteFacade.m
//  Retorted
//
//  Created by B.J. Ray on 12/17/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRFavoriteFacade.h"
#import "TRRetort.h"

@implementation TRFavoriteFacade


- (id)init {
	if (![super init]) {
		return nil;
	}
	
	favoriteRetorts = nil;
	
	return self;
}

- (BOOL)getFavoritesFromLocal {
	BOOL success = NO;
	
	return success;
}

- (BOOL)getFavoritesFromNetwork {
	BOOL success = NO;
	
	return success;
}

//call save from here?
- (void)addFavoriteRetort:(TRRetort *)favRetort {
	if (favoriteRetorts == nil) {
		favoriteRetorts = [NSMutableDictionary dictionaryWithObject:favRetort forKey:favRetort.primaryId]; 
	} else {
		[favoriteRetorts setObject:favRetort forKey:favRetort.primaryId];
	}
	
	[self saveRetortsToNetwork];	//async call
	[self saveRetortsToLocal];		//blocking call
	
	return;
}

//Stort in Sqlite3 database.
- (BOOL)saveRetortsToLocal {
	BOOL success = NO;
	
	return success;
}

//Initiate a POST to the webserver.
- (BOOL)saveRetortsToNetwork {
	BOOL success = NO;
	NSArray *retortIds = [favoriteRetorts allKeys];
	/*
	Will use FEUrlHelper to handle the POST.  We can assembly the data here. 
	<?xml version="1.0" encoding="UTF-8"?>
	<retorts type=\"array\">
		<retort id=\"1\"></retort>
		<retort id=\"4\"></retort>
		<retort id=\"23\"></retort>
		<retort id=\"6\"></retort>
		<retort id=\"85\"></retort>
	</retorts>
	 
	*/
	
	NSLog(@"Send retortIds to server using FEUrlHelper");
	return success;
}

- (void)dealloc {
	[favoriteRetorts release];
	[super dealloc];
}
@end
