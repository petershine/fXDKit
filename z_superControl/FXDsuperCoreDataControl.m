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
	
	if (fileURL == nil) {	// searchPath is NOT valid
		fileURL = [appDirectory_Document URLByAppendingPathComponent:documentnameManagedCoreData];
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
	
	dispatch_once(&once,^{
		_sharedInstance = [[self alloc] initWithFileURL:nil];	//MARK: Cannot use default implementation because of using this different initializer
	});
	
	return _sharedInstance;
}

#pragma mark -
- (void)startObservingFileControlNotifications {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(observedFileControlDidUpdateUbiquityContainerURL:)
												 name:notificationFileControlDidUpdateUbiquityContainerURL
											   object:nil];
	
}

- (void)prepareCoreDataControlUsingUbiquityContainerURL:(NSURL*)ubiquityContainerURL {	//FXDLog_DEFAULT;
	
	[[NSOperationQueue new] addOperationWithBlock:^{
		FXDLog(@"ubiquityContainerURL: %@", ubiquityContainerURL);
		
		NSURL *rootURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		NSURL *storeURL = [rootURL URLByAppendingPathComponent:applicationSqlitePathComponent];
		FXDLog(@"storeURL: %@", storeURL);
		
		
		NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithCapacity:0];
		[options setObject:@(YES) forKey:NSMigratePersistentStoresAutomaticallyOption];
		[options setObject:@(YES) forKey:NSInferMappingModelAutomaticallyOption];
		
		NSURL *ubiquitousContentURL = nil;
		
		if (ubiquityContainerURL) {	//TODO: get UUID unique URL
			//ubiquitousContentURL = [ubiquityContainerURL URLByAppendingPathComponent:ubiquitousCoreDataContentName];
			//TEST: using ubiquityContainerURL instead
			ubiquitousContentURL = ubiquityContainerURL;
			
			[options setObject:ubiquitousCoreDataContentName forKey:NSPersistentStoreUbiquitousContentNameKey];
			[options setObject:ubiquitousContentURL forKey:NSPersistentStoreUbiquitousContentURLKey];
		}
		else {
			
		}
		
		FXDLog(@"ubiquitousContentURL: %@", ubiquitousContentURL);
		FXDLog(@"options:\n%@", options);
		
		
		NSError *error = nil;
		
		BOOL didConfigure = [self configurePersistentStoreCoordinatorForURL:storeURL
																	 ofType:NSSQLiteStoreType
														 modelConfiguration:nil
															   storeOptions:options
																	  error:&error];FXDLog_ERROR;
		FXDLog(@"didConfigure: %d", didConfigure);
		
#if ForDEVELOPER
		NSPersistentStoreCoordinator *storeCoordinator = self.managedObjectContext.persistentStoreCoordinator;
		
		for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
			FXDLog(@"persistentStore: %@", persistentStore.URL);
			FXDLog(@"metadataForPersistentStore:\n%@", [storeCoordinator metadataForPersistentStore:persistentStore]);
		}
#endif
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
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
							  selector:@selector(observedNSPersistentStoreDidImportUbiquitousContentChanges:)
								  name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
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
		}];
	}];
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
		
		BOOL didPerformFetch = [resultsController performFetch:&error];FXDLog_ERROR;
		
		FXDLog(@"didPerformFetch: %d", didPerformFetch);
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
		resultObj = [filteredArray objectAtIndex:0];
		
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
	
    if (self.managedObjectContext && self.managedObjectContext.hasChanges) {
		[self.managedObjectContext performBlockAndWait:^{	FXDLog_DEFAULT;
			
			NSError *error = nil;
			
			BOOL didSave = [self.managedObjectContext save:&error];FXDLog_ERROR;
			FXDLog(@"didSave: %d", didSave);
		}];
    }
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_DEFAULT;;
	[self saveContext];
}

#pragma mark -
- (void)observedFileControlDidUpdateUbiquityContainerURL:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self prepareCoreDataControlUsingUbiquityContainerURL:notification.object];
}

#pragma mark -
- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {	FXDLog_OVERRIDE;
	[self.managedObjectContext performBlock:^{
		[self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	}];
}

#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification {	FXDLog_OVERRIDE;
	//FXDLog(@"notification.userInfo:\n%@", notification.userInfo);

}

- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	//FXDLog(@"notification.userInfo:\n%@", notification.userInfo);
}


//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controllerWillChangeContent:controller];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	
	if (controller.dynamicDelegate) {
		[controller.dynamicDelegate controllerDidChangeContent:controller];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}


@end