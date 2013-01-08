//
//  FXDsuperCoreDataManager.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoreDataManager.h"
#import "FXDsuperCoreDataManager+CSVparser.h"


#pragma mark - Public implementation
@implementation FXDsuperCoreDataManager


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Instance variables
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
	}
	
	return self;
}

+ (FXDsuperCoreDataManager*)sharedInstance {
	static dispatch_once_t once;
	static id _sharedInstance = nil;

	dispatch_once(&once,^{
		_sharedInstance = [[[self class] alloc] initWithFileURL:nil];	//MARK: Cannot use default implementation because of using this different initializer
	});

	return _sharedInstance;
}


#pragma mark - Property overriding
- (NSString*)mainEntityName {
	if (_mainEntityName == nil) {	FXDLog_OVERRIDE;

	}

	return _mainEntityName;
}

- (NSArray*)mainSortDescriptors {
	if (_mainSortDescriptors == nil) {	FXDLog_OVERRIDE;

	}

	return _mainSortDescriptors;
}

- (FXDFetchedResultsController*)mainResultsController {
	if (_mainResultsController == nil) {	FXDLog_DEFAULT;
		_mainResultsController = [self.managedObjectContext
								  resultsControllerForEntityName:self.mainEntityName
								  withSortDescriptors:self.mainSortDescriptors
								  withPredicate:nil
								  withLimit:integerNotDefined];

		[_mainResultsController setDelegate:self];
	}

	return _mainResultsController;
}


#pragma mark - Method overriding


#pragma mark - Public
- (void)startObservingFileControlNotifications {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(observedFileControlDidUpdateUbiquityContainerURL:)
												 name:notificationFileControlDidUpdateUbiquityContainerURL
											   object:nil];
	
}

- (void)prepareCoreDataControlWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL forFinishedHandler:(void(^)(BOOL didFinish))finishedHandler {	//FXDLog_DEFAULT;
	
	[[NSOperationQueue new] addOperationWithBlock:^{	FXDLog_DEFAULT;
		FXDLog(@"ubiquityContainerURL: %@", ubiquityContainerURL);
		
		NSURL *rootURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		NSURL *storeURL = [rootURL URLByAppendingPathComponent:applicationSqlitePathComponent];
		FXDLog(@"storeURL: %@", storeURL);
		
		
		NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithCapacity:0];
		options[NSMigratePersistentStoresAutomaticallyOption] = @(YES);
		options[NSInferMappingModelAutomaticallyOption] = @(YES);
		
		NSURL *ubiquitousContentURL = nil;
		
#warning "TODO: get UUID unique URL using ubiquityContainerURL instead"
		//ubiquitousContentURL = [ubiquityContainerURL URLByAppendingPathComponent:ubiquitousCoreDataContentName];
		
		if (ubiquityContainerURL) {

			ubiquitousContentURL = ubiquityContainerURL;
			
			options[NSPersistentStoreUbiquitousContentNameKey] = ubiquitousCoreDataContentName;
			options[NSPersistentStoreUbiquitousContentURLKey] = ubiquitousContentURL;
		}
		else {
			//MARK: Not using iCloud
		}
		
		FXDLog(@"ubiquitousContentURL: %@", ubiquitousContentURL);
		FXDLog(@"options:\n%@", options);
		

		NSError *error = nil;
		BOOL didConfigure = [self configurePersistentStoreCoordinatorForURL:storeURL
																	 ofType:NSSQLiteStoreType
														 modelConfiguration:nil
															   storeOptions:options
																	  error:&error];FXDLog_ERROR;

		FXDLog(@"1.didConfigure: %d", didConfigure);
		
#if ForDEVELOPER
		NSPersistentStoreCoordinator *storeCoordinator = self.managedObjectContext.persistentStoreCoordinator;
		
		for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
			FXDLog(@"persistentStore: %@", persistentStore.URL);
			FXDLog(@"metadataForPersistentStore:\n%@", [storeCoordinator metadataForPersistentStore:persistentStore]);
		}
#endif
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[self prepareCoredataControlObserverMethods];

			FXDLog(@"2.didConfigure: %d", didConfigure);

#if ForDEVELOPER
			if (error) {
				NSString *title = [NSString stringWithFormat:@"%@", strClassSelector];
				NSString *message = [NSString stringWithFormat:@"FILE: %s\nLINE: %d\nDescription: %@\nFailureReason: %@", __FILE__, __LINE__, [error localizedDescription], [error localizedFailureReason]];

				FXDAlertView *alertView = [[FXDAlertView alloc] initWithTitle:title
																	  message:message
																	 delegate:nil
															cancelButtonTitle:NSLocalizedString(text_Cancel, nil)
															otherButtonTitles:nil];
				[alertView show];
			}
#endif
			
#warning "//TODO: learn how to handle ubiquitousToken change, and migrate to new persistentStore"
			
			if (finishedHandler) {
				finishedHandler(didConfigure);
			}
			else {
				NSDictionary *userInfo = @{@"didConfigure" : [NSNumber numberWithBool:didConfigure]};
				
				[[NSNotificationCenter defaultCenter] postNotificationName:notificationCoreDataControlDidPrepare object:self userInfo:userInfo];
			}
		}];
	}];
}

- (void)prepareCoredataControlObserverMethods {	FXDLog_DEFAULT;
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
						object:nil];

	[defaultCenter addObserver:self
					  selector:@selector(observedNSManagedObjectContextWillSave:)
						  name:NSManagedObjectContextWillSaveNotification
						object:nil];

	[defaultCenter addObserver:self
					  selector:@selector(observedNSManagedObjectContextDidSave:)
						  name:NSManagedObjectContextDidSaveNotification
						object:nil];
}

