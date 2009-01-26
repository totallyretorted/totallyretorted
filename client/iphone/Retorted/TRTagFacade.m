//
//  TRTagFacade.m
//  Retorted
//
//  Created by a on 12/23/08.
//  Copyright 2008 Forward Echo LLC. All rights reserved.
//

#import "TRTagFacade.h"
#import "TRRetortXMLParser.h"
#import "FEUrlHelper.h"
#import "Statistic.h"			//performance testing
#import "PerformanceStats.h"	//performance testing

NSString * const TRTagDataDidFinishedNotification = @"TRTagDataDidFinished";

@interface TRTagFacade()
@property(nonatomic, retain) NSDictionary *properties;

// ---- PERFORMANCE TESTING ----
@property (nonatomic, retain) Statistic *parseStat;
@property (nonatomic, retain) Statistic *downloadStat;
@property (nonatomic, retain) PerformanceStats *statHelper;
@end

@implementation TRTagFacade

@synthesize tags, loadSucessful, properties, xmlParser;

// ---- PERFORMANCE TESTING ----
@synthesize parseStat, downloadStat, statHelper;

- (id)init{
	if(![super init]){
		return nil;
	}
	self.loadSucessful=NO;
	
	[self addToNotificationWithSelector:@selector(handleDataLoadFailure:) notificationName:FEDataFailedLoadingNotification];
	[self addToNotificationWithSelector:@selector(handleTagXMLLoad:) notificationName:FEDataFinishedLoadingNotification];

	NSLog(@"TRTagFacade.init -> Initialization and registered to the notification center.");	
	self.properties=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"]];
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat = [[Statistic alloc] init];
	self.downloadStat = [[Statistic alloc] init];
	self.statHelper = [[PerformanceStats alloc] init];
	
	return self;
}

- (void)loadTags{
	
#if TARGET_CPU_ARM
	NSString *tagUrl = [NSString stringWithFormat:@"%@/tags.xml",[self.properties valueForKey:@"Retorted.Host"]];
#else
	NSString *tagUrl = [NSString stringWithFormat:@"%@/tags.xml",[self.properties valueForKey:@"Simulator.Host"]];
#endif 
	
	//NSString *tagUrl = [NSString stringWithFormat:@"%@/tags.xml",[self.properties valueForKey:@"Retorted.Host"]];
	
	NSLog(@"TRTagFacade.loadTags -> URL:%@ and performing a GET",tagUrl);
	
	FEUrlHelper *urlHelp =[[FEUrlHelper alloc] init];
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.downloadStat.start = [NSDate timeIntervalSinceReferenceDate];
	self.downloadStat.url = tagUrl;
	
	[urlHelp loadURLFromString:tagUrl withContentType:@"application/xml" HTTPMethod:@"GET" body:nil];
	[urlHelp release];
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
	NSLog(@"TRTagFacade: Unregistered with notification center.");
}


//
- (void)handleDataLoadFailure: (NSNotification *)note{
	
	self.loadSucessful=NO;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:TRTagDataDidFinishedNotification object:self];
	
	NSLog(@"TRTagFacade.handleDataLoadFailure ->Sending failure notification to the notification center.");
}

- (void)handleTagXMLLoad: (NSNotification *)note{

	NSLog(@"TRTagFacade.handleTagXMLLoad -> Received FEDataFinishedLoadingNotification notification.");
	
	NSError *parseError	= nil;
	FEUrlHelper *helpr = [note object];
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.downloadStat.end = [NSDate timeIntervalSinceReferenceDate];
	self.downloadStat.byteCount = helpr.xmlData.length;
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat.start = [NSDate timeIntervalSinceReferenceDate];

	NSLog(@"TRTagFacade.handleTagXMLLoad -> Calling XML Parser.");
	self.xmlParser = [[TRRetortXMLParser alloc] init];
	//TRRetortXMLParser *xmlParsr = [[TRRetortXMLParser alloc] init];
	[self.xmlParser parseRetortXML:helpr.xmlData parseError:&parseError];
	
	//TODO:  Handle parseError
	if (parseError !=nil) { 
		self.loadSucessful = NO;
	} else {
		self.loadSucessful = YES;
		self.tags = self.xmlParser.tags;
		NSLog(@"TRTagFacade.handleTagObjectsLoad -> Received %d tags.  Sending TRXMLRetortDataFinishedLoadingNotification notification.", [self.tags count]);
	}
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.parseStat.end = [NSDate timeIntervalSinceReferenceDate];
	self.statHelper.parseStat = self.parseStat;
	self.statHelper.downloadStat = self.downloadStat;
	[self.statHelper saveCurrentStatistics];
	[self.statHelper cleanupDBConnection];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:TRTagDataDidFinishedNotification object:self];
	
	[self removeFromAllNotifications];
	self.xmlParser = nil;
	
}


- (void)dealloc{
	//PERFORMANCE TESTING...
	self.statHelper = nil;
	self.parseStat = nil;
	self.downloadStat = nil;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	self.xmlParser = nil;
	self.tags=nil;
	[super dealloc];
}
@end


