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
#import "TRRetortXMLParser.h"

NSString * const TRRetortDataFinishedLoadingNotification = @"TRRetortDataFinishedLoading";

@implementation TRRetortFacade
@synthesize retorts;

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	//Listen for notification from FEUrlHelper --> When do we have the raw content?
	[nc addObserver:self 
		   selector:@selector(handleRetortXMLLoad:) 
			   name:FEDataFinishedLoadingNotification 
			 object:nil];
	
	//Listen for notification from TRRetortXMLParser --> When is the XML read to consume?
	
	[nc addObserver:self 
		   selector:@selector(handleRetortObjectsLoad:) 
			   name:TRXMLRetortDataFinishedLoadingNotification 
			 object:nil];
	
	NSLog(@"TRRetortFacade: Registered with notification center for: DWDataFinishedLoadingNotification & DWLeadXMLParseCompleteNotification");
	
	
	return self;
}


//
- (void)loadRetorts {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//TODO: Add to constants file
	NSString *retortsURL = @"http://localhost:3000/retorts/screenzero.xml";
	
	// 2: use the URLHelper class to get the data
	NSLog(@"TRRetortFacade:  Getting data from URL using URLHelper: %@", retortsURL);
	
	
	FEUrlHelper *aHelper = [[FEUrlHelper alloc] init];
	[aHelper loadURLFromString:retortsURL withContentType:@"application/xml" HTTPMethod:@"GET"];
	
	/* Steps necessary
	 
	 3: create dictionary objects based on what we have or...
	 
	 */
	
	[aHelper release];
	[pool release];
}



//Received from notification center when FEUrlHelper is done getting raw retort content.
- (void) handleRetortXMLLoad: (NSNotification *)note {
	NSLog(@"TRRetortFacade:  FEDataFinishedLoadingNotification notification received: %@", note);
	NSError *parseError = nil;
	
	FEUrlHelper *aHelper = [note object];
	
	//use DWLeadHelper to parse XML and get lead objects...
	
	TRRetortXMLParser *xmlParser = [[TRRetortXMLParser alloc] init];
	NSLog(@"TRRetortFacade: Calling TRRetortXMLParser to parse XML.");
	[xmlParser parseRetortXML:aHelper.xmlData parseError:&parseError];
	
	//TODO: Do something with parseError
	
	
}

//Received from notification center when TRRetortXMLParser is done parsing retort content.
//TRXMLRetortDataFinishedLoadingNotification
- (void)handleRetortObjectsLoad: (NSNotification *)note {
	
	TRRetortXMLParser *xmlParser  = [note object];
	
	//get the salesLead objects that the lead helper gathered...
	//self.retorts = xmlParser.retorts;
	NSLog(@"TRRetortFacade: Received retort objects.");
	
	//post a notification to be picked up by the Controller...
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	[nc postNotificationName:TRRetortDataFinishedLoadingNotification object:self];
	NSLog(@"TRRetortFacade: Sending finished notification for Retort object creation");
	[xmlParser release];
	 
}

- (void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	NSLog(@"TRRetortFacade: Unregistered with notification center.");
	
    [super dealloc];
}

@end
