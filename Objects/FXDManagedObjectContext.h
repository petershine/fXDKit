//
//  FXDManagedObjectContext.h
//
//
//  Created by petershine on 10/5/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#ifndef TEST_loggingResultObjFiltering
	#define TEST_loggingResultObjFiltering	FALSE
#endif


#ifndef limitInfiniteFetch
	#define limitInfiniteFetch	0
#endif

#ifndef limitDefaultFetch
	#define limitDefaultFetch	1000
#endif

#ifndef sizeDefaultBatch
	#define sizeDefaultBatch	20
#endif


@interface FXDManagedObjectContext : NSManagedObjectContext
@end


#pragma mark - Category
@interface NSManagedObjectContext (Added)
- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (id)firstFetchedObjForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (NSArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (NSFetchRequest*)fetchRequestForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

@end
