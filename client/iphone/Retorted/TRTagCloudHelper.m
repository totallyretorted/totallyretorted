//
//  TRTagCloudHelper.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRTagCloudHelper.h"
#import "TRTag.h"
#import "SortMethods.h"

const NSInteger quantas = 5;

@implementation TRTagCloudHelper
@synthesize tags;

- (id)initWithTagsArray:(NSArray *)tagArray {
	if (![super init])
		return nil;

	self.tags = tagArray;
	
	return self;
}


//takes a Tag Array as input and calculates the tagCloud value and returns an ordered array based on the preferred sort order
- (NSArray* ) levelCloud:(NSArray*) src param2:(NSInteger) seq
{
	return [[NSArray alloc]init];
}


- (NSString *)tagCloud {
	NSMutableString *html = nil;
	int fontSize = 100;

	
	for (TRTag *aTag in tags) {
		
		//NSLog(@"element: %@", element);
		//font-size percentage 200% to 50%
		switch ([aTag.tagCloudValue intValue]) {
			case 0:
				fontSize = 50;
				break;
			case 1: 
				fontSize = 75;
				break;
			case 2:
				fontSize = 100;
				break;
			case 3:
				fontSize = 125;
				break;
			case 4:
				fontSize = 150;
			default:
				break;
		}
		
		//tag:id, font-size (weight), tag.value, 
		[html appendFormat:@"<a href=\"tag:%d\" style=\"font-size: %d\%\">%@</a><&nbsp;&nbsp;&nbsp;", 
		 aTag.primaryId, 
		 fontSize, 
		 aTag.value];
		
	}
	
	//TODO: memory leak?
	return html;
}

- (NSString *)htmlTagCloudWrapper:(NSString *)content {
	NSString *header = @"<html><body><div>";
	NSString *footer = @"</div></body></html>";
	
	
	return [NSString stringWithFormat:@"%@%@%@", header, content, footer];
}

- (void)dealloc {
	[super dealloc];
}


@end
