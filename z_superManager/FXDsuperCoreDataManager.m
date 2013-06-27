//
//  FXDsuperCoreDataManager.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoreDataManager.h"


#pragma mark - Public implementation
@implementation FXDsuperCoreDataManager


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initialization
+ (FXDsuperCoreDataManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (UIManagedDocument*)mainDocument {
	if (_mainDocument == nil) {	FXDLog_DEFAULT;
		NSURL *fileURL = [appDirectory_Document URLByAppendingPathComponent:documentnameManagedCoreData];
		FXDLog(@"fileURL: %@", fileURL);
				
		_mainDocument = [[UIManagedDocument alloc] initWithFileURL:fileURL];
		FXDLog(@"_mainDocument: %@", _mainDocument);
	}
	
	return _mainDocument;
}

#pragma mark -
- (NSString*)mainSqlitePathComponent {
	if (_mainSqlitePathComponent == nil) {	FXDLog_DEFAULT;
		_mainSqlitePathComponent = applicationSqlitePathComponent;
	}
	
	return _mainSqlitePathComponent;
}

- (NSString*)mainUbiquitousContentName {
	if (_mainUbiquitousContentName == nil) {	FXDLog_DEFAULT;
		_mainUbiquitousContentName = ubiquitousCoreDataContentName;
	}
	
	return _mainUbiquitousContentName;
}

#pragma mark -
- (NSString*)mainEntityName {
	if (_mainEntityName == nil) {	FXDLog_OVERRIDE;
		//SAMPLE:
		//_mainEntityName = entityname<#DefaultClass#>
	}

	return _mainEntityName;
}

- (NSArray*)mainSortDescriptors {
	if (_mainSortDescriptors == nil) {	FXDLog_OVERRIDE;
		//SAMPLE:
		//_mainSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attributekey<#AttributeName#> ascending:<#NO#>]];
	}

	return _mainSortDescriptors;
}

#pragma mark -
- (FXDFetchedResultsController*)mainResultsController {
	if (_mainResultsController == nil) {	FXDLog_DEFAULT;
		_mainResultsController = [self.mainDocument.managedObjectContext
								  resultsControllerForEntityName:self.mainEntityName
								  withSortDescriptors:self.mainSortDescriptors
								  withPredicate:nil
								  withLimit:limitInfiniteFetch];

		[_mainResultsController setDelegate:self];
	}

	return _mainResultsController;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startObservingFileManagerNotifications {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedFileControlDidUpdateUbiquityContainerURL:)
	 name:notificationFileManagerDidUpdateUbiquityContainerURL
	 object:nil];
	
}

- (void)startObservingCoreDataNotifications {	FXDLog_DEFAULT;
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidEnterBackground:)
	 name:UIApplicationDidEnterBackgroundNotification
	 object:nil];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillTerminate:)
	 name:UIApplicationWillTerminateNotification
	 object:nil];
	
	
	id notifyingObject = self.mainDocument.managedObjectContext.parentContext;
	FXDLog(@"notifyingObject: %@", notifyingObject);
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedNSPersistentStoreDidImportUbiquitousContentChanges:)
	 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
	 object:notifyingObject];
	
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedNSManagedObjectContextObjectsDidChange:)
	 name:NSManagedObjectContextObjectsDidChangeNotification
	 object:notifyingObject];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedNSManagedObjectContextWillSave:)
	 name:NSManagedObjectContextWillSaveNotification
	 object:notifyingObject];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedNSManagedObjectContextDidSave:)
	 name:NSManagedObjectContextDidSaveNotification
	 object:notifyingObject];
}

