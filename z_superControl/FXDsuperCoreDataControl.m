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
- (id)initWithFileURL:(NSURL *)fileURL {	FXDLog_DEFAULT;
	
	if (fileURL == nil) {
		NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		
		fileURL = [applicationDocumentsDirectory URLByAppendingPathComponent:documentnameManagedCoreData];
	}
	
	FXDLog(@"fileURL: %@", fileURL);
	
	self = [super initWithFileURL:fileURL];
	
	if (self) {		
		// Primitives
		
		// Instance variables
		
		// Properties
		_defaultEntityName = nil;
		_defaultSortDescriptors = nil;
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties
- (NSString*)defaultEntityName {
	if (_defaultEntityName == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultEntityName;
}

- (NSArray*)defaultSortDescriptors {
	if (_defaultSortDescriptors == nil) {	FXDLog_OVERRIDE;
		
	}
	
	return _defaultSortDescriptors;
}

#pragma mark -
- (NSFetchedResultsController*)defaultResultsController {
	if (_defaultResultsController == nil) {	FXDLog_DEFAULT;
		_defaultResultsController = [self resultsControllerForEntityName:self.defaultEntityName
													 withSortDescriptors:self.defaultSortDescriptors
															   withLimit:integerNotDefined
												fromManagedObjectContext:self.managedObjectContext];
		
		[_defaultResultsController setDelegate:self];
	}
	
	return _defaultResultsController;
}


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperCoreDataControl*)sharedInstance {
	static dispatch_once_t once;
	
    static id _sharedInstance = nil;
	
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] initWithFileURL:nil];
	});
	
    return _sharedInstance;
}

#pragma mark -
- (void)startObservingCloudControlNotifications {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(observedCloudControlDidUpdateUbiquityURL:)
												 name:notificationCloudControlDidUpdateUbiquityURL
											   object:nil];
	
}

- (void)prepareCoreDataControlUsingUbiquityURL:(NSURL*)ubiquityURL {	FXDLog_DEFAULT;
	FXDLog(@"ubiquityURL: %@", ubiquityURL);
	
	NSURL *rootURL = nil;
	
	NSURL *storeURL = nil;
	NSDictionary *options = nil;
	
	if (ubiquityURL) {
		/*
		 option indicating that a persistent store has a given name in ubiquity, this option is required for ubiquity to function
		 COREDATA_EXTERN NSString * const NSPersistentStoreUbiquitousContentNameKey NS_AVAILABLE(NA, 5_0);
		 
		 option indicating the log path to use for ubiquity logs, this option is optional for ubiquity, a default path will be generated for the store if none is provided
		 COREDATA_EXTERN NSString * const NSPersistentStoreUbiquitousContentURLKey NS_AVAILABLE(NA, 5_0);
		 
		 Notification sent after records are imported from the ubiquity store. The notification is sent with the object set to the NSPersistentStoreCoordinator instance which registered the store.
		 COREDATA_EXTERN NSString * const NSPersistentStoreDidImportUbiquitousContentChangesNotification NS_AVAILABLE(NA, 5_0);
		 */
		
		rootURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		
		storeURL = [rootURL URLByAppendingPathComponent:applicationSqlitePathComponent];
		
		options = @{	NSMigratePersistentStoresAutomaticallyOption:@YES,	NSInferMappingModelAutomaticallyOption:@YES	};
	}
	else {
		rootURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		
		storeURL = [rootURL URLByAppendingPathComponent:applicationSqlitePathComponent];
		
		options = @{	NSMigratePersistentStoresAutomaticallyOption:@YES,	NSInferMappingModelAutomaticallyOption:@YES	};
	}
	
	FXDLog(@"rootURL: %@", rootURL);
	FXDLog(@"storeURL: %@", storeURL);
	FXDLog(@"options:\n%@", options);
	
	
	NSError *error = nil;
	
	BOOL didConfigure = [self configurePersistentStoreCoordinatorForURL:storeURL
																 ofType:NSSQLiteStoreType
													 modelConfiguration:nil
														   storeOptions:options
																  error:&error];
	if (error || didConfigure == NO) {
		FXDLog_ERROR;
	}
	
#if ForDEVELOPER
	NSPersistentStoreCoordinator *storeCoordinator = self.managedObjectContext.persistentStoreCoordinator;
	
	for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
		FXDLog(@"persistentStore: %@", persistentStore.URL);
		FXDLog(@"metadataForPersistentStore:\n%@", [storeCoordinator metadataForPersistentStore:persistentStore]);
	}
