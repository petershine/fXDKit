//
//  FXDsuperCoreDataControl.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoreDataControl.h"
#import "FXDsuperCoreDataControl+CSVparser.h"


#pragma mark - Private interface
@interface FXDsuperCoreDataControl (Private)
@end


#pragma mark - Public implementation
@implementation FXDsuperCoreDataControl

#pragma mark Static objects

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
	
	// Properties
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(observedUIApplicationDidEnterBackground:)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];

		// Primitives
		
		// Instance variables
		
		// Properties
		_managedObjectContext = nil;
		_managedObjectModel = nil;
		_persistentStoreCoordinator = nil;
		
		_defaultEntityName = nil;
		_defaultSortDescriptorKeys = nil;
		
		_fieldKeys = nil;
		_fieldValues = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (NSManagedObjectModel *)managedObjectModel {

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

	_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
	
	FXDLog_DEFAULT;
	
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	
	NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:applicationSqlitePathComponent];
	
	FXDLog_DEFAULT;
	FXDLog(@"_persistentStoreCoordinator: %@", _persistentStoreCoordinator);
	FXDLog(@"storeURL: %@", storeURL);
	
	NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
	
	NSError *error = nil;
	
	NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
																				   configuration:nil
																							 URL:storeURL
																						 options:options
																						   error:&error];
	
	if (!persistentStore) {
#if DEBUG
		FXDLog_ERROR;
		abort();
#endif
    }
#if DEBUG
	for (NSPersistentStore *persistentStore in [_persistentStoreCoordinator persistentStores]) {
		FXDLog(@"persistentStore: %@", persistentStore);
		FXDLog(@"metadataForPersistentStore: %@", [_persistentStoreCoordinator metadataForPersistentStore:persistentStore]);
	}
#endif
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
	
	FXDLog_DEFAULT;
	
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
		
		NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedNSManagedObjectContextObjectsDidChange:)
							  name:NSManagedObjectContextObjectsDidChangeNotification
							object:_managedObjectContext];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedNSManagedObjectContextWillSave:)
							  name:NSManagedObjectContextWillSaveNotification
							object:_managedObjectContext];
		
		[defaultCenter addObserver:self
						  selector:@selector(observedNSManagedObjectContextDidSave:)
							  name:NSManagedObjectContextDidSaveNotification
							object:_managedObjectContext];
    }
	
	FXDLog(@"_managedObjectContext: %@", _managedObjectContext);
	
    return _managedObjectContext;
}

#pragma mark -
- (NSString*)defaultEntityName {
	if (_defaultEntityName == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultEntityName;
}

- (NSArray*)defaultSortDescriptorKeys {
	if (_defaultSortDescriptorKeys == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultSortDescriptorKeys;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCoreDataControl*)sharedInstance {
	static dispatch_once_t once;
	
    static id _sharedInstance = nil;
	
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
	
    return _sharedInstance;
}

#pragma mark -
- (void)saveContext {	FXDLog_SEPARATE;
    NSError *error = nil;
	
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
#if DEBUG
            FXDLog_ERROR;
            abort();
#endif
        } 
    }
}

#pragma mark -
- (NSFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName andForSortDescriptors:(NSArray*)sortDescriptors {
	if (entityName == nil) {
		entityName = self.defaultEntityName;
	}
	
	if (sortDescriptors == nil) {
		sortDescriptors = self.defaultSortDescriptorKeys;
	}
	
	NSFetchedResultsController *resultsController = nil;
	
	if (entityName && sortDescriptors) {
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
		
		FXDLog_DEFAULT;

		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:entityDescription];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		[fetchRequest setFetchLimit:limitDefaultFetch];
		[fetchRequest setFetchBatchSize:sizeDefaultBatch];
		
		//FXDLog(@"fetchRequest:\n%@", fetchRequest);
		
		resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:entityName];
		
		NSError *error = nil;
		
		if ([resultsController performFetch:&error]) {
			FXDLog(@"resultsController count: %d", [resultsController.fetchedObjects count]);
		}
		else {
			if (error) {
				FXDLog_ERROR;
			}
		}
	}
	else {
		FXDLog(@"entityName: %@", entityName);
		FXDLog(@"sortDescriptors: %@", sortDescriptors);
	}
	
	return resultsController;
}

- (NSArray*)fetchedObjectsForEntityName:(NSString*)entityName andForSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchedResultsController *resultsController = [self resultsControllerForEntityName:entityName andForSortDescriptors:sortDescriptors];
	
	return resultsController.fetchedObjects;
}

- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue {	FXDLog_DEFAULT;
	NSManagedObject *resultObj = nil;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeKey, attributeValue];
	FXDLog(@"predicate: %@", predicate);
	
	NSFetchedResultsController *resultsController = [self resultsControllerForEntityName:self.defaultEntityName andForSortDescriptors:self.defaultSortDescriptorKeys];
	
	NSArray *filteredArray = [resultsController.fetchedObjects filteredArrayUsingPredicate:predicate];
	
	if ([filteredArray count] > 0) {
		resultObj = filteredArray[0];
		
		if ([filteredArray count] > 1) {
			FXDLog(@"filteredArray:\n%@", filteredArray);
		}
	}	
	
	return resultObj;
}

- (void)insertNewObjectForDefaultEntityNameWithCollectionObj:(id)collectionObj {	FXDLog_OVERRIDE;
	FXDLog(@"collectionObj:%@", collectionObj);
	
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(id)notification {	FXDLog_DEFAULT;
	[self saveContext];
	
}

#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(id)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSManagedObjectContextWillSave:(id)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSManagedObjectContextDidSave:(id)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);
	
}


//MARK: - Delegate implementation


@end