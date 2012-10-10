//
//  FXDManagedObjectContext.m
//
//
//  Created by petershine on 10/5/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#ifndef limitDefaultFetch
	#define limitDefaultFetch	1000
#endif

#ifndef sizeDefaultBatch
	#define sizeDefaultBatch	10
#endif


#import "FXDManagedObjectContext.h"


#pragma mark - Private interface
@interface FXDManagedObjectContext (Private)
@end


#pragma mark - Public implementation
@implementation FXDManagedObjectContext

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (id)init {
	self = [super init];

	if (self) {
		// Primitives

		// Instance variables

		// Properties
	}

	return self;
}

#pragma mark - Accessor overriding
// Properties


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation NSManagedObjectContext (Added)
- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	FXDFetchedResultsController *resultsController = nil;

	NSFetchRequest *fetchRequest = [self fetchRequestForEntityName:entityName withSortDescriptors:sortDescriptors withPredicate:predicate withLimit:limit];

	if (fetchRequest) {
		resultsController = [[FXDFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self sectionNameKeyPath:nil cacheName:entityName];


		NSError *error = nil;
		BOOL didPerformFetch = [resultsController performFetch:&error];FXDLog_ERROR;

		FXDLog(@"didPerformFetch: %d concurrencyType: %d", didPerformFetch, self.concurrencyType);
	}

	return resultsController;
}

- (NSMutableArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSMutableArray *fetchedObjArray = nil;

	NSFetchRequest *fetchRequest = [self fetchRequestForEntityName:entityName withSortDescriptors:sortDescriptors withPredicate:predicate withLimit:limit];

	if (fetchRequest) {

		NSError *error = nil;
		NSArray *resultObjArray = [self executeFetchRequest:fetchRequest error:&error];FXDLog_ERROR;

		FXDLog(@"resultObjArray: %d concurrencyType: %d", [resultObjArray count], self.concurrencyType);

		fetchedObjArray = [resultObjArray mutableCopy];
	}

	return fetchedObjArray;
}

#pragma mark -
- (NSFetchRequest*)fetchRequestForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit {

	if (limit == integerNotDefined) {
		limit = limitDefaultFetch;
	}
	

	NSFetchRequest *fetchRequest = nil;

	if (entityName && sortDescriptors) {
		fetchRequest = [[NSFetchRequest alloc] init];

		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];

		[fetchRequest setEntity:entityDescription];
		[fetchRequest setSortDescriptors:sortDescriptors];

		if (predicate) {
			FXDLog(@"predicate: %@", predicate);
			[fetchRequest setPredicate:predicate];
		}

		[fetchRequest setFetchLimit:limit];
		[fetchRequest setFetchBatchSize:sizeDefaultBatch];
	}

	return fetchRequest;
}

@end