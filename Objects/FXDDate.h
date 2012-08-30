//
//  FXDDate.h
//
//
//  Created by petershine on 5/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDDate : NSDate {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
}

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSDate (Added)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSString*)shortLocateDateStringForUTCdate:(NSDate*)UTCdate;

+ (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;

+ (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate;
+ (NSDate*)localDateForUTCdate:(NSDate*)UTCdate;

- (NSInteger)yearValue;
- (NSInteger)monthValue;
- (NSInteger)dayValue;

- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate;

@end
