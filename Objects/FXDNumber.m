//
//  FXDNumber.m

//
//  Created by petershine on 8/30/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDNumber.h"


#pragma mark - Public implementation
@implementation FXDNumber


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

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

- (NSString*)timerUnitFormatted {
	NSString *formattedString = nil;

	double timerInterval = [self doubleValue];

	NSInteger seconds = (NSInteger)timerInterval % 60;

	if (seconds < 10) {
		formattedString = [NSString stringWithFormat:@"0%d", seconds];
	}
	else {
		formattedString = [NSString stringWithFormat:@"%d", seconds];
	}


	NSInteger minutes = (NSInteger)timerInterval / 60;

	if (minutes < 60) {
		formattedString = [NSString stringWithFormat:@"%d:%@", minutes, formattedString];

		return formattedString;
	}


	NSInteger hours = minutes / 60;
	minutes = minutes % 60;

	if (minutes < 10) {
		formattedString = [NSString stringWithFormat:@"0%d:%@", minutes, formattedString];
	}
	else {
		formattedString = [NSString stringWithFormat:@"%d:%@", minutes, formattedString];
	}

	formattedString = [NSString stringWithFormat:@"%d:%@", hours, formattedString];
	

	return formattedString;
}

@end
