//
//  FXDIndexPath.m
//
//
//  Created by petershine on 12/28/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDIndexPath.h"


#pragma mark - Public implementation
@implementation FXDIndexPath


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation NSIndexPath (Added)
- (NSString*)stringValue {	//FXDLog_DEFAULT;
	NSString *indexPathString = @"";

	for (NSInteger i = 0; i < [self length]; i++) {
		NSUInteger index = [self indexAtPosition:i];

		if (index == NSNotFound) {
			break;
		}

		if ([indexPathString length] > 0) {
			indexPathString = [indexPathString stringByAppendingString:@"_"];
		}

		indexPathString = [indexPathString stringByAppendingFormat:@"%lu", (unsigned long)index];
	}

	if ([indexPathString length] == 0) {
		indexPathString = nil;
	}

	//FXDLog(@"indexPathString: %@", indexPathString);

	return indexPathString;
}

@end