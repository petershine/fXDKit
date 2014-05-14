//
//  FXDDate.h
//
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@interface FXDDate : NSDate
@end


#pragma mark - Categories
@interface NSDate (Added)
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
