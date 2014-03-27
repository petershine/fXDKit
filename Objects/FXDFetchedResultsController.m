//
//  FXDFetchedResultsController.m
//
//
//  Created by petershine on 7/4/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDFetchedResultsController.h"


#pragma mark - Public implementation
@implementation FXDFetchedResultsController


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end

#pragma mark - Category
@implementation FXDFetchedResultsController (Added)
- (FXDManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeKey, attributeValue];

	FXDManagedObject *resultObj = [self resultObjForPredicate:predicate];

	return resultObj;
}

- (FXDManagedObject*)resultObjForPredicate:(NSPredicate*)predicate {

	FXDManagedObject *resultObj = nil;

	if ([self.fetchedObjects count] > 0) {
		NSArray *filteredArray = [self.fetchedObjects filteredArrayUsingPredicate:predicate];

		resultObj = [filteredArray firstObject];
	}

#if TEST_loggingResultObjFiltering
	if (resultObj == nil || [filteredArray count] > 1) {
		FXDLog(@"%@ %@", _Object(predicate), _Variable([filteredArray count]));
	}
#endif

	return resultObj;
}

@end
