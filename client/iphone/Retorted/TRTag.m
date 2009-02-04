//
//  TRTag.m
//  Retorted
//
//  Created by B.J. Ray on 12/9/08.
//  Copyright 2008 Forward Echo, LLC. All rights reserved.
//

#import "TRTag.h"
#import "TRRating.h"

@interface TRTag()
- (BOOL)isEqualTRTagObject:(TRTag *)aTag;
@end


@implementation TRTag
@synthesize value;
@synthesize weight;
@synthesize tagCloudValue;
@synthesize primaryId;

- (id) init {
	return [self initWithId:[NSNumber numberWithInt: -1] value:@"" weight:0 tagCloudValue:0];
}

- (id) initWithId:(NSNumber *)aPrimaryId value:(NSString *) aValue {
	
	return [self initWithId:aPrimaryId value:aValue weight:0 tagCloudValue:0];
}

//Designated initializer
- (id)initWithId:(NSNumber *)aPrimaryId value:(NSString *)aValue weight:(NSInteger)voteCount tagCloudValue:(NSInteger)cloudValue {
	if (![super init])
		return nil;
	
	self.primaryId = aPrimaryId;
	self.value = aValue;
	self.weight = voteCount;
	self.tagCloudValue = cloudValue;
	
	return self;
}



- (CGSize)sizeOfNonWrappingTagWithFont:(UIFont *)font {
	return [self.value sizeWithFont:font];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@", self.value];
}

- (BOOL)isEqual:(id)someObject {
	if (someObject == self) {
		return YES;
	}
	if (!someObject || ![someObject isKindOfClass:[self class]]) {
		return NO;
	}
	
	return [self isEqualTRTagObject: someObject];
}

- (BOOL)isEqualTRTagObject:(TRTag *)aTag {
	if (self == aTag) {
		return YES;
	}
	if ([self.primaryId isEqual:aTag.primaryId]) {
		return YES;
	}
    return NO;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [self.value hash];
    hash += [self.primaryId hash];
    return hash;
}
 
- (void)dealloc {
	[super dealloc];
}
@end
