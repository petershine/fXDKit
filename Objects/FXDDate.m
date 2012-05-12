//
//  FXDDate.m
//  PopTooUniversal
//
//  Created by petershine on 5/5/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDDate.h"


#pragma mark - Private interface
@interface FXDDate (Private)
@end


#pragma mark - Public implementation
@implementation FXDDate

#pragma mark Static objects

#pragma mark Synthesizing
// Properties

// Controllers


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables
	
	// Properties
	
    // Controllers
	
    [super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
		
        // Controllers
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties

// Controllers


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation NSDate (Added)
+ (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate {
	if (localDate == nil) {
		localDate = [self date];
	}
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
    NSString *UTCdateString = [dateFormatter stringFromDate:localDate];
    [dateFormatter release];
	
    return UTCdateString;
}

+ (NSDate*)UTCdateForLocalDate:(NSDate*)localDate {
	
	NSString *UTCdateString = [self UTCdateStringForLocalDate:localDate];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
    NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:UTCtimezone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *UTCdate = [dateFormatter dateFromString:UTCdateString];
	[dateFormatter release];
	
	return UTCdate;
}


@end