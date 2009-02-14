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
#import "RetortedAppDelegate.h"

NSString * const TRTagDataDidFinishedNotification = @"TRTagDataDidFinished";

@interface TRTagFacade()
- (void)loadTagsWithUrl:(NSString *)sUrl;

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

	JLog(@"Initialization and registered to the notification center.");	
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
	NSString *tagUrl = nil;
	RetortedAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//http://localhost:3000/tags/top_n_by_alpha.xml
	tagUrl = [NSString stringWithFormat:@"%@/tags/top_n_by_alpha.xml", appDelegate.baseURL];
	JLog(@"URL:%@ and performing a GET",tagUrl);
	
	[self loadTagsWithUrl:tagUrl];
}

- (void)loadTagsWithUrl:(NSString *)sUrl {
	FEUrlHelper *urlHelp =[[FEUrlHelper alloc] init];
	
	// -----------------------------
	// ---- PERFORMANCE TESTING ----
	// -----------------------------
	self.downloadStat.start = [NSDate timeIntervalSinceReferenceDate];
	self.downloadStat.url = sUrl;
	
	[urlHelp loadURLFromString:sUrl withContentType:@"application/xml" HTTPMethod:@"GET" body:nil];
	[urlHelp release];
}


- (void)loadTagsMatchingString:(NSString *)searchText {
	JLog(@"Performing tag search for %@", searchText);
//	NSString *sUrl = [NSString stringWithFormat:@"%@", searchText],
//	[self loadTagsWithUrl:sUrl];
	
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


//
- (void)handleDataLoadFailure: (NSNotification *)note{
	
	self.loadSucessful=NO;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:TRTagDataDidFinishedNotification object:self];
	
	JLog(@"Sending failure notification to the notification center.");
}

- (void)handleTagXMLLoad: (NSNotification *)note{

	JLog(@"Received FEDataFinishedLoadingNotification notification.");
	
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

	JLog(@"Calling XML Parser.");
	self.xmlParser = [[TRRetortXMLParser alloc] init];
	//TRRetortXMLParser *xmlParsr = [[TRRetortXMLParser alloc] init];
	[self.xmlParser parseRetortXML:helpr.xmlData parseError:&parseError];
	
	//TODO:  Handle parseError
	if (parseError !=nil) { 
		self.loadSucessful = NO;
	} else {
		self.loadSucessful = YES;
		self.tags = self.xmlParser.tags;
		JLog(@"Received %d tags.  Sending TRXMLRetortDataFinishedLoadingNotification notification.", [self.tags count]);
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