#pragma mark -
- (void)prepareCoreDataManagerWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection didFinishBlock:(void(^)(BOOL finished))didFinishBlock {	//FXDLog_DEFAULT;
	
	[[NSOperationQueue new] addOperationWithBlock:^{	FXDLog_DEFAULT;
		FXDLog(@"ubiquityContainerURL: %@", ubiquityContainerURL);
		FXDLog(@"withCompleteProtection: %d", withCompleteProtection);
		
		NSURL *rootURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		NSURL *storeURL = [rootURL URLByAppendingPathComponent:self.mainSqlitePathComponent];
		FXDLog(@"storeURL: %@", storeURL);
		
		
		NSMutableDictionary *options = [[NSMutableDictionary alloc] initWithCapacity:0];
		options[NSMigratePersistentStoresAutomaticallyOption] = @(YES);
		options[NSInferMappingModelAutomaticallyOption] = @(YES);
		
		if (ubiquityContainerURL) {	//MARK: If using iCloud
			//TODO: get UUID unique URL using ubiquityContainerURL instead
			//NSURL *ubiquitousContentURL = [ubiquityContainerURL URLByAppendingPathComponent:self.mainUbiquitousContentName];
			NSURL *ubiquitousContentURL = ubiquityContainerURL;
			
			options[NSPersistentStoreUbiquitousContentNameKey] = self.mainUbiquitousContentName;
			options[NSPersistentStoreUbiquitousContentURLKey] = ubiquitousContentURL;
			
			FXDLog(@"ubiquitousContentURL: %@", ubiquitousContentURL);
		}
		
		//MARK: NSFileProtectionCompleteUntilFirstUserAuthentication is already used as default
		if (withCompleteProtection) {
			options[NSPersistentStoreFileProtectionKey] = NSFileProtectionComplete;
		}
		
		FXDLog(@"options:\n%@", options);
		

		NSError *error = nil;
		BOOL didConfigure = [self.mainDocument
							 configurePersistentStoreCoordinatorForURL:storeURL
							 ofType:NSSQLiteStoreType
							 modelConfiguration:nil
							 storeOptions:options
							 error:&error];

		FXDLog_ERROR;LOGEVENT_ERROR;

		FXDLog(@"1.didConfigure: %d", didConfigure);
		
#if ForDEVELOPER
		NSPersistentStoreCoordinator *storeCoordinator = self.mainDocument.managedObjectContext.persistentStoreCoordinator;
		
		for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
			FXDLog(@"persistentStore: %@", persistentStore.URL);
			FXDLog(@"metadataForPersistentStore:\n%@", [storeCoordinator metadataForPersistentStore:persistentStore]);
		}
#endif
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			FXDLog(@"2.didConfigure: %d", didConfigure);
#if ForDEVELOPER
			if (error) {
				NSString *title = [NSString stringWithFormat:@"%@", strClassSelector];
				NSString *message = [NSString stringWithFormat:@"FILE: %s\nLINE: %d\nDescription: %@\nFailureReason: %@\nUserinfo: %@", __FILE__, __LINE__, [error localizedDescription], [error localizedFailureReason], [error userInfo]];

				FXDAlertView *alertView = [[FXDAlertView alloc]
										   initWithTitle:title
										   message:message
										   delegate:nil
										   cancelButtonTitle:NSLocalizedString(text_Cancel, nil)
										   otherButtonTitles:nil];
				[alertView show];
			}
#endif
			//TODO: prepare what to do when Core Data is not setup
			[self startObservingCoreDataNotifications];

			//TODO: learn how to handle ubiquitousToken change, and migrate to new persistentStore
			if (didFinishBlock) {
				didFinishBlock(didConfigure);
			}
			else {
				NSDictionary *userInfo = @{@"didConfigure" : [NSNumber numberWithBool:didConfigure]};
				
				[[NSNotificationCenter defaultCenter]
				 postNotificationName:notificationCoreDataManagerDidPrepare
				 object:self
				 userInfo:userInfo];
			}
		}];
	}];
}

- (void)initializeWithBundledCoreDataName:(NSString*)coreDataName {	FXDLog_DEFAULT;
	
	if (coreDataName == nil) {
		coreDataName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	}
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *bundledSqlitePath = [[NSBundle mainBundle] pathForResource:coreDataName ofType:@"sqlite"];
	FXDLog(@"bundledSqlitePath: %@", bundledSqlitePath);
	
	BOOL isBundledWithSqlite = [fileManager fileExistsAtPath:bundledSqlitePath];
	FXDLog(@"isBundledWithSqlite: %d", isBundledWithSqlite);
	
	if (isBundledWithSqlite == NO) {
		return;
	}
	
	
	BOOL isSqliteAlreadyInitialized = [self isSqliteAlreadyInitialized];
	
	if (isSqliteAlreadyInitialized) {
		return;
	}
	
	
	NSString *storedSqlitePath = [appSearhPath_Document stringByAppendingPathComponent:applicationSqlitePathComponent];

	NSError *error = nil;
	
	BOOL didCopy = [fileManager copyItemAtPath:bundledSqlitePath toPath:storedSqlitePath error:&error];
	FXDLog_ERROR;
	
	if (didCopy) {
		FXDLog(@"didCopy: %d", didCopy);
	}
}

