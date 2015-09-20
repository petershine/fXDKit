

#import "FXDimportCore.h"

@import UIKit;
@import Foundation;


@interface NSDate (Essential)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate;
+ (NSString*)localDateTextForUTCdate:(NSDate*)UTCdate withFormat:(NSString*)format;

- (NSInteger)yearValue;
- (NSInteger)monthValue;
- (NSInteger)dayValue;

- (NSString*)shortMonthString;
- (NSString*)weekdayString;

- (NSInteger)hourValue;
- (NSInteger)minuteValue;
- (NSInteger)secondValue;

- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate;

- (NSString*)formattedAgeTextSinceDate:(NSDate*)date;

@end
