//
//  TRRetortFacade.m
//  Retorted
//
//  Created by B.J. Ray on 12/11/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetortFacade.h"

#import "FEUrlHelper.h"
#import "TRRetortXMLParser.h"

NSString * const TRRetortDataFinishedLoadingNotification = @"TRRetortDataFinishedLoading";

@interface TRRetortFacade()
@property(nonatomic, retain)NSDictionary *properties;
@end


@implementation TRRetortFacade
@synthesize retorts, loadSuccessful;
@synthesize properties;

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	self.loadSuccessful = NO;
	
	
	
	//Listen for notification from FEUrlHelper --> When do we have the raw content?
	[self addToNotificationWithSelector:@selector(handleRetortXMLLoad:) notificationName:FEDataFinishedLoadingNotification];
	[self addToNotificationWithSelector:@selector(handleDataLoadFailure:) notificationName:FEDataFailedLoadingNotification];
	
	NSLog(@"TRRetortFacade: Registered with notification center for: FEDataFinishedLoadingNotification & FEDataFailedLoadingNotification");
	
	properties = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"]]; 
	
	
	return self;
}


//Initiate call to URL to get raw XML dataset
- (void)loadRetorts {
	[self loadRetortsWithRelativePath:@"retorts/screenzero.xml"];
}

- (void)loadRetortsWithRelativePath:(NSString *)relPath {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString* retortsURL = [NSString stringWithFormat:@"%@/%@", [properties valueForKey:@"Retorted.Host"], relPath];
	
	NSLog(@"TRRetortFacade:  Getting data from URL using URLHelper: %@", retortsURL);
	
	
	FEUrlHelper *aHelper = [[FEUrlHelper alloc] init];
	[aHelper loadURLFromString:retortsURL withContentType:@"application/xml" HTTPMethod:@"GET" body:nil];
	
	[aHelper release];
	[pool release];
}

- (void)addToNotificationWithSelector:(SEL)selector notificationName:(NSString *)notificationName{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	[nc addObserver:self 
		   selector:selector
			   name:notificationName
			 object:nil];
}

- (void)removeFromAllNotifications {
	//remove self from notification center...
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	NSLog(@"TRRetortFacade: Unregistered with notification center.");
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
	
	if (parseError !=nil) {
		//handle parser error...
		NSLog(@"Description: %@", [parseError localizedDescription]);
		self.loadSuccessful = NO;
	} else {
		NSLog(@"# of retorts: %d", [xmlParser.retorts count]);
		self.retorts = xmlParser.retorts;
		self.loadSuccessful = YES;
	}
	
	//post a notification to be picked up by the Controller...
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

	[nc postNotificationName:TRRetortDataFinishedLoadingNotification object:self];
	NSLog(@"TRRetortFacade: Sending finished notification for Retort object creation");
	[xmlParser release];
	
	//remove self as an observer...
	[self removeFromAllNotifications];
}

- (void)handleDataLoadFailure: (NSNotification *)note {
	self.loadSuccessful = NO;
	
	//post a notification to be picked up by the Controller...
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	[nc postNotificationName:TRRetortDataFinishedLoadingNotification object:self];
	NSLog(@"TRRetortFacade: FAILED data call - Sending finished notification for Retort object creation");
	
	//remove self as an observer...
	[self removeFromAllNotifications];
}

- (void)dealloc {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	NSLog(@"TRRetortFacade: Unregistered with notification center.");
	
	[retorts release];
	
	[super dealloc];
}

@end
