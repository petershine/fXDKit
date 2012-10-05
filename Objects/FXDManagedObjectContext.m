//
//  FXDManagedObjectContext.m
//  Waffle
//
//  Created by petershine on 10/5/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

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

	if (limit == integerNotDefined) {
		limit = limitDefaultFetch;
	}


	FXDFetchedResultsController *resultsController = nil;

	if (entityName && sortDescriptors) {
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];

		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

		[fetchRequest setEntity:entityDescription];
		[fetchRequest setSortDescriptors:sortDescriptors];

		if (predicate) {
			FXDLog(@"predicate: %@", predicate);
			[fetchRequest setPredicate:predicate];
		}

		[fetchRequest setFetchLimit:limit];
		[fetchRequest setFetchBatchSize:sizeDefaultBatch];


		resultsController = [[FXDFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self sectionNameKeyPath:nil cacheName:entityName];


		NSError *error = nil;
		BOOL didPerformFetch = [resultsController performFetch:&error];FXDLog_ERROR;

		FXDLog(@"didPerformFetch: %d", didPerformFetch);
	}

	return resultsController;
}

@end