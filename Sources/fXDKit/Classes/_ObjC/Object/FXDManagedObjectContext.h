
#import <fXDObjC/FXDimportEssential.h>

#define limitInfiniteFetch	0
#define limitDefaultFetch	1000
#define sizeDefaultBatch	20


@import CoreData;


@interface NSManagedObjectContext (Essential)
- (NSFetchedResultsController*_Nullable)resultsControllerForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (id _Nullable )firstFetchedObjForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (NSArray*_Nullable)fetchedObjArrayForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit;

- (NSFetchRequest*_Nullable)fetchRequestForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit;

@end
