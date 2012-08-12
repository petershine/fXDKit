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


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSDate (Added)
+ (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;

- (NSInteger)yearValue;
- (NSInteger)monthValue;
- (NSInteger)dayValue;

- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate;

@end
