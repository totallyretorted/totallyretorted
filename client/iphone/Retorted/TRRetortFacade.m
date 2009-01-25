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
#import "Statistic.h"			//performance testing
#import "RetortedAppDelegate.h"	//performance testing

NSString * const TRRetortDataFinishedLoadingNotification = @"TRRetortDataFinishedLoading";

@interface TRRetortFacade()
@property(nonatomic, retain)NSDictionary *properties;

// ---- PERFORMANCE TESTING ----
@property (nonatomic, retain) Statistic *parseStat;
@property (nonatomic, retain) Statistic *downloadStat;

@end


@implementation TRRetortFacade
@synthesize retorts, loadSuccessful;
@synthesize properties;

//performance testing...
@synthesize parseStat, downloadStat;

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
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat = [[Statistic alloc] init];
	self.downloadStat = [[Statistic alloc] init];
	
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
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.downloadStat.start = [NSDate timeIntervalSinceReferenceDate];
	self.downloadStat.url = retortsURL;
	
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
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.downloadStat.end = [NSDate timeIntervalSinceReferenceDate];
	self.downloadStat.byteCount = aHelper.xmlData.length;
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat.start = [NSDate timeIntervalSinceReferenceDate];
	
	
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
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat.end = [NSDate timeIntervalSinceReferenceDate];
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate addParserStatistic:self.parseStat];
	[appDelegate addDownloadStatistic:self.downloadStat];
	[appDelegate saveStatistic];
	
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