- (FXDFetchedResultsController*)resultsControllerForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {	FXDLog_DEFAULT;

	if (entityName == nil) {
		entityName = self.mainEntityName;
	}

	if (sortDescriptors == nil) {
		sortDescriptors = self.mainSortDescriptors;
	}


	if (managedObjectContext == nil) {
		managedObjectContext = self.managedObjectContext;
	}

	FXDFetchedResultsController *resultsController = [managedObjectContext resultsControllerForEntityName:entityName withSortDescriptors:sortDescriptors withPredicate:predicate withLimit:limit];

	return resultsController;
}

- (NSMutableArray*)fetchedObjArrayForEntityName:(NSString*)entityName withSortDescriptors:(NSArray*)sortDescriptors withPredicate:(NSPredicate*)predicate withLimit:(NSUInteger)limit fromManagedObjectContext:(NSManagedObjectContext*)managedObjectContext {

	if (entityName == nil) {
		entityName = self.mainEntityName;
	}

	if (sortDescriptors == nil) {
		sortDescriptors = self.mainSortDescriptors;
	}


	if (managedObjectContext == nil) {
		managedObjectContext = self.managedObjectContext;
	}

	NSMutableArray *fetchedObjArray = [managedObjectContext fetchedObjArrayForEntityName:entityName withSortDescriptors:sortDescriptors withPredicate:predicate withLimit:limit];

	return fetchedObjArray;
}

- (FXDManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue fromResultsController:(FXDFetchedResultsController*)resultsController {	//FXDLog_DEFAULT;

	if (resultsController == nil) {
		resultsController = self.mainResultsController;
	}
	

	FXDManagedObject *resultObj = [resultsController resultObjForAttributeKey:attributeKey andForAttributeValue:attributeValue];
	
	return resultObj;
}

#pragma mark -
- (void)saveManagedObjectContext:(NSManagedObjectContext*)managedObjectContext withFinishedBlock:(void(^)(void))finishedBlock {	FXDLog_SEPARATE;

	FXDLog(@"1.hasChanges: %d concurrencyType: %d", managedObjectContext.hasChanges, managedObjectContext.concurrencyType);

	if (managedObjectContext == nil) {
		managedObjectContext = self.managedObjectContext;

		FXDLog(@"2.hasChanges: %d concurrencyType: %d", managedObjectContext.hasChanges, managedObjectContext.concurrencyType);

		if (managedObjectContext.concurrencyType == NSMainQueueConcurrencyType
			&& managedObjectContext.hasChanges == NO) {
			managedObjectContext = self.managedObjectContext.parentContext;
		}
	}

	FXDLog(@"3.hasChanges: %d concurrencyType: %d", managedObjectContext.hasChanges, managedObjectContext.concurrencyType);


	if (managedObjectContext == nil || managedObjectContext.hasChanges == NO) {
		
		if (finishedBlock) {
			finishedBlock();
		}

		return;
	}
	

	void (^_contextSavingBlock)(void) = ^{	FXDLog_DEFAULT;

		NSError *error = nil;
		BOOL didSave = [managedObjectContext save:&error];

		FXDLog(@"didSave: %d concurrencyType: %d", didSave, managedObjectContext.concurrencyType);

		FXDLog_ERROR;

		if (finishedBlock) {
			finishedBlock();
		}
	};

	[managedObjectContext performBlockAndWait:_contextSavingBlock];

	//MARK: Study about performBlock for asynchronous saving, and when to use it properly
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {	FXDLog_OVERRIDE;
	
}

- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_DEFAULT;;
	[self saveManagedObjectContext:nil withFinishedBlock:nil];
}

- (void)observedFileControlDidUpdateUbiquityContainerURL:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self prepareCoreDataControlWithUbiquityContainerURL:notification.object forFinishedHandler:nil];
}

#pragma mark -
- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.name: %@", notification.name);
	FXDLog(@"notification.object: %@", notification.object);

	FXDLog(@"inserted: %d", [(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %d", [(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %d", [(notification.userInfo)[@"updated"] count]);

}

#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
	FXDLog(@"isEqual:self.managedObjectContext: %@", [notification.object isEqual:self.managedObjectContext] ? @"YES":@"NO");

}

- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
	FXDLog(@"isEqual:self.managedObjectContext: %@", [notification.object isEqual:self.managedObjectContext] ? @"YES":@"NO");

}

- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
	FXDLog(@"isEqual:self.managedObjectContext: %@", [notification.object isEqual:self.managedObjectContext] ? @"YES":@"NO");

	// Make notification from main managedObjectContext and private managedObjectContext is distinguished
	if ([notification.object isEqual:self.managedObjectContext] == NO
		|| [(NSManagedObjectContext*)notification.object concurrencyType] == NSPrivateQueueConcurrencyType) {

		FXDLog(@" ");
		FXDLog(@"NOTIFIED: mergeChangesFromContextDidSaveNotification:");
		FXDLog(@"inserted: %d", [(notification.userInfo)[@"inserted"] count]);
		FXDLog(@"deleted: %d", [(notification.userInfo)[@"deleted"] count]);
		FXDLog(@"updated: %d", [(notification.userInfo)[@"updated"] count]);

		[self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	}
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
		//FXDLog_OVERRIDE;
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