//
//  FXDManagedObjectContext.m
//
//
//  Created by petershine on 10/5/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDManagedObjectContext.h"


#pragma mark - Public implementation
@implementation FXDManagedObjectContext


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation NSManagedObjectContext (Added)
- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	FXDFetchedResultsController *resultsController = nil;
	
	NSFetchRequest *fetchRequest = [self
									fetchRequestForEntityName:entityName
									withSortDescriptors:sortDescriptors
									withPredicate:predicate
									withLimit:limit];
	
	if (fetchRequest) {
		resultsController = [[FXDFetchedResultsController alloc]
							 initWithFetchRequest:fetchRequest
							 managedObjectContext:self
							 sectionNameKeyPath:nil
							 cacheName:entityName];
		
		
		NSError *error = nil;
		BOOL didPerformFetch = [resultsController performFetch:&error];
		FXDLog_ERROR;
		
		if (didPerformFetch == NO) {
			FXDLog(@"%@ %@", _BOOL(didPerformFetch), _Variable(self.concurrencyType));
		}
	}

	return resultsController;
}

- (id)firstFetchedObjForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSArray *fetchedObjArray = [self
								fetchedObjArrayForEntityName:entityName
								withSortDescriptors:sortDescriptors
								withPredicate:predicate
								withLimit:limit];

	NSManagedObject *firstObj = [fetchedObjArray firstObject];

	return firstObj;
}

- (NSArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSArray *fetchedObjArray = nil;

	NSFetchRequest *fetchRequest = [self
									fetchRequestForEntityName:entityName
									withSortDescriptors:sortDescriptors
									withPredicate:predicate
									withLimit:limit];

	if (fetchRequest) {

		NSError *error = nil;
		fetchedObjArray = [self executeFetchRequest:fetchRequest error:&error];
		FXDLog_ERROR;

#if TEST_loggingResultObjFiltering
		if (fetchedObjArray == nil || [fetchedObjArray count] == 0) {
			FXDLog(@"%@ %@ %@", _Variable([fetchedObjArray count]), _Variable(self.concurrencyType), _IsMainThread);
		}
#endif
	}

	return fetchedObjArray;
}

- (NSFetchRequest*)fetchRequestForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {	

	NSAssert2((entityName && sortDescriptors), @"MUST NOT be nil: entityName: %@, sortDescriptors: %@", entityName, sortDescriptors);
	
	if (entityName == nil || sortDescriptors == nil) {
		return nil;
	}


	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];

	NSAssert1(entityName, @"MUST NOT be nil: entityName: %@", entityName);

	if (entity == nil) {
		return nil;
	}


	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	[fetchRequest setEntity:entity];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	if (predicate) {
#if TEST_loggingResultObjFiltering
		FXDLogObject(predicate);
#endif
		[fetchRequest setPredicate:predicate];
	}
	
	[fetchRequest setFetchLimit:limit];
	[fetchRequest setFetchBatchSize:sizeDefaultBatch];

	return fetchRequest;
}

@end