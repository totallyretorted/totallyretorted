//
//  TRRetortXMLParser.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetortXMLParser.h"


@implementation TRRetortXMLParser
@synthesize currentProperty;
@synthesize currentRating, currentRetort, currentTag, currentAttribution;
@synthesize retorts;
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
	self.currentProperty = [[NSMutableString alloc] init];
	
}


// Called when the parser encounters a new element.  For Example: <myTag>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	NSLog(@"RetortXMLParser: didStartElement: %@", elementName);
	
	//an example of getting an element's attribute:
	//[self.currentRetort setObject:[attributeDict valueForKey:@"id"] forKey:@"id"];
}

// Called when the parser encounters the closing tag of an element.  For Example: </myTag>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSLog(@"RetortXMLParser: didEndElement: %@", elementName);
}

// Called as periodically as the parser gets the data between a given tag.  This may be called more than once for a given element, so append the data!
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSLog(@"RetortXMLParser: foundCharacters: %@", string);
}

//Optional - use this if there is any clean up or call back (i.e. if we use notifications)
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"RetortXMLParser: parserDidEndDocument");
}

#pragma mark -
#pragma mark Cleanup
- (void) dealloc {
	self.currentTag = nil;
	self.currentRetort = nil;
	self.currentRating = nil;
	self.currentAttribution = nil;
	self.retorts = nil;
	
	[super dealloc];
}

@end