#endif
	
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedUIApplicationDidEnterBackground:)
						  name:UIApplicationDidEnterBackgroundNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedUIApplicationWillTerminate:)
						  name:UIApplicationWillTerminateNotification
						object:nil];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSManagedObjectContextObjectsDidChange:)
						  name:NSManagedObjectContextObjectsDidChangeNotification
						object:self.managedObjectContext];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSManagedObjectContextWillSave:)
						  name:NSManagedObjectContextWillSaveNotification
						object:self.managedObjectContext];
	
	[defaultCenter addObserver:self
					  selector:@selector(observedNSManagedObjectContextDidSave:)
						  name:NSManagedObjectContextDidSaveNotification
						object:self.managedObjectContext];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationCoreDataControlDidPrepare object:self];
}

#pragma mark -
- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {	FXDLog_DEFAULT;
	if (entityName == nil) {
		entityName = self.defaultEntityName;
	}
	
	if (sortDescriptors == nil) {
		sortDescriptors = self.defaultSortDescriptors;
	}
	
	if (limit == integerNotDefined) {
		limit = limitDefaultFetch;
	}
	
	if (managedObjectContext == nil) {
		managedObjectContext = self.managedObjectContext;
	}
	
	FXDFetchedResultsController *resultsController = nil;
	
	if (entityName && sortDescriptors) {
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];

		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		[fetchRequest setEntity:entityDescription];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		[fetchRequest setFetchLimit:limit];
		[fetchRequest setFetchBatchSize:sizeDefaultBatch];

		
		resultsController = [[FXDFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:entityName];
		
		NSError *error = nil;
		
		if ([resultsController performFetch:&error]) {
			FXDLog(@"performFetch: %@", @"DONE");
		}
		
		if (error) {
			FXDLog_ERROR;
		}
	}
	
	return resultsController;
}

#pragma mark -
- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue {	FXDLog_DEFAULT;
	NSManagedObject *resultObj = nil;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeKey, attributeValue];
	FXDLog(@"predicate: %@", predicate);
		
	NSArray *filteredArray = [self.defaultResultsController.fetchedObjects filteredArrayUsingPredicate:predicate];
	
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

#pragma mark -
- (void)saveContext {	FXDLog_SEPARATE;
    __block NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	
    if (managedObjectContext && managedObjectContext.hasChanges) {
		[managedObjectContext performBlockAndWait:^{	FXDLog_DEFAULT;
			NSError *error = nil;
			
			if (![managedObjectContext save:&error]) {
				FXDLog_ERROR;
			}
		}];
    }
}


//MARK: - Observer implementation
- (void)observedCloudControlDidUpdateUbiquityURL:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self prepareCoreDataControlUsingUbiquityURL:notification.object];
}

#pragma mark -
- (void)observedUIApplicationDidEnterBackground:(id)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedUIApplicationWillTerminate:(id)notification {	FXDLog_OVERRIDE;
	[self saveContext];
}


#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(id)notification {	FXDLog_OVERRIDE;
	//FXDLog(@"notification: %@", notification);

}

- (void)observedNSManagedObjectContextWillSave:(id)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSManagedObjectContextDidSave:(id)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification: %@", notification);
}


//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controllerWillChangeContent:controller];
	}
	else {
		FXDLog_OVERRIDE;
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
	}
	else {
		FXDLog_OVERRIDE;
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
	}
	else {
		FXDLog_OVERRIDE;
	}
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controllerDidChangeContent:controller];
	}
	else {
		FXDLog_OVERRIDE;
	}
}


@end