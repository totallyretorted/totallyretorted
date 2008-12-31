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

NSString * const TRTagDataDidFinishedNotification = @"TRTagDataDidFinished";

@interface TRTagFacade()
@property(nonatomic, retain) NSDictionary *properties;
@end

@implementation TRTagFacade

@synthesize tags, loadSucessful, properties, xmlParser;

- (id)init{
	if(![super init]){
		return nil;
	}
	self.loadSucessful=NO;
	
	[self addToNotificationWithSelector:@selector(handleDataLoadFailure:) notificationName:FEDataFailedLoadingNotification];
	[self addToNotificationWithSelector:@selector(handleTagXMLLoad:) notificationName:FEDataFinishedLoadingNotification];

	NSLog(@"TRTagFacade.init -> Initialization and registered to the notification center.");	
	self.properties=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"]];
	
	return self;
}

- (void)loadTags{
	
	NSString *tagUrl = [NSString stringWithFormat:@"%@/tags.xml",[self.properties valueForKey:@"Retorted.Host"]];
	
	NSLog(@"TRTagFacade.loadTags -> URL:%@ and performing a GET",tagUrl);
	
	FEUrlHelper *urlHelp =[[FEUrlHelper alloc] init];
	
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
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:TRTagDataDidFinishedNotification object:self];
	
	[self removeFromAllNotifications];
	self.xmlParser = nil;
	
}


//12.31.2008 - Removed by B.J. - not needed as XMLParser is not async - we will handle this in the method that calls the parser
/*
- (void)handleTagObjectsLoad: (NSNotification *)note{
	
	TRRetortXMLParser *rXMLParsr = [note object];
	self.tags = rXMLParsr.tags;
	self.loadSucessful=YES;

	NSLog(@"TRTagFacade.handleTagObjectsLoad -> Received %d tags.  Sending TRXMLRetortDataFinishedLoadingNotification notification.", [self.tags count]);
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:TRTagDataDidFinishedNotification object:self];
	
	//[rXMLParsr release];
}
*/

- (void)dealloc{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	self.xmlParser = nil;
	self.tags=nil;
	[super dealloc];
}
@end


