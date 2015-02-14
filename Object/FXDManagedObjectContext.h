
#import "FXDimportCore.h"

#ifndef limitInfiniteFetch
	#define limitInfiniteFetch	0
#endif

#ifndef limitDefaultFetch
	#define limitDefaultFetch	1000
#endif

#ifndef sizeDefaultBatch
	#define sizeDefaultBatch	20
#endif


@import CoreData;

@interface NSManagedObjectContext (Essential)
- (NSFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (id)firstFetchedObjForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (NSArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (NSFetchRequest*)fetchRequestForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit;

@end
