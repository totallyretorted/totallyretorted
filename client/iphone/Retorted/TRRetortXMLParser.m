//
//  TRRetortXMLParser.m
//  Retorted
//
//  MAY BE REPLACED BY SOMETHING LIKE: http://code.google.com/p/touchcode/wiki/TouchXML
//	ALSO CHECK OUT APPLE'S SAMPLE CODE: XMLPerformance - COMPARES NSParse AND LOWER LEVEL C ROUTINES
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//


#import "TRRetortXMLParser.h"
#import "TRRetort.h"
//#import "TRRating.h"
#import "TRTag.h"
#import "TRAttribution.h"



// Message listed to by TRReportFacade
// Message sent to NC by TRRetortXMLParser
NSString * const TRXMLRetortDataFinishedLoadingNotification = @"TRRawRetortDataFinishedLoading"; //Listened by RetortFacade
int const INVALID_PK = 8;

@implementation TRRetortXMLParser
@synthesize currentTextNode;
@synthesize currentRetort, currentTag, currentAttribution;
@synthesize retorts, tags;
@synthesize canAppend;


- (id)init {
	if (![super init]) {
		return nil;
	}
	
	self.retorts = [[NSMutableArray alloc] init];
	
	
	return self;
}

#pragma mark Public Method

- (void)parseRetortXML:(NSData *)xmlData parseError:(NSError **)error {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	[parser setDelegate:self];
	
	[parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
	JLog(@"Begin Parsing");
	[parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;	//error is handled by calling class
    }
	
	JLog(@"Parsing Complete!");
    [parser release];
}

#pragma mark -
#pragma mark NSXMLParser Delegate Methods

// Optional:  Use this if there is any preprocessing necessary that isn't handled in the init: method.
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	JLog(@"Started parsing document");
	//self.currentTextNode = [[NSMutableString alloc] init];
	
}

#pragma mark -
#pragma mark Start Element parsing
// Called when the parser encounters a new element.  For Example: <myTag>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	JLog(@"didStartElement: %@", elementName);
	
	canAppend = YES;
	if (self.currentTextNode != nil)		//maybe we just send it the message nil?
	{
		[self.currentTextNode release];
	}
	self.currentTextNode = [[NSMutableString alloc] init];
	
	if ([elementName isEqualToString:@"retorts"]) 
	{
		//create an array for retorts to be put into
		self.retorts = [[NSMutableArray alloc] init];
		return;
	}
		
	// Primary objects...
	if ([elementName isEqualToString:@"retort"]) {
		//create new retort and set it's id attribute
		self.currentRetort = [[TRRetort alloc] init];
		
		NSNumber *pid = [attributeDict valueForKey:@"id"];
		if (pid != nil)
			self.currentRetort.primaryId = pid;
		else 
			self.currentRetort.primaryId = [NSNumber numberWithInt: INVALID_PK];
		
		return;
		
	}
	
	if ([elementName isEqualToString:@"tags"]) 
	{
		//create a tags array and associate it with the current retort
		NSMutableArray* ts = [[NSMutableArray alloc] init];
		
		if (self.currentRetort != nil) {
			self.currentRetort.tags = ts;
		} else {
			//parsing tags url because there is no retort nodes
			self.tags = ts;
		}
		
		[ts release];
		return;
	}
	
	if ([elementName isEqualToString:@"tag"]) {
		//create new tag object and add to currentRetort tag collection
		self.currentTag = [[TRTag alloc] init];
		
		NSString *weight = [attributeDict valueForKey:@"weight"];
		NSNumber *pid = [attributeDict valueForKey:@"id"];
		
		if (weight != nil) 
			self.currentTag.weight = [weight intValue];

		if (pid != nil)
			self.currentTag.primaryId = pid;
		else
			self.currentTag.primaryId = [NSNumber numberWithInt: INVALID_PK];
		
		return;
	}
	
