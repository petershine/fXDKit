//
//  FXDNumber.m

//
//  Created by petershine on 8/30/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDNumber.h"


#pragma mark - Private interface
@interface FXDNumber (Private)
@end


#pragma mark - Public implementation
@implementation FXDNumber

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (id)init {
	self = [super init];

	if (self) {
		// Primitives

		// Instance variables

		// Properties
	}

	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSNumber (Added)
- (NSString*)byteUnitFormatted {
	
	NSString *formattedString = nil;

	NSInteger kiloUnit = 1024;

	NSInteger fileSize = [self integerValue];

	if (fileSize < kiloUnit) {
		formattedString = [NSString stringWithFormat:@"%d B", fileSize];
	}
	else if (fileSize < (kiloUnit*kiloUnit)) {
		formattedString = [NSString stringWithFormat:@"%d KB", (fileSize /kiloUnit)];
	}
	else if (fileSize < (kiloUnit*kiloUnit*kiloUnit)) {
		formattedString = [NSString stringWithFormat:@"%d MB", (fileSize /(kiloUnit*kiloUnit))];
	}
	else if (fileSize < (kiloUnit*kiloUnit*kiloUnit*kiloUnit)) {
		formattedString = [NSString stringWithFormat:@"%d GB", (fileSize /(kiloUnit*kiloUnit*kiloUnit))];
	}

	return formattedString;
}

@end
