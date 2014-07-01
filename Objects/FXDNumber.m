//
//  FXDNumber.m

//
//  Created by petershine on 8/30/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDNumber.h"


@implementation FXDNumber
@end


#pragma mark - Category
@implementation NSNumber (Essential)
- (NSString*)byteUnitFormatted {
	
	NSString *formattedString = nil;

	NSInteger kiloUnit = 1024;

	NSInteger fileSize = [self integerValue];

	if (fileSize < kiloUnit) {
		formattedString = [NSString stringWithFormat:@"%ld B", (long)fileSize];
	}
	else if (fileSize < (kiloUnit*kiloUnit)) {
		formattedString = [NSString stringWithFormat:@"%ld KB", (long)(fileSize /kiloUnit)];
	}
	else if (fileSize < (kiloUnit*kiloUnit*kiloUnit)) {
		formattedString = [NSString stringWithFormat:@"%ld MB", (long)(fileSize /(kiloUnit*kiloUnit))];
	}
	else if (fileSize < (kiloUnit*kiloUnit*kiloUnit*kiloUnit)) {
		formattedString = [NSString stringWithFormat:@"%ld GB", (long)(fileSize /(kiloUnit*kiloUnit*kiloUnit))];
	}

	return formattedString;
}

- (NSString*)timerUnitFormatted {
	NSString *formattedString = nil;

	Float64 timerInterval = [self doubleValue];

	NSInteger seconds = (NSInteger)timerInterval % 60;

	if (seconds < 10) {
		formattedString = [NSString stringWithFormat:@"0%ld", (long)seconds];
	}
	else {
		formattedString = [NSString stringWithFormat:@"%ld", (long)seconds];
	}


	NSInteger minutes = (NSInteger)timerInterval / 60;

	if (minutes < 60) {
		formattedString = [NSString stringWithFormat:@"%ld:%@", (long)minutes, formattedString];

		return formattedString;
	}


	NSInteger hours = minutes / 60;
	minutes = minutes % 60;

	if (minutes < 10) {
		formattedString = [NSString stringWithFormat:@"0%ld:%@", (long)minutes, formattedString];
	}
	else {
		formattedString = [NSString stringWithFormat:@"%ld:%@", (long)minutes, formattedString];
	}

	formattedString = [NSString stringWithFormat:@"%ld:%@", (long)hours, formattedString];
	

	return formattedString;
}

@end
