//
//  FXDManagedObjectContext.m
//
//
//  Created by petershine on 10/5/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#import "FXDManagedObjectContext.h"


@implementation FXDManagedObjectContext
@end


#pragma mark - Category
@implementation NSManagedObjectContext (Essential)
- (NSFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSFetchRequest *fetchRequest = [self
									fetchRequestForEntityName:entityName
									withSortDescriptors:sortDescriptors
									withPredicate:predicate
									withLimit:limit];

	if (fetchRequest == nil) {
		return nil;
	}


	NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc]
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

	return resultsController;
}

- (id)firstFetchedObjForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSArray *fetchedObjArray = [self
								fetchedObjArrayForEntityName:entityName
								withSortDescriptors:sortDescriptors
								withPredicate:predicate
								withLimit:limit];

	return fetchedObjArray.firstObject;
}

- (NSArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSFetchRequest *fetchRequest = [self
									fetchRequestForEntityName:entityName
									withSortDescriptors:sortDescriptors
									withPredicate:predicate
									withLimit:limit];

	if (fetchRequest == nil) {
		return nil;
	}


	NSError *error = nil;
	NSArray *fetchedObjArray = [self executeFetchRequest:fetchRequest error:&error];
	FXDLog_ERROR;

	return fetchedObjArray;
}

- (NSFetchRequest*)fetchRequestForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {	

	NSAssert2((entityName && sortDescriptors), @"MUST NOT be nil: %@, %@", _Object(entityName), _Object(sortDescriptors));
	
	if (entityName == nil || sortDescriptors == nil) {
		return nil;
	}


	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];

	NSAssert1(entityName, @"MUST NOT be nil: %@", _Object(entityName));

	if (entity == nil) {
		return nil;
	}


	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	if (predicate) {
		[fetchRequest setPredicate:predicate];
	}
	
	[fetchRequest setFetchLimit:limit];
	[fetchRequest setFetchBatchSize:sizeDefaultBatch];

	return fetchRequest;
}

@end