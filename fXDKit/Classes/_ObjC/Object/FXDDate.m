

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

#pragma mark -
- (NSString*)formattedAgeTextSinceDate:(NSDate*)date {

	if (date == nil) {
		date = [NSDate date];
	}


	NSString *ageText = nil;

	NSInteger age = (NSInteger)(date.timeIntervalSince1970 -self.timeIntervalSince1970);

	NSInteger days = (NSInteger)(age/60/60/24);

	if (days > 7) {
		ageText = [NSString stringWithFormat:@"%@", [self.description componentsSeparatedByString:@" "].firstObject];
	}
	else if (days > 0 && days <= 7) {
		ageText = [NSString stringWithFormat:@"%ld day", (long)days];

		if (days > 1) {
			ageText = [ageText stringByAppendingString:@"s"];
		}
	}
	else {
		NSInteger seconds = age % 60;
		NSInteger minutes = (NSInteger)(age/60) % 60;
		NSInteger hours = (NSInteger)(age/60/60) % 24;

		ageText = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", (long)hours, (long)minutes, (long)seconds];
	}

	return ageText;
}

@end