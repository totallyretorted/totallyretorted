//
//  TRRetort.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRRetort.h"
#import "TRAttribution.h"
#import "TRRating.h"
#import "TRTag.h"

@implementation TRRetort
@synthesize content;
@synthesize attribution, tags, rating;
@synthesize primaryId;

-(id)init {
	if (![super init])
		return nil;
	
	return self;
}

-(id)initWithDictionary:(NSDictionary *)aDictionary {
	if (![super init])
		return nil;
	
	self.tags = [[NSMutableArray alloc] init];
	self.primaryId = [aDictionary valueForKey:@"id"];
	self.content = [aDictionary valueForKey:@"content"];
	
	//handle tags...
	NSArray *someTags = [aDictionary valueForKey:@"tags"];
	for(NSDictionary *tagDictionary in someTags) {
		TRTag *aTag = [[TRTag alloc] initWithDictionary:tagDictionary];
		[self.tags addObject:aTag];
		[aTag release];
	}
	
	//handle rating...
	self.rating = [aDictionary valueForKey:@"rating"];

	NSLog(@"TRRetort: initWithDictionary - %@", content);
	return self;
}

- (NSArray *)attributionListAsStringArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	if ([self.attribution.who length] > 0) {
		[array addObject:self.attribution.who];
	}
	
	if ([self.attribution.what length] > 0) {
		[array addObject:self.attribution.what];
	}
	if ([self.attribution.when length] > 0) {
		[array addObject:self.attribution.when];
	}
	if ([self.attribution.where length] > 0) {
		[array addObject:self.attribution.where];
	}
	if ([self.attribution.how length] > 0) {
		[array addObject:self.attribution.how];
	}
	
	[array autorelease];
	return array;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"Retort Id: %@ has %d tags", self.primaryId, [self.tags count]];
}

- (void)dealloc {
	[content release];
	[attribution release];
	[tags release];
	[rating release];
	[primaryId release];
	
	[super dealloc];
}


@end
