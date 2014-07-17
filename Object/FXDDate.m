

#import "FXDDate.h"


@implementation NSDate (Essential)
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

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
	}

	return [dateComponents year];
}

- (NSInteger)monthValue {
	NSDateComponents *dateComponents = nil;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self];
	}

	return [dateComponents month];
}

- (NSInteger)dayValue {
	NSDateComponents *dateComponents = nil;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self];
	}

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

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
	}


	NSString *weekdayString = weekdayStringArray[[dateComponents weekday]];

	return weekdayString;
}

#pragma mark -
- (NSInteger)hourValue {
	NSDateComponents *dateComponents = nil;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:self];
	}

	return [dateComponents hour];
}

- (NSInteger)minuteValue {
	NSDateComponents *dateComponents = nil;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:self];
	}

	return [dateComponents minute];
}

- (NSInteger)secondValue {
	NSDateComponents *dateComponents = nil;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self];
	}
	else {
		dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self];
	}

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