- (BOOL)isSqliteAlreadyInitialized {
	NSString *storedSqlitePath = [appSearhPath_Document stringByAppendingPathComponent:applicationSqlitePathComponent];
	FXDLog(@"storedSqlitePath: %@", storedSqlitePath);
	
	BOOL isSqliteAlreadyInitialized = [[NSFileManager defaultManager] fileExistsAtPath:storedSqlitePath];
	FXDLog(@"isSqliteAlreadyInitialized: %d", isSqliteAlreadyInitialized);
	
	return isSqliteAlreadyInitialized;
}

#pragma mark -
- (id)initializedMainEntityObj {
	if (self.mainEntityName == nil) {	FXDLog_OVERRIDE;
		return nil;
	}
	
	
	if ([NSThread isMainThread] == NO) {	FXDLog_OVERRIDE;
		//MARK: Default is to skip
		FXDLog(@"NSThread isMainThread: %d", [NSThread isMainThread]);
		return nil;
	}
	
	
	NSEntityDescription *mainEntityDescription = [NSEntityDescription entityForName:self.mainEntityName inManagedObjectContext:self.mainDocument.managedObjectContext];
	
	id mainEntityObj = [(FXDManagedObject*)[[NSClassFromString(self.mainEntityName) class] alloc] initWithEntity:mainEntityDescription insertIntoManagedObjectContext:self.mainDocument.managedObjectContext];
	
	return mainEntityObj;
}

#pragma mark -
- (void)saveManagedObjectContext:(NSManagedObjectContext*)managedObjectContext didFinishBlock:(void(^)(BOOL finished))didFinishBlock {	FXDLog_SEPARATE;
	
	FXDLog(@"1.hasChanges: %d concurrencyType: %d", managedObjectContext.hasChanges, managedObjectContext.concurrencyType);

	if (managedObjectContext == nil) {
		managedObjectContext = self.mainDocument.managedObjectContext;

		FXDLog(@"2.hasChanges: %d concurrencyType: %d", managedObjectContext.hasChanges, managedObjectContext.concurrencyType);

		if (managedObjectContext.hasChanges == NO
			&& managedObjectContext.concurrencyType != self.mainDocument.managedObjectContext.parentContext.concurrencyType) {
			
			managedObjectContext = self.mainDocument.managedObjectContext.parentContext;

			FXDLog(@"3.hasChanges: %d concurrencyType: %d", managedObjectContext.hasChanges, managedObjectContext.concurrencyType);
		}
	}
	
	
	FXDLog(@"[NSThread isMainThread]: %d", [NSThread isMainThread]);
	FXDLog(@"managedObjectContext: %@ hasChanges: %d concurrencyType: %d", managedObjectContext, managedObjectContext.hasChanges, managedObjectContext.concurrencyType);

	if (managedObjectContext == nil || managedObjectContext.hasChanges == NO) {

		if (didFinishBlock) {
			didFinishBlock(NO);
		}

		return;
	}


	void (^contextSavingBlock)(void) = ^{
		NSError *error = nil;

		BOOL didSave = [managedObjectContext save:&error];

		FXDLog_DEFAULT;
		FXDLog(@"didSave: %d concurrencyType: %d", didSave, managedObjectContext.concurrencyType);
		FXDLog(@"4.hasChanges: %d concurrencyType: %d", managedObjectContext.hasChanges, managedObjectContext.concurrencyType);

		FXDLog_ERROR;LOGEVENT_ERROR;

		if (didFinishBlock) {
			didFinishBlock(didSave);
		}
	};
	
		
	if ([NSThread isMainThread]) {
		[managedObjectContext performBlockAndWait:contextSavingBlock];
	}
	else {
		if (managedObjectContext.concurrencyType == NSPrivateQueueConcurrencyType) {
			[managedObjectContext performBlockAndWait:contextSavingBlock];
		}
		else {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[managedObjectContext  performBlockAndWait:contextSavingBlock];
			}];
		}
	}
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {FXDLog_DEFAULT;
	[self saveManagedObjectContext:nil didFinishBlock:nil];
}

- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self saveManagedObjectContext:nil didFinishBlock:nil];
}

#pragma mark -
- (void)observedFileControlDidUpdateUbiquityContainerURL:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self prepareCoreDataManagerWithUbiquityContainerURL:notification.object withCompleteProtection:NO didFinishBlock:nil];
}

#pragma mark -
- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@", notification.object);

	FXDLog(@"inserted: %d", [(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %d", [(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %d", [(notification.userInfo)[@"updated"] count]);
}

#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
	//FXDLog(@"isEqual:self.managedObjectContext: %@", [notification.object isEqual:self.managedObjectContext] ? @"YES":@"NO");
}

- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
	//FXDLog(@"isEqual:self.managedObjectContext: %@", [notification.object isEqual:self.managedObjectContext] ? @"YES":@"NO");
}

- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
	//FXDLog(@"isEqual:self.managedObjectContext: %@", [notification.object isEqual:self.managedObjectContext] ? @"YES":@"NO");

	// Make notification from main managedObjectContext and private managedObjectContext is distinguished
	if ([notification.object isEqual:self.mainDocument.managedObjectContext] == NO
		|| [(NSManagedObjectContext*)notification.object concurrencyType] == NSPrivateQueueConcurrencyType) {

		FXDLog(@"NOTIFIED: mergeChangesFromContextDidSaveNotification:");
		FXDLog(@"inserted: %d", [(notification.userInfo)[@"inserted"] count]);
		FXDLog(@"deleted: %d", [(notification.userInfo)[@"deleted"] count]);
		FXDLog(@"updated: %d", [(notification.userInfo)[@"updated"] count]);
		
		
		//MARK: Merge only if persistentStore is same
		NSString *mainPersistentStoreUUID = nil;
		
		if ([[[self.mainDocument.managedObjectContext persistentStoreCoordinator] persistentStores] count] > 0) {
			NSPersistentStore *mainPersistentStore = [[self.mainDocument.managedObjectContext persistentStoreCoordinator] persistentStores][0];
			mainPersistentStoreUUID = [mainPersistentStore metadata][@"NSStoreUUID"];
			
			FXDLog(@"mainPersistentStoreUUID: %@", mainPersistentStoreUUID);
		}
		
		NSString *notifyingPersistentStoreUUID = nil;
		
		if ([[[(NSManagedObjectContext*)notification.object persistentStoreCoordinator] persistentStores] count] > 0) {
			NSPersistentStore *notifyingPersistentStore = [[(NSManagedObjectContext*)notification.object persistentStoreCoordinator] persistentStores][0];
			notifyingPersistentStoreUUID = [notifyingPersistentStore metadata][@"NSStoreUUID"];
			
			FXDLog(@"notifyingPersistentStoreUUID: %@", notifyingPersistentStoreUUID);
		}
		
		FXDLog(@"[mainPersistentStoreUUID isEqualToString:notifyingPersistentStoreUUID]: %d", [mainPersistentStoreUUID isEqualToString:notifyingPersistentStoreUUID]);
		
		if (mainPersistentStoreUUID && notifyingPersistentStoreUUID
			&& [mainPersistentStoreUUID isEqualToString:notifyingPersistentStoreUUID]) {
			[self.mainDocument.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
		}
	}
}


//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {
	
	if (controller.additionalDelegate) {
		[controller.additionalDelegate controllerWillChangeContent:controller];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	if (controller.additionalDelegate) {
		[controller.additionalDelegate controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	if (controller.additionalDelegate) {
		[controller.additionalDelegate controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	
	if (controller.additionalDelegate) {
		[controller.additionalDelegate controllerDidChangeContent:controller];
	}
	else {
		//FXDLog_OVERRIDE;
	}
}


@end