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
		//_mainSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attribkey<#AttributeName#> ascending:<#NO#>]];
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
- (void)startObservingCloudManagerNotifications {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedCloudManagerDidUpdateUbiquityContainerURL:)
	 name:notificationCloudManagerDidUpdateUbiquityContainerURL
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
- (void)enumerateAllMainEntityObjWithDefaultProgressView:(BOOL)withDefaultProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *mainManagedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withDidFinishBlock:(void(^)(BOOL finished))didFinishBlock {	FXDLog_DEFAULT;
	
	FXDLog(@"0.self.didStartEnumerating: %d", self.didStartEnumerating);
	
	//TODO: Decide if returning is not appropriate
	if (self.didStartEnumerating) {
		return;
	}
	
	
	self.didStartEnumerating = YES;
	
	
	UIApplication *sharedApplication = [UIApplication sharedApplication];
	
	self.enumeratingTaskIdentifier = [sharedApplication
									  beginBackgroundTaskWithExpirationHandler:^{								  
										  [sharedApplication endBackgroundTask:self.enumeratingTaskIdentifier];
										  self.enumeratingTaskIdentifier = UIBackgroundTaskInvalid;
									  }];
	FXDLog(@"self.enumeratingTaskIdentifier: %u", self.enumeratingTaskIdentifier);
	
	
	FXDWindow *applicationWindow = nil;
	
	if (withDefaultProgressView) {
		applicationWindow = [FXDWindow applicationWindow];
		[applicationWindow showDefaultProgressView];
	}

	
	__block BOOL shouldBreak = NO;
	
	NSManagedObjectContext *managedContext = self.mainDocument.managedObjectContext;
	
	[[NSOperationQueue new] addOperationWithBlock:^{
				
		NSArray *fetchedObjArray = [managedContext
									fetchedObjArrayForEntityName:self.mainEntityName
									withSortDescriptors:self.mainSortDescriptors
									withPredicate:nil
									withLimit:limitInfiniteFetch];
		
		for (NSManagedObject *fetchedObj in fetchedObjArray) {
			if (shouldBreak) {
				break;
			}
			
			
			if (enumerationBlock) {
				NSManagedObject *mainEntityObj = [managedContext objectWithID:[fetchedObj objectID]];
				
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					enumerationBlock(managedContext, mainEntityObj, &shouldBreak);
				}];
			}
			
			FXDLog_REMAINING;
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			FXDLog(@"1.self.didStartEnumerating: %d", self.didStartEnumerating);
			self.didStartEnumerating = NO;
			FXDLog(@"2.self.didStartEnumerating: %d", self.didStartEnumerating);
			
			
			[self
			 saveManagedObjectContext:managedContext
			 didFinishBlock:^(BOOL finished) {
				 FXDLog(@"saveManagedObjectContext finished: %d shouldBreak: %d", finished, shouldBreak);
				 
				 if (withDefaultProgressView) {
					 [applicationWindow hideProgressView];
				 }
				 
				 if (shouldBreak) {
					 finished = NO;
				 }
				 
				 
				 FXDLog(@"1.enumeratingTaskIdentifier: %u", self.enumeratingTaskIdentifier);
				 FXDLog_REMAINING;
				 
				 if (self.enumeratingTaskIdentifier != UIBackgroundTaskInvalid) {
					 
					 [[UIApplication sharedApplication] endBackgroundTask:self.enumeratingTaskIdentifier];
					 self.enumeratingTaskIdentifier = UIBackgroundTaskInvalid;
					 
					 FXDLog(@"2.enumeratingTaskIdentifier: %u", self.enumeratingTaskIdentifier);
				 }
				 
				 if (didFinishBlock) {
					 didFinishBlock(finished);
				 }
			 }];
		}];
	}];
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
	
	//TEST:
#warning "//TODO: Find the right way to use performBlockAndWait with concurrency"
	//contextSavingBlock();
	if ([NSThread isMainThread]) {
		[managedObjectContext performBlockAndWait:contextSavingBlock];
		
		/*
		if (managedObjectContext.concurrencyType == NSPrivateQueueConcurrencyType) {
			[managedObjectContext performBlock:contextSavingBlock];
		}
		else {
			[managedObjectContext performBlockAndWait:contextSavingBlock];
		}
		 */
	}
	else {
		/*
		if (managedObjectContext.concurrencyType == NSPrivateQueueConcurrencyType) {
			[managedObjectContext performBlock:contextSavingBlock];
			//[managedObjectContext performBlockAndWait:contextSavingBlock];
		}
		else {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[managedObjectContext performBlockAndWait:contextSavingBlock];
			}];
		}
		 */
		contextSavingBlock();
	}
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {FXDLog_DEFAULT;
#warning "//TODO: Check if following error is caused at here, and can be fixed:\
NSInternalInconsistencyException', reason: 'statement is still active'"
	
	//TEST:
	//[self saveManagedObjectContext:nil didFinishBlock:nil];
}

- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_DEFAULT;
	
	//TEST:
	//[self saveManagedObjectContext:nil didFinishBlock:nil];
}

#pragma mark -
- (void)observedCloudManagerDidUpdateUbiquityContainerURL:(NSNotification*)notification {	FXDLog_DEFAULT;
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
}

- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
}

- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %d", notification.object, [(NSManagedObjectContext*)notification.object concurrencyType]);
	FXDLog(@"isEqual:self.mainDocument.managedObjectContext: %@", [notification.object isEqual:self.mainDocument.managedObjectContext] ? @"YES":@"NO");

	// Distinguish notification from main managedObjectContext and private managedObjectContext
	if ([notification.object isEqual:self.mainDocument.managedObjectContext]) {
		return;
	}
	
	
	FXDLog(@"NSThread isMainThread: %d", [NSThread isMainThread]);
	FXDLog(@"NOTIFIED: mergeChangesFromContextDidSaveNotification:");
	FXDLog(@"inserted: %d", [(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %d", [(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %d", [(notification.userInfo)[@"updated"] count]);
	
	//MARK: Merge only if persistentStore is same
	NSString *mainStoreUUID = nil;
	NSInteger mainStoreIndex = 0;	//MARK: Assume first one is the mainStore
	
	if ([[[self.mainDocument.managedObjectContext persistentStoreCoordinator] persistentStores] count] > 0) {
		NSPersistentStore *mainPersistentStore = [[self.mainDocument.managedObjectContext persistentStoreCoordinator] persistentStores][mainStoreIndex];
		mainStoreUUID = [mainPersistentStore metadata][@"NSStoreUUID"];
		
		FXDLog(@"mainStoreUUID: %@", mainStoreUUID);
	}
	
	NSString *notifyingStoreUUID = nil;
	
	if ([[[(NSManagedObjectContext*)notification.object persistentStoreCoordinator] persistentStores] count] > 0) {
		NSPersistentStore *notifyingPersistentStore = [[(NSManagedObjectContext*)notification.object persistentStoreCoordinator] persistentStores][mainStoreIndex];
		notifyingStoreUUID = [notifyingPersistentStore metadata][@"NSStoreUUID"];
		
		FXDLog(@"notifyingStoreUUID: %@", notifyingStoreUUID);
	}
	
	FXDLog(@"[mainStoreUUID isEqualToString:notifyingStoreUUID]: %d", [mainStoreUUID isEqualToString:notifyingStoreUUID]);
	
	FXDLog(@"1.self.shouldMergeForManagedContext: %d", self.shouldMergeForManagedContext);
	
	if (mainStoreUUID && notifyingStoreUUID && [mainStoreUUID isEqualToString:notifyingStoreUUID]) {
#warning "//MARK: Unless save is done for private context in background, it's not NECESSARY"
		
		if (self.shouldMergeForManagedContext) {
			[self.mainDocument.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
			FXDLog(@"DID MERGE: self.mainDocument.managedObjectContext.hasChanges: %d", self.mainDocument.managedObjectContext.hasChanges);
		}
		
		self.shouldMergeForManagedContext = NO;
	}
	
	FXDLog(@"2.self.shouldMergeForManagedContext: %d", self.shouldMergeForManagedContext);
}


//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {
	
	__strong typeof(controller.additionalDelegate) _strongDelegate = controller.additionalDelegate;
	
	if (_strongDelegate == nil) {
		return;
	}
	
	
	[_strongDelegate controllerWillChangeContent:controller];
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	__strong typeof(controller.additionalDelegate) _strongDelegate = controller.additionalDelegate;
	
	if (_strongDelegate == nil) {
		return;
	}
	
	
	[_strongDelegate controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	__strong typeof(controller.additionalDelegate) _strongDelegate = controller.additionalDelegate;
	
	if (_strongDelegate == nil) {
		return;
	}
	
	
	[_strongDelegate controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	
	__strong typeof(controller.additionalDelegate) _strongDelegate = controller.additionalDelegate;
	
	if (_strongDelegate == nil) {
		return;
	}
	
	
	[_strongDelegate controllerDidChangeContent:controller];
}


@end