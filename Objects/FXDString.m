//
//  FXDString.m
//
//
//  Created by petershine on 3/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDString.h"


@implementation FXDString
@end


#pragma mark - Category
@implementation NSString (Added)
+ (NSString*)uniqueKeyFrom:(Float64)doubleValue {
	//MARK: Use 32 as the string length
	NSString *digits = [[NSString stringWithFormat:@"%12ld", (long)doubleValue] stringByReplacingOccurrencesOfString:@" " withString:@"0"];
	NSString *decimals = [[[NSString stringWithFormat:@"%.20f", (doubleValue -((NSInteger)doubleValue))] componentsSeparatedByString:@"."] lastObject];

	return [NSString stringWithFormat:@"%@%@", digits, decimals];
}

+ (NSString*)uniqueFilenameWithWithPrefix:(NSString*)prefix forType:(CFStringRef)type {

	NSString *uniqueKey = [NSString uniqueKeyFrom:[[NSDate date] timeIntervalSince1970]];

	NSString *filename = [self filenameWithWithPrefix:prefix withUniqueKey:uniqueKey forType:type];

	return filename;
}

+ (NSString*)filenameWithWithPrefix:(NSString*)prefix withUniqueKey:(NSString*)uniqueKey forType:(CFStringRef)type {
	NSString *extension = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(type, kUTTagClassFilenameExtension));

	NSString *filename = [NSString stringWithFormat:@"%@_%@.%@", prefix, uniqueKey, extension];

	return filename;
}

#pragma mark -
- (NSString*)leftAlignedParagraph {	FXDLog_DEFAULT;
	NSArray *components = [self componentsSeparatedByString:@"\n"];
	
	// Find the longest component
	NSInteger longestLength = 0;
	
	for (NSString *component in components) {
		if ([component length] > longestLength) {
			longestLength = [component length];
		}
	}
	
	NSString *alignedParagraph = @"";
	
	for (NSString *component in components) {
		NSString *modifiedComponent = component;
		
		if ([component length] < longestLength) {
			
			NSInteger addedSpaceLength = longestLength -[component length];
			
			for (NSInteger i = 0 ; i < addedSpaceLength; i++) {
				modifiedComponent = [modifiedComponent stringByAppendingString:@" "];
			}
		}
		
		if ([alignedParagraph length] > 0) {
			alignedParagraph = [alignedParagraph stringByAppendingString:@"\n"];
		}
		
		FXDLogObject(modifiedComponent);
		
		alignedParagraph = [alignedParagraph stringByAppendingString:modifiedComponent];
	}
	
	return alignedParagraph;
}

- (NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator {
	NSArray *comps = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSMutableArray *nonemptyComps = [[NSMutableArray alloc] init];

	// only copy non-empty entries
	for (NSString *oneComp in comps) {
		if (([oneComp isEqualToString:@""] == NO)) {
			[nonemptyComps addObject:oneComp];
		}

	}

	return [nonemptyComps componentsJoinedByString:seperator];  // already marked as autoreleased
}

- (NSString*)replacedSelf {
	return [self stringByReplacingOccurrencesOfString:@"self." withString:@""];
}

@end