

#import "FXDString.h"


@implementation NSString (Essential)
+ (NSString*)uniqueKeyFrom:(Float64)doubleValue {
	//NOTE: Use 32 as the string length
	NSString *digits = [[NSString stringWithFormat:@"%12ld", (long)doubleValue] stringByReplacingOccurrencesOfString:@" " withString:@"0"];
	NSString *decimals = [[NSString stringWithFormat:@"%.20f", (doubleValue -((NSInteger)doubleValue))] componentsSeparatedByString:@"."].lastObject;

	return [NSString stringWithFormat:@"%@%@", digits, decimals];
}

+ (NSString*)uniqueFilenameWithWithPrefix:(NSString*)prefix forType:(CFStringRef)type {

	NSString *uniqueKey = [NSString uniqueKeyFrom:[NSDate date].timeIntervalSince1970];

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
		if (component.length > longestLength) {
			longestLength = component.length;
		}
	}
	
	NSString *alignedParagraph = @"";
	
	for (NSString *component in components) {
		NSString *modifiedComponent = component;
		
		if (component.length < longestLength) {
			
			NSInteger addedSpaceLength = longestLength -component.length;
			
			for (NSInteger i = 0 ; i < addedSpaceLength; i++) {
				modifiedComponent = [modifiedComponent stringByAppendingString:@" "];
			}
		}
		
		if (alignedParagraph.length > 0) {
			alignedParagraph = [alignedParagraph stringByAppendingString:@"\n"];
		}
		
		FXDLogObject(modifiedComponent);
		
		alignedParagraph = [alignedParagraph stringByAppendingString:modifiedComponent];
	}
	
	return alignedParagraph;
}

- (NSString*)stringByCompressingWhitespaceTo:(NSString*)seperator {

	NSArray *separated = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	NSMutableArray *combined = [[NSMutableArray alloc] init];

	for (NSString *component in separated) {
		if ((component.length > 0)) {
			[combined addObject:component];
		}
	}

	return [combined componentsJoinedByString:seperator];
}

- (NSString*)stringByAppendURLparameters:(NSDictionary*)parameters {
	if (parameters.count == 0) {
		return self;
	}


	NSMutableArray *parameterComponents = [[NSMutableArray alloc] initWithCapacity:0];

	for (NSString *key in parameters.allKeys) {
		id value = parameters[key];

		if ([value isKindOfClass:[NSString class]]) {
			NSString *component = [NSString stringWithFormat:@"%@=%@", key, value];
			[parameterComponents addObject:component];
		}
	}

	if (parameterComponents.count == 0) {
		return self;
	}


	NSString *joinedParameters = [parameterComponents componentsJoinedByString:@"&"];
	NSString *queryString = [NSString stringWithFormat:@"%@?%@", self, joinedParameters];

	queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

	return queryString;
}

@end
