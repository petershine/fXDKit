//
//  FXDDate.m
//
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDDate.h"


@implementation FXDDate
@end


#pragma mark - Categories
@implementation NSDate (Added)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate {
	if (localDate == nil) {
		localDate = [self date];
	}

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

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

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    NSTimeZone *UTCtimezone = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:UTCtimezone];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *shortLocalDateString = [dateFormatter stringFromDate:UTCdate];

    return shortLocalDateString;
}

#pragma mark -
- (NSInteger)yearValue {
	NSDateComponents *dateComponents = nil;

#ifdef __IPHONE_8_0
	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
	}
#else
	dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
#endif

	return [dateComponents year];
}

- (NSInteger)monthValue {
	NSDateComponents *dateComponents = nil;

#ifdef __IPHONE_8_0
	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
	}
#else
	dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
#endif

	return [dateComponents month];
}

- (NSInteger)dayValue {
	NSDateComponents *dateComponents = nil;

#ifdef __IPHONE_8_0
	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
	}
#else
	dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
#endif

	return [dateComponents day];
}

#pragma mark -
- (NSString*)shortMonthString {

	NSArray *monthStringArray = @[@"",
								  @"Jan",
								  @"Feb",
								  @"Mar",
								  @"Apr",
								  @"May",
								  @"Jun",
								  @"Jul",
								  @"Aug",
								  @"Sep",
								  @"Oct",
								  @"Nov",
								  @"Dec"];

	NSString *monthString = monthStringArray[[self monthValue]];

	return monthString;
}

- (NSString*)weekdayString {

	NSArray *weekdayStringArray = @[@"",
									@"Sunday",
									@"Monday",
									@"Tuesday",
									@"Wednesday",
									@"Thursday",
									@"Friday",
									@"Saturday"];


	NSDateComponents *dateComponents = nil;

#ifdef __IPHONE_8_0
	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
	}
#else
	dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
#endif


	NSString *weekdayString = weekdayStringArray[[dateComponents weekday]];

	return weekdayString;
}

#pragma mark -
- (NSInteger)hourValue {
	NSDateComponents *dateComponents = nil;

#ifdef __IPHONE_8_0
	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self];
	}
#else
	dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self];
#endif

	return [dateComponents hour];
}

- (NSInteger)minuteValue {
	NSDateComponents *dateComponents = nil;

#ifdef __IPHONE_8_0
	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self];
	}
#else
	dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self];
#endif

	return [dateComponents minute];
}

- (NSInteger)secondValue {
	NSDateComponents *dateComponents = nil;

#ifdef __IPHONE_8_0
	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self];
	}
#else
	dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self];
#endif

	return [dateComponents second];
}

#pragma mark -
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
