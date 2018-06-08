
#import "FXDimportEssential.h"


@interface NSDate (Essential)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate;
+ (NSString*)localDateTextForUTCdate:(NSDate*)UTCdate withFormat:(NSString*)format;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger yearValue;
@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger monthValue;
@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger dayValue;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *shortMonthString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *weekdayString;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger hourValue;
@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger minuteValue;
@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger secondValue;

- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate;

@end
