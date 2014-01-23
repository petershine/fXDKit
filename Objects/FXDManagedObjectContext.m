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
		BOOL didPerformFetch = [resultsController performFetch:&error];FXDLog_ERROR;
		
		if (didPerformFetch == NO) {
			FXDLog(@"didPerformFetch: %d concurrencyType: %lu", didPerformFetch, (unsigned long)self.concurrencyType);
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
		fetchedObjArray = [self executeFetchRequest:fetchRequest error:&error];	FXDLog_ERROR;

#if TEST_loggingResultObjFiltering
		if (fetchedObjArray == nil || [fetchedObjArray count] == 0) {
			FXDLog(@"fetchedObjArray: %d self.concurrencyType: %d [NSThread isMainThread]: %d", [fetchedObjArray count], self.concurrencyType, [NSThread isMainThread]);
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
	if (entity == nil) {
		FXDLog(@"MUST NOT be nil: entity: %@", entity);
		return nil;
	}


	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	[fetchRequest setEntity:entity];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	if (predicate) {
#if TEST_loggingResultObjFiltering
		FXDLog(@"predicate: %@", predicate);
#endif
		[fetchRequest setPredicate:predicate];
	}
	
	[fetchRequest setFetchLimit:limit];
	[fetchRequest setFetchBatchSize:sizeDefaultBatch];

	return fetchRequest;
}

@end