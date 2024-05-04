

#import "FXDManagedObjectContext.h"


@implementation NSManagedObjectContext (Essential)
- (NSFetchedResultsController*_Nullable)resultsControllerForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit {

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

- (id _Nullable )firstFetchedObjForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSArray *fetchedObjArray = [self
								fetchedObjArrayForEntityName:entityName
								withSortDescriptors:sortDescriptors
								withPredicate:predicate
								withLimit:limit];

	return fetchedObjArray.firstObject;
}

- (NSArray*_Nullable)fetchedObjArrayForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit {

	NSFetchRequest *fetchRequest = [self
									fetchRequestForEntityName:entityName
									withSortDescriptors:sortDescriptors
									withPredicate:predicate
									withLimit:limit];

	if (fetchRequest == nil) {
		return nil;
	}


	NSArray *fetchedObjArray = nil;
	NSError *error = nil;
	@try {
		fetchedObjArray = [self executeFetchRequest:fetchRequest error:&error];
	} @catch (NSException *exception) {
		FXDLog_ERROR;
		FXDLogObject(exception);
	} @finally {
		if (error != nil) {
			fetchedObjArray = nil;
		}
	}

	return fetchedObjArray;
}

- (NSFetchRequest*_Nullable)fetchRequestForEntityName:(NSString*_Nullable)entityName withSortDescriptors:(NSArray*_Nullable)sortDescriptors withPredicate:(nullable NSPredicate*)predicate withLimit:(NSUInteger)limit {

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
	fetchRequest.entity = entity;
	fetchRequest.sortDescriptors = sortDescriptors;
	
	if (predicate) {
		fetchRequest.predicate = predicate;
	}
	
	fetchRequest.fetchLimit = limit;
	[fetchRequest setFetchBatchSize:sizeDefaultBatch];

	return fetchRequest;
}

@end
