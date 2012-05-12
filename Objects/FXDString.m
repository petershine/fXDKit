//
//  FXDString.m
//
//
//  Created by Anonymous on 3/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDString.h"


#pragma mark - Private interface
@interface FXDString (Private)
@end


#pragma mark - Public implementation
@implementation FXDString

#pragma mark Static objects

#pragma mark Synthesizing
// Properties

// Controllers


#pragma mark - Memory management
- (void)dealloc {	
	// Instance variables
	
	// Properties
	
    // Controllers
	
	[super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
		
        // Controllers
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties

// Controllers


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSString (Added)
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
		
		if ([alignedParagraph isEqualToString:@""] == NO) {
			alignedParagraph = [alignedParagraph stringByAppendingString:@"\n"];
		}
		
		FXDLog(@"modifiedComponent: \"%@\"", modifiedComponent);
		
		alignedParagraph = [alignedParagraph stringByAppendingString:modifiedComponent];
	}
	
	return alignedParagraph;
}


@end