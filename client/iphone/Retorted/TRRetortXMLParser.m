//
//  TRRetortXMLParser.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetortXMLParser.h"
#import "TRRetort.h"
#import "Constants.h"

// Message listed to by TRReportFacade
// Message sent to NC by TRRetortXMLParser
NSString * const TRXMLRetortDataFinishedLoadingNotification = @"TRRawRetortDataFinishedLoading"; //Listened by RetortFacade


@implementation TRRetortXMLParser
@synthesize currentProperty;
@synthesize currentRating, currentRetort, currentTag, currentAttribution;
@synthesize retorts, tags;
@synthesize canAppend;


- (id)init {
	if (![super init]) {
		return nil;
	}
	
	self.retorts = [[NSMutableArray alloc] init];
	self.tags = [[NSMutableArray alloc] init];
	
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
	self.currentProperty = [[NSMutableString alloc] init];
	
}


// Called when the parser encounters a new element.  For Example: <myTag>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	NSLog(@"RetortXMLParser: didStartElement: %@", elementName);
	
	canAppend = YES;
	self.currentProperty = [[NSMutableString alloc] init];
		
	// Primary objects...
	if ([elementName isEqualToString:@"retort"]) {
		// 1. create Retort Dictionary object and add it as active
		// 2. NSString *idAtt = [attributeDict valueForKey:@"id"];
		self.currentRetort = [[NSMutableDictionary alloc] init];

		[self.currentRetort setObject:[attributeDict valueForKey:@"id"] forKey:@"id"];
		[self.currentProperty release];
		return;
	}
	
	
	if ([elementName isEqualToString:@"tag"]) {
		// 1. create Retort Dictionary object and add it as active
		// 2. NSString *idAtt = [attributeDict valueForKey:@"id"];
		self.currentTag = [[NSMutableDictionary alloc] init];
		[self.currentTag setObject:[attributeDict valueForKey:@"id"] forKey:@"id"];
		[self.currentTag setObject:[attributeDict valueForKey:@"weight"] forKey:@"votes"];
		[self.currentProperty release];
		return;
	}
	
	
}

// Called when the parser encounters the closing tag of an element.  For Example: </myTag>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSLog(@"RetortXMLParser: didEndElement: %@", elementName);
	
	canAppend = NO;
	
	//primary objects...
	if ([elementName isEqualToString:@"retort"]) {
		
		TRRetort *retort = [[TRRetort alloc] initWithDictionary:currentRetort];
		[self.retorts addObject:retort];
		NSLog(@"RetortXMLParser: adding %@ to retorts array: ", [retort description]);
		
		[retort release];
		[self.currentRetort release];
		return;
	}
	
	if ([elementName isEqualToString:@"content"]) {
		[self.currentRetort setObject:self.currentProperty forKey:@"content"];
		[self.currentProperty release];
		return;
	}
	
	
	if ([elementName isEqualToString:@"tag"]) {
		[self.currentTag setObject:self.currentProperty forKey:@"value"];
		[self.tags addObject:self.currentTag];
		NSLog(@"RetortXMLParser: adding tag to currentRetort");
		[self.currentTag release];
		[self.currentProperty release];
		return;
	}
	
	if ([elementName isEqualToString:@"tags"]) {
		[self.currentRetort setObject:self.tags forKey:@"tags"];
		[self.tags release];
		return;
	}

	NSLog(@"RetortXMLParser: Unknown element: %@.", elementName);
}

// Called as periodically as the parser gets the data between a given tag.  This may be called more than once for a given element, so append the data!
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSLog(@"RetortXMLParser: foundCharacters: %@", string);
	
	if (canAppend) {
		[self.currentProperty appendString:string];
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
	self.currentTag = nil;
	self.currentRetort = nil;
	self.currentRating = nil;
	self.currentAttribution = nil;
	self.retorts = nil;
	self.tags = nil;
	self.currentProperty = nil;
	
	[super dealloc];
}

@end
