

#import "FXDDate.h"


@implementation NSDate (Essential)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate {
	if (localDate == nil) {
		localDate = [self date];
	}

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
    dateFormatter.timeZone = UTCtimezone;
	dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSString *shortUTCdateString = [dateFormatter stringFromDate:localDate];

    return shortUTCdateString;
}

+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate {

	NSString *localDateText = [self localDateTextForUTCdate:UTCdate withFormat:@"yyyy-MM-dd"];

	return localDateText;
}

+ (NSString*)localDateTextForUTCdate:(NSDate*)UTCdate withFormat:(NSString*)format {

	if (UTCdate == nil) {
		UTCdate = [self date];
	}

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

	NSTimeZone *UTCtimezone = [NSTimeZone defaultTimeZone];
	dateFormatter.timeZone = UTCtimezone;
	dateFormatter.dateFormat = format;

	NSString *localDateText = [dateFormatter stringFromDate:UTCdate];

	return localDateText;
}

#pragma mark -
- (NSInteger)yearValue {
	NSDateComponents *dateComponents = nil;

	dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];

	return dateComponents.year;
}

- (NSInteger)monthValue {
	NSDateComponents *dateComponents = nil;

	dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self];

	return dateComponents.month;
}

- (NSInteger)dayValue {
	NSDateComponents *dateComponents = nil;

	dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self];

	return dateComponents.day;
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

	NSString *monthString = monthStringArray[self.monthValue];

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

	dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];


	NSString *weekdayString = weekdayStringArray[dateComponents.weekday];

	return weekdayString;
}

#pragma mark -
- (NSInteger)hourValue {
	NSDateComponents *dateComponents = nil;

	dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self];

	return dateComponents.hour;
}

- (NSInteger)minuteValue {
	NSDateComponents *dateComponents = nil;

	dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self];

	return dateComponents.minute;
}

- (NSInteger)secondValue {
	NSDateComponents *dateComponents = nil;

	dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self];

	return dateComponents.second;
}

#pragma mark -
- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate {
	BOOL isSame = NO;

	if (self.yearValue == anotherDate.yearValue
		&& self.monthValue == anotherDate.monthValue
		&& self.dayValue == anotherDate.dayValue) {
		isSame = YES;
	}

	return isSame;
}

@end
