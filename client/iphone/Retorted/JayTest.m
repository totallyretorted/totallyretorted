//
//  JayTest.m
//  Retorted
//
//  Created by Jay Walker on 12/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JayTest.h"
#import "TRRetort.h"
#import "TRTag.h"
#import "TRAttribution.h"
#import "TRRating.h"

@implementation JayTest

@synthesize retorts;
@synthesize currentRetort;
@synthesize currentTag;
@synthesize currentTextNode;
@synthesize canAppend;

- (id)init {
	if (![super init]) {
		return nil;
	}
	
	return self;
}

#pragma mark Public Method
- (void)parseRetortXML:(NSData *)xmlData parseError:(NSError **)error {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	[parser setDelegate:self];
	
	[parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
	NSLog(@"RetortXMLParser: Begin Parsing");
	[parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
    }
	
	
    [parser release];
}

#pragma mark -
#pragma mark NSXMLParser Delegate Methods

// Optional:  Use this if there is any preprocessing necessary that isn't handled in the init: method.
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"RetortXMLParser: started parsing document");
}


/*
 <retort id="1">
 
	<content>
	Too bad drinking Scotch isn't a paying job or Kenny's dad would be a millionaire!
	</content>
 
	<attribution id="1">
		<who>Eric Cartman</who>
		<when>2008-12-12</when>
		<where>South Park</where>
	</attribution>
 
	<rating>
		<positive>10</positive>
		<negative>5</negative>
		<rating>0.666666666666667</rating>
	</rating>
 
	<tags>
		<tag weight="0" id="1">south_park</tag>
		<tag weight="0" id="3">cartman</tag>
	</tags>
 </retort>
*/


// Called when the parser encounters a new element.  For Example: <myTag>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	NSLog(@"RetortXMLParser: didStartElement: %@", elementName);
	
	//canAppend and currentTextNode are used to store the contents of elements. 
	canAppend = YES;
	if (self.currentTextNode != nil)
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
	
	
	if ([elementName isEqualToString:@"retort"]) 
	{
		//create a retort and add it to the retorts array
		//set the current retort pointer
		//set the id value from the id attr
		
		TRRetort* r = [[TRRetort alloc] init];
		[self.retorts addObject:r];
		self.currentRetort = r;
		
		NSString* pid = [attributeDict valueForKey:@"id"];
		if (pid != nil) 
		{
			//TODO: fix! r.primaryId = [pid intValue];
		}
		
		[r release]; 
		return;
	}
	
	
	
	if ([elementName isEqualToString:@"tags"]) 
	{
		//create a tags array and associate it with the current retort
		NSMutableArray* ts = [[NSMutableArray alloc] init];
		self.currentRetort.tags = ts;
		
		[ts release];
		return;
	}
	
	
	if ([elementName isEqualToString:@"tag"]) 
	{
		//create a tag and add it to the current retort tag array
		//set the current tag pointer
		TRTag* tag = [[TRTag alloc] init];
		[self.currentRetort.tags addObject:tag];
		self.currentTag = tag;
		
		NSString* weight = [attributeDict valueForKey:@"weight"];
		if (weight != nil) 
		{
			tag.votes = [weight intValue];
		}

		NSString* pid = [attributeDict valueForKey:@"id"];
		if (pid != nil) 
		{
			//TODO: fix! tag.primaryId = [pid intValue];
		}
		
		[tag release];
		return;
	}

	
	if ([elementName isEqualToString:@"attribution"]) 
	{
		//create an attribution and add it to the current retort
		TRAttribution* attr = [[TRAttribution alloc] init];
		self.currentRetort.attribution = attr;
		
		[attr release];
		return;
	}

	//TODO: rating and subtags. rating has a child element with same name. that should be corrected.
	NSLog(@"RetortXMLParser: Unknown element: %@.", elementName);

	return;
}

// Called when the parser encounters the closing tag of an element.  For Example: </myTag>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSLog(@"RetortXMLParser: didEndElement: %@", elementName);
	
	canAppend = NO;
	
	if ([elementName isEqualToString:@"retorts"]) 
	{
		return;
	}
	
	if ([elementName isEqualToString:@"retort"]) 
	{
		return;
	}
	
	if ([elementName isEqualToString:@"content"]) 
	{
		self.currentRetort.content = self.currentTextNode;
		return;
	}
	
	if ([elementName isEqualToString:@"who"]) 
	{
		self.currentRetort.attribution.who = self.currentTextNode;
		return;
	}
	
	if ([elementName isEqualToString:@"tags"]) 
	{
		return;
	}
	
	
	if ([elementName isEqualToString:@"tag"]) 
	{
		self.currentTag.value = self.currentTextNode;
		return;
	}
	
	
	if ([elementName isEqualToString:@"attribution"]) 
	{
		return;
	}
	
	if ([elementName isEqualToString:@"who"]) 
	{
		self.currentRetort.attribution.who = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"what"]) 
	{
		self.currentRetort.attribution.what = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"when"]) 
	{
		self.currentRetort.attribution.when = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"where"]) 
	{
		self.currentRetort.attribution.where = self.currentTextNode;
		return;
	}
	if ([elementName isEqualToString:@"how"]) 
	{
		self.currentRetort.attribution.how = self.currentTextNode;
		return;
	}
	
	
	NSLog(@"RetortXMLParser end element: Unknown element: %@.", elementName);
	return;
}

// Called as periodically as the parser gets the data between a given tag.  This may be called more than once for a given element, so append the data!
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSLog(@"RetortXMLParser: foundCharacters: %@", string);
	
	if (canAppend) {
		[self.currentTextNode appendString:string];
	}
}

//Optional - use this if there is any clean up or call back (i.e. if we use notifications)
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"RetortXMLParser: parserDidEndDocument");
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSLog(@"RetortXMLParser: Sending finished notification");
	NSLog(@"RetortXMLParser: total retort objects: %d", self.retorts.count);
	[nc postNotificationName:TRXMLRetortDataFinishedLoadingNotification object:self];
	
	NSLog(@"RetortXMLParser: callback after xml parse complete notification");	
}

#pragma mark -
#pragma mark Cleanup
- (void) dealloc {
	self.retorts = nil;
	self.currentRetort = nil;
	self.currentTag = nil;
	self.currentTextNode = nil;

	[super dealloc];
}

@end
