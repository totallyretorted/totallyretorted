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
	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(handleDataLoadFailure:) 
		       name:FEDataFailedLoadingNotification 
			 object:nil];
	
	[nc addObserver:self 
		   selector:@selector(handleTagXMLLoad:) 
		       name:FEDataFinishedLoadingNotification 
			 object:nil];

	[nc addObserver:self 
		   selector:@selector(handleTagObjectsLoad:) 
		       name:TRXMLRetortDataFinishedLoadingNotification 
			 object:nil];	

	NSLog(@"TRTagFacade.init -> Initialization and registered to the notification center.");
	
	properties=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Properties" ofType:@"plist"]];
	
	return self;
}

- (void)loadTags{
	
	NSString *tagUrl = [NSString stringWithFormat:@"%@/tags.xml",[properties valueForKey:@"Retorted.Host"]];
	
	NSLog(@"TRTagFacade.loadTags -> URL:%@ and performing a GET",tagUrl);
	
	FEUrlHelper *urlHelp =[[FEUrlHelper alloc] init];
	
	[urlHelp loadURLFromString:tagUrl withContentType:@"application/xml" HTTPMethod:@"GET" body:nil];
	
	[urlHelp release];
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
}

- (void)handleTagObjectsLoad: (NSNotification *)note{
	
	TRRetortXMLParser *rXMLParsr = [note object];
	self.tags = rXMLParsr.tags;
	self.loadSucessful=YES;

	NSLog(@"TRTagFacade.handleTagObjectsLoad -> Received %d tags.  Sending TRXMLRetortDataFinishedLoadingNotification notification.", [self.tags count]);
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:TRTagDataDidFinishedNotification object:self];
	
	//[rXMLParsr release];
}

- (void)dealloc{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	self.xmlParser = nil;
	self.tags=nil;
	[super dealloc];
}
@end


