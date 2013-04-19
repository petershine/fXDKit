//
//  FXDDate.h
//
//
//  Created by petershine on 5/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDDate : NSDate

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSDate (Added)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate;

+ (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;

+ (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate;
+ (NSDate*)localDateForUTCdate:(NSDate*)UTCdate;

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
