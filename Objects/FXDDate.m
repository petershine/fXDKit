//
//  FXDDate.m
//
//
//  Created by petershine on 5/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDDate.h"


#pragma mark - Public implementation
@implementation FXDDate


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end

#pragma mark - Category
@implementation NSDate (Added)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate {
	if (localDate == nil) {
		localDate = [self date];
	}

	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	
    NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:UTCtimezone];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
    NSString *shortUTCdateString = [dateFormatter stringFromDate:localDate];
	
    return shortUTCdateString;
}

+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate {
	if (UTCdate == nil) {
		UTCdate = [self date];
	}
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	
    NSTimeZone *UTCtimezone = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:UTCtimezone];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	
    NSString *shortLocalDateString = [dateFormatter stringFromDate:UTCdate];
	
    return shortLocalDateString;
}

#pragma mark -
- (NSInteger)yearValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
	
	return [dateComponents year];
}

- (NSInteger)monthValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
	
	return [dateComponents month];
}

- (NSInteger)dayValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
	
	return [dateComponents day];
}

#pragma mark -
- (NSString*)shortMonthString {

	NSString *monthString = nil;

	switch ([self monthValue]) {
		case 1:
			monthString = @"Jan";
			break;

		case 2:
			monthString = @"Feb";
			break;

		case 3:
			monthString = @"Mar";
			break;

		case 4:
			monthString = @"Apr";
			break;

		case 5:
			monthString = @"May";
			break;

		case 6:
			monthString = @"Jun";
			break;

		case 7:
			monthString = @"Jul";
			break;

		case 8:
			monthString = @"Aug";
			break;

		case 9:
			monthString = @"Sep";
			break;

		case 10:
			monthString = @"Oct";
			break;

		case 11:
			monthString = @"Nov";
			break;

		case 12:
			monthString = @"Dec";
			break;
			
		default:
			break;
	}

	return monthString;
}

- (NSString*)weekdayString {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];

	NSString *weekdayString = nil;

	switch ([dateComponents weekday]) {
		case 0:
			break;

		case 1:
			weekdayString = @"Sunday";
			break;

		case 2:
			weekdayString = @"Monday";
			break;

		case 3:
			weekdayString = @"Tuesday";
			break;

		case 4:
			weekdayString = @"Wednesday";
			break;

		case 5:
			weekdayString = @"Thursday";
			break;

		case 6:
			weekdayString = @"Friday";
			break;

		case 7:
			weekdayString = @"Saturday";
			break;

		default:
			break;
	}

	return weekdayString;
}

#pragma mark -
- (NSInteger)hourValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self];

	return [dateComponents hour];
}

- (NSInteger)minuteValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self];

	return [dateComponents minute];
}

- (NSInteger)secondValue {
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self];

	return [dateComponents second];
}


- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate {
	BOOL isSame = NO;
	
	if ([self yearValue] == [anotherDate yearValue]
		&& [self monthValue] == [anotherDate monthValue]
		&& [self dayValue] == [anotherDate dayValue]) {
		isSame = YES;
	}
	
	return isSame;
}

@end