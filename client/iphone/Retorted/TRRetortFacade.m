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
#import "PerformanceStats.h"	//performance testing
#import "RetortedAppDelegate.h"

NSString * const TRRetortDataFinishedLoadingNotification = @"TRRetortDataFinishedLoading";

@interface TRRetortFacade()
@property(nonatomic, retain)NSDictionary *properties;

// ---- PERFORMANCE TESTING ----
@property (nonatomic, retain) Statistic *parseStat;
@property (nonatomic, retain) Statistic *downloadStat;
@property (nonatomic, retain) PerformanceStats *statHelper;
@end


@implementation TRRetortFacade
@synthesize retorts, loadSuccessful;
@synthesize properties;

// ---- PERFORMANCE TESTING ----
@synthesize parseStat, downloadStat, statHelper;

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	self.loadSuccessful = NO;
	//Listen for notification from FEUrlHelper --> When do we have the raw content?
	[self addToNotificationWithSelector:@selector(handleRetortXMLLoad:) notificationName:FEDataFinishedLoadingNotification];
	[self addToNotificationWithSelector:@selector(handleDataLoadFailure:) notificationName:FEDataFailedLoadingNotification];
	
	JLog(@"Registered with notification center for: FEDataFinishedLoadingNotification & FEDataFailedLoadingNotification");
	
	properties = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"]]; 
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat = [[Statistic alloc] init];
	self.downloadStat = [[Statistic alloc] init];
	self.statHelper = [[PerformanceStats alloc] init];
	
	return self;
}


//Initiate call to URL to get raw XML dataset
- (void)loadRetorts {
	[self loadRetortsWithRelativePath:@"retorts/screenzero.xml"];
}

- (void)loadRetortsWithRelativePath:(NSString *)relPath {
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString* retortsURL = nil;
	
	retortsURL = [NSString stringWithFormat:@"%@/%@", appDelegate.baseURL, relPath];
	//NSString *buildSettingStr = [[NSString alloc] initWithString:@"%@",$(retortedSimulatorHost)];
	
	
	JLog(@"Getting data from URL using URLHelper: %@", retortsURL);
	
	
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
	JLog(@"Unregistered with notification center.");
}


//Received from notification center when FEUrlHelper is done getting raw retort content.
- (void) handleRetortXMLLoad: (NSNotification *)note {
	
	JLog(@"FEDataFinishedLoadingNotification notification received: %@", note);
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
	JLog(@"Calling TRRetortXMLParser to parse XML.");
	
	[xmlParser parseRetortXML:aHelper.xmlData parseError:&parseError];
	
	if (parseError !=nil) {
		//handle parser error...
		JLog(@"Description: %@", [parseError localizedDescription]);
		self.loadSuccessful = NO;
	} else {
		JLog(@"# of retorts: %d", [xmlParser.retorts count]);
		self.retorts = xmlParser.retorts;
		self.loadSuccessful = YES;
	}
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat.end = [NSDate timeIntervalSinceReferenceDate];
	self.statHelper.parseStat = self.parseStat;
	self.statHelper.downloadStat = self.downloadStat;
	[self.statHelper saveCurrentStatistics];
	[self.statHelper cleanupDBConnection];
	
	//post a notification to be picked up by the Controller...
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

	[nc postNotificationName:TRRetortDataFinishedLoadingNotification object:self];
	JLog(@"Sending finished notification for Retort object creation");
	[xmlParser release];
	
	//remove self as an observer...
	[self removeFromAllNotifications];
}

- (void)handleDataLoadFailure: (NSNotification *)note {
	self.loadSuccessful = NO;
	
	//post a notification to be picked up by the Controller...
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
	[nc postNotificationName:TRRetortDataFinishedLoadingNotification object:self];
	JLog(@"FAILED data call - Sending finished notification for Retort object creation");
	
	//remove self as an observer...
	[self removeFromAllNotifications];
}

- (void)dealloc {
	//PERFORMANCE TESTING...
	self.statHelper = nil;
	self.parseStat = nil;
	self.downloadStat = nil;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	JLog(@"Unregistered with notification center.");
	[retorts release];
	
	[super dealloc];
}

@end
