
#import "FXDKit.h"


@interface FXDDate : NSDate
@end


@interface NSDate (Essential)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate;

- (NSInteger)yearValue;
- (NSInteger)monthValue;
- (NSInteger)dayValue;

- (NSString*)shortMonthString;
- (NSString*)weekdayString;

- (NSInteger)hourValue;
- (NSInteger)minuteValue;
- (NSInteger)secondValue;

- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate;

@end
