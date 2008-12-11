//
//  TRRetortFacade.m
//  Retorted
//
//  Created by B.J. Ray on 12/11/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetortFacade.h"
#import "Constants.h"
#import "FEUrlHelper.h"

@implementation TRRetortFacade

- (void)loadRetorts {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// 2: use the URLHelper class to get the data
	NSLog(@"TRRetortFacade:  Getting data from URL using URLHelper: %@", retortsURL);
	
	FEUrlHelper *aHelper = [[FEUrlHelper alloc] init];
	//[aHelper loadURLFromString:urlString withContentType:@"application/xml" HTTPMethod:@"GET"];
	
	/* Steps necessary
	 
	 3: create dictionary objects based on what we have or...
	 
	 */
	
	[aHelper release];
	[pool release];
}

@end