//	
//	if ([elementName isEqualToString:@"rating"]) {
//		self.currentRating = [[TRRating alloc] init];
//		return;
//	}
	

	if ([elementName isEqualToString:@"attribution"]) 
	{
		//create an attribution and add it to the current retort
		self.currentAttribution = [[TRAttribution alloc] init];
		return;
	}
}

// Called when the parser encounters the closing tag of an element.  For Example: </myTag>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	JLog(@"didEndElement: %@", elementName);
	
	canAppend = NO;
	
	//primary objects...
	
	if ([elementName isEqualToString:@"retorts"]) 
	{
		return;
	}
	//===================
	// RETORT node...
	//===================
	if ([elementName isEqualToString:@"retort"]) 
	{
		JLog(@"Adding %@ to retorts array: ", [self.currentRetort description]);
		[self.retorts addObject:self.currentRetort];
		self.currentRetort = nil; //same as release - should remain retained by retorts array.
		return;
	}
	
	if ([elementName isEqualToString:@"content"]) {
		self.currentRetort.content = self.currentTextNode;
		return;
	}
	
	if ([elementName isEqualToString:@"positive"]) {
		self.currentRetort.positive = [self.currentTextNode intValue];
		return;
	}
	if ([elementName isEqualToString:@"negative"]) {
		self.currentRetort.negative = [self.currentTextNode intValue];
		return;
	}
//	if ([elementName isEqualToString:@"rank"]) {
//		self.currentRating.rank = [self.currentTextNode floatValue];
//		return;
//	}
//	if ([elementName isEqualToString:@"rating"]) {
//		self.currentRetort.rating = self.currentRating;
//		self.currentRating = nil; //same as release - should be retained by currentRetort.
//		JLog(@"Added rating");
//		return;
//	}
	
	
	
	//===================
	// TAGS node...
	//===================
	if ([elementName isEqualToString:@"tag"]) {
		JLog(@"Adding tag to currentRetort");
		self.currentTag = nil; //same as release - should be retained by currentRetort tag array.
		return;
	}
	
	if ([elementName isEqualToString:@"tags"]) {
		//array - already held by currentRetort object or tags array...
		return;
	}
	
	
	//12.24.2008: Added to account form change in Tags xml schema.
	if ([elementName isEqualToString:@"value"]) {
		self.currentTag.value = self.currentTextNode;
		if (self.currentRetort != nil) {
			[self.currentRetort.tags addObject:self.currentTag];
		} else {
			//parsing tags url because there is no retort nodes
			[self.tags addObject:self.currentTag];
		}
		return;
	}
	
	
	//======================
	// ATTRIBUTIONS node...
	//======================
	if ([elementName isEqualToString:@"who"]) 
	{
		self.currentAttribution.who = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"what"]) 
	{
		self.currentAttribution.what = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"when"]) 
	{
		self.currentAttribution.when = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"where"]) 
	{
		self.currentAttribution.where = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"how"]) 
	{
		self.currentAttribution.how = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"attribution"]) 
	{
		self.currentRetort.attribution = self.currentAttribution;
		self.currentAttribution = nil; //same as release - should be retained by currentRetort.
		JLog(@"Added attribution");
		return;
	}
	

	JLog(@"Unknown element: %@.", elementName);
}

// Called as periodically as the parser gets the data between a given tag.  This may be called more than once for a given element, so append the data!
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	JLog(@"foundCharacters: %@", string);
	
	if (canAppend) {
		[self.currentTextNode appendString:string];
	}
}

//Optional - use this if there is any clean up or call back (i.e. if we use notifications)
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	JLog(@"parserDidEndDocument");
}

#pragma mark -
#pragma mark Cleanup
- (void) dealloc {
	self.currentTag = nil;
	self.currentRetort = nil;
	//self.currentRating = nil;
	self.currentAttribution = nil;
	self.retorts = nil;
	//self.tags = nil;
	self.currentTextNode = nil;
	
	[super dealloc];
}

@end
