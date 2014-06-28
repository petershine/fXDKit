//
//  FXDsuperMainCoredata.m
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperMainCoredata.h"


#pragma mark - Public implementation
@implementation FXDsuperMainCoredata


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
//MARK: Override if using extra data model
- (NSString*)mainModelName {
	
	if (_mainModelName == nil) {	FXDLog_OVERRIDE;
		_mainModelName = application_BundleIdentifier;
		FXDLogObject(_mainModelName);
	}

	return _mainModelName;
}

- (FXDManagedDocument*)mainDocument {
	
	if (_mainDocument == nil) {	FXDLog_DEFAULT;
		NSURL *documentURL = [appDirectory_Document URLByAppendingPathComponent:[NSString stringWithFormat:@"managedDocument.%@", self.mainModelName]];

		_mainDocument = [[FXDManagedDocument alloc] initWithFileURL:documentURL];
		FXDLogObject(_mainDocument);
	}
	
	return _mainDocument;
}

#pragma mark -
- (NSString*)mainSqlitePathComponent {

	//MARK: Use different name for better controlling between developer build and release build
	if (_mainSqlitePathComponent == nil) {	FXDLog_DEFAULT;
		_mainSqlitePathComponent = [NSString stringWithFormat:@".%@.sqlite", self.mainModelName];

	#if ForDEVELOPER
		_mainSqlitePathComponent = [NSString stringWithFormat:@"%@.sqlite", self.mainModelName];
	#endif

		FXDLogObject(_mainSqlitePathComponent);
	}
	
	return _mainSqlitePathComponent;
}

- (NSString*)mainUbiquitousContentName {
	if (_mainUbiquitousContentName == nil) {	FXDLog_DEFAULT;

		_mainUbiquitousContentName = [NSString stringWithFormat:@"ubiquitousContent.%@", self.mainModelName];
		FXDLogObject(_mainUbiquitousContentName);
	}
	
	return _mainUbiquitousContentName;
}

#pragma mark -
- (NSString*)mainEntityName {
	if (_mainEntityName == nil) {	FXDLog_OVERRIDE;
		//SAMPLE: _mainEntityName = entityname<#DefaultClass#>
	}

	return _mainEntityName;
}

- (NSArray*)mainSortDescriptors {
	if (_mainSortDescriptors == nil) {	FXDLog_OVERRIDE;
		//SAMPLE: _mainSortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attribkey<#AttributeName#> ascending:<#NO#>]];
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
- (void)initializeWithBundledSqliteFile:(NSString*)sqliteFile {	FXDLog_DEFAULT;

	if ([self doesStoredSqliteExist]) {
		return;
	}


	NSString *bundledSqlitePath = [[NSBundle mainBundle] pathForResource:sqliteFile ofType:@"sqlite"];
	FXDLogObject(bundledSqlitePath);

	[self storeCopiedItemFromSqlitePath:bundledSqlitePath toStoredPath:nil];
}

- (void)tranferFromOldSqliteFile:(NSString*)sqliteFile {	FXDLog_DEFAULT;

	if ([self doesStoredSqliteExist]) {
		return;
	}


	//MARK: Use different sqlite file. Hide sqlitefile for production version
	NSString *pathComponent = [NSString stringWithFormat:@".%@.sqlite", sqliteFile];

#if ForDEVELOPER
	pathComponent = [NSString stringWithFormat:@"%@.sqlite", sqliteFile];
#endif

	NSString *oldSqlitePath = [appSearhPath_Document stringByAppendingPathComponent:pathComponent];
	FXDLogObject(oldSqlitePath);

	[self storeCopiedItemFromSqlitePath:oldSqlitePath toStoredPath:nil];
}

- (BOOL)doesStoredSqliteExist {
	NSString *storedPath = [appSearhPath_Document stringByAppendingPathComponent:self.mainSqlitePathComponent];
	FXDLogObject(storedPath);

	BOOL storedSqliteExists = [[NSFileManager defaultManager] fileExistsAtPath:storedPath];
	FXDLogBOOL(storedSqliteExists);

	return storedSqliteExists;
}

- (BOOL)storeCopiedItemFromSqlitePath:(NSString*)sqlitePath toStoredPath:(NSString*)storedPath {
	NSFileManager *fileManager = [NSFileManager defaultManager];

	BOOL sqliteExists = [fileManager fileExistsAtPath:sqlitePath];
	FXDLogBOOL(sqliteExists);

	if (sqliteExists == NO) {
		return NO;
	}


	if (storedPath == nil) {
		storedPath = [appSearhPath_Document stringByAppendingPathComponent:self.mainSqlitePathComponent];
	}

	NSError *error = nil;

	BOOL didCopy = [fileManager copyItemAtPath:sqlitePath toPath:storedPath error:&error];
	FXDLogBOOL(didCopy);

	FXDLog_ERROR;
	FXDLog_ERROR_ALERT;

	return didCopy;
}

#pragma mark -
- (void)prepareWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection finishCallback:(FXDcallbackFinish)finishCallback {

	[[NSOperationQueue new]
	 addOperationWithBlock:^{	FXDLog_DEFAULT;
		 FXDLogObject(ubiquityContainerURL);
		 FXDLogBOOL(withCompleteProtection);

		 NSURL *rootURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
		 NSURL *storeURL = [rootURL URLByAppendingPathComponent:self.mainSqlitePathComponent];
		 FXDLogObject(storeURL);


		 NSMutableDictionary *storeOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
		 storeOptions[NSMigratePersistentStoresAutomaticallyOption] = @(YES);
		 storeOptions[NSInferMappingModelAutomaticallyOption] = @(YES);

		 if (ubiquityContainerURL) {	//MARK: If using iCloud
			 //TODO: get UUID unique URL using ubiquityContainerURL instead
			 //NSURL *ubiquitousContentURL = [ubiquityContainerURL URLByAppendingPathComponent:self.mainUbiquitousContentName];
			 NSURL *ubiquitousContentURL = ubiquityContainerURL;
			 FXDLogObject(ubiquitousContentURL);

			 storeOptions[NSPersistentStoreUbiquitousContentNameKey] = self.mainUbiquitousContentName;
			 storeOptions[NSPersistentStoreUbiquitousContentURLKey] = ubiquitousContentURL;
		 }

		 //MARK: NSFileProtectionCompleteUntilFirstUserAuthentication is already used as default
		 if (withCompleteProtection) {
			 storeOptions[NSPersistentStoreFileProtectionKey] = NSFileProtectionComplete;
		 }

		 FXDLogObject(storeOptions);


		 NSError *error = nil;
		 BOOL didConfigure = [self.mainDocument
							  configurePersistentStoreCoordinatorForURL:storeURL
							  ofType:NSSQLiteStoreType
							  modelConfiguration:nil
							  storeOptions:storeOptions
							  error:&error];

		 FXDLog_ERROR;

		 FXDLog(@"1.%@", _BOOL(didConfigure));

#if ForDEVELOPER
		 NSPersistentStoreCoordinator *storeCoordinator = self.mainDocument.managedObjectContext.persistentStoreCoordinator;

		 for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
			 FXDLogObject(persistentStore.URL);
			 FXDLogObject([storeCoordinator metadataForPersistentStore:persistentStore]);
		 }
#endif

		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  FXDAssert_IsMainThread;
			  FXDLog(@"2.%@", _BOOL(didConfigure));

			  //MARK: If iCloud connection is not working, CHECK if cellular transferring is enabled on device"
			  FXDLog_ERROR;
			  FXDLog_ERROR_ALERT;

			  //TODO: learn how to handle ubiquitousToken change, and migrate to new persistentStore
			  //TODO: prepare what to do when Core Data is not setup

			  [self
			   upgradeAllAttributesForNewDataModelWithFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
				   FXDLog_BLOCK(self, caller);

				   [self startObservingCoreDataNotifications];

				   if (finishCallback) {
					   finishCallback(_cmd, didConfigure, nil);
				   }
			   }];
		  }];
	 }];
}

#pragma mark -
- (void)upgradeAllAttributesForNewDataModelWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	//TODO: Learn about NSMigrationPolicy implementation

	if (finishCallback) {
		finishCallback(_cmd, YES, nil);
	}
}

- (void)startObservingCoreDataNotifications {	FXDLog_DEFAULT;
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationDidEnterBackground:)
	 name:UIApplicationDidEnterBackgroundNotification
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIApplicationWillTerminate:)
	 name:UIApplicationWillTerminateNotification
	 object:nil];
	
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIDocumentStateChanged:)
	 name:UIDocumentStateChangedNotification
	 object:nil];
	
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSPersistentStoreDidImportUbiquitousContentChanges:)
	 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
	 object:nil];
	
	
	NSManagedObjectContext *notifyingContext = self.mainDocument.managedObjectContext.parentContext;
	FXDLogObject(notifyingContext);
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSManagedObjectContextObjectsDidChange:)
	 name:NSManagedObjectContextObjectsDidChangeNotification
	 object:notifyingContext];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSManagedObjectContextWillSave:)
	 name:NSManagedObjectContextWillSaveNotification
	 object:notifyingContext];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSManagedObjectContextDidSave:)
	 name:NSManagedObjectContextDidSaveNotification
	 object:notifyingContext];
}

#pragma mark -
- (NSManagedObject*)initializedMainEntityObj {
	if (self.mainEntityName == nil) {	FXDLog_OVERRIDE;
		return nil;
	}
	
	
	if ([NSThread isMainThread] == NO) {	FXDLog_OVERRIDE;
		FXDLog_IsMainThread;
		return nil;
	}
	
	
	NSEntityDescription *mainEntity = [NSEntityDescription entityForName:self.mainEntityName inManagedObjectContext:self.mainDocument.managedObjectContext];

	if (mainEntity == nil) {
		return nil;
	}

	
	NSManagedObject *mainEntityObj = [(NSManagedObject*)[[NSClassFromString(self.mainEntityName) class] alloc] initWithEntity:mainEntity insertIntoManagedObjectContext:self.mainDocument.managedObjectContext];
	
	return mainEntityObj;
}

#pragma mark -
- (void)deleteAllDataWithFinishCallback:(FXDcallbackFinish)finishCallback {
	
	[(FXDWindow*)[UIApplication mainWindow]
	 showMessageViewWithNibName:nil
	 withTitle:NSLocalizedString(@"Do want to delete ALL?", nil)
	 message:NSLocalizedString(@"Please be warned. Deleted data WILL NEVER BE RESTORED!", nil)
	 cancelButtonTitle:NSLocalizedString(text_Cancel, nil)
	 acceptButtonTitle:NSLocalizedString(text_DeleteAll, nil)
	 clickedButtonAtIndexBlock:^(id alertObj, NSInteger buttonIndex) {
		 FXDLog(@"%@, %@", _Object(alertObj), _Variable(buttonIndex));

		 //MARK: Assume buttonIndex == 1: is Accept
		 if (buttonIndex == 1) {
			 [self
			  enumerateAllMainEntityObjShouldShowProgressView:YES
			  withEnumerationBlock:^(NSManagedObjectContext *managedContext,
									 NSManagedObject *mainEntityObj,
									 BOOL *shouldBreak) {
				  
				  //TODO: Implement shouldBreak different, making this block to return boolean
				  if (*shouldBreak) {
					  FXDLogBOOL(*shouldBreak);
				  }
				  
				  [managedContext deleteObject:mainEntityObj];
				  
			  } withFinishCallback:finishCallback];
		 }
	 }];
}

#pragma mark -
- (void)enumerateAllMainEntityObjShouldShowProgressView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback {
	
	[self
	 enumerateAllMainEntityObjShouldUsePrivateContext:NO
	 shouldSaveAtTheEnd:YES
	 shouldShowProgressView:shouldShowProgressView
	 withEnumerationBlock:enumerationBlock
	 withFinishCallback:finishCallback];
}

- (void)enumerateAllMainEntityObjShouldUsePrivateContext:(BOOL)shouldUsePrivateContext shouldSaveAtTheEnd:(BOOL)shouldSaveAtTheEnd shouldShowProgressView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	
	FXDLogBOOL(shouldUsePrivateContext);
	FXDLog(@"0.%@", _Variable(self.didStartEnumerating));
	
	//TODO: Decide if returning is not appropriate
	if (self.didStartEnumerating) {
		return;
	}
	
	
	self.didStartEnumerating = YES;


	UIApplication *application = [UIApplication sharedApplication];

	__weak FXDsuperMainCoredata *weakSelf = self;

	weakSelf.enumeratingTask =
	[application
	 beginBackgroundTaskWithExpirationHandler:^{
		__strong FXDsuperMainCoredata *strongSelf = weakSelf;

		if (strongSelf) {
			[application endBackgroundTask:strongSelf.enumeratingTask];
			strongSelf.enumeratingTask = UIBackgroundTaskInvalid;
		}
	}];

	FXDLogVariable(self.enumeratingTask);
	
	
	FXDWindow *mainWindow = nil;
	
	if (shouldShowProgressView) {
		mainWindow = (FXDWindow*)[UIApplication mainWindow];
		[mainWindow showProgressViewWithNibName:nil];
	}
	
	
	__block BOOL shouldBreak = NO;
	
	NSManagedObjectContext *managedContext = (shouldUsePrivateContext) ? self.mainDocument.managedObjectContext.parentContext:self.mainDocument.managedObjectContext;
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{
		 
		 NSArray *fetchedObjArray = [managedContext
									 fetchedObjArrayForEntityName:self.mainEntityName
									 withSortDescriptors:self.mainSortDescriptors
									 withPredicate:nil
									 withLimit:limitInfiniteFetch];
		 
		 for (NSManagedObject *fetchedObj in fetchedObjArray) {
			 if (shouldBreak) {	//MARK: Evaluate case for an item breaking the enumeration itself
				 break;
			 }
			 
			 
			 if (enumerationBlock) {
				 NSManagedObject *mainEntityObj = [managedContext objectWithID:[fetchedObj objectID]];
				 
				 if (shouldUsePrivateContext) {
					 enumerationBlock(managedContext, mainEntityObj, &shouldBreak);
				 }
				 else {
					 [[NSOperationQueue mainQueue]
					  addOperationWithBlock:^{
						  enumerationBlock(managedContext, mainEntityObj, &shouldBreak);
					  }];
				 }
			 }
			 
			 FXDLog_REMAINING;
		 }
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  FXDLog(@"1.%@", _Variable(self.didStartEnumerating));
			  self.didStartEnumerating = NO;
			  FXDLog(@"2.%@", _Variable(self.didStartEnumerating));
			  
			  
			  void (^DidEnumerateBlock)(BOOL) = ^(BOOL didFinish) {
				  FXDLog(@"1.%@ %@", _BOOL(didFinish), _BOOL(shouldBreak));
				  
				  if (shouldShowProgressView) {
					  [mainWindow hideProgressView];
				  }
				  
				  if (shouldBreak) {
					  didFinish = NO;
				  }
				  
				  FXDLog(@"2.%@ %@", _BOOL(didFinish), _BOOL(shouldBreak));
				  
				  if (finishCallback) {
					  finishCallback(_cmd, didFinish, nil);
				  }


				  FXDLog_REMAINING;

				  FXDLogVariable(self.enumeratingTask);
				  
				  [application endBackgroundTask:self.enumeratingTask];
				  self.enumeratingTask = UIBackgroundTaskInvalid;
			  };
			  
			  
			  if (shouldSaveAtTheEnd == NO) {
				  DidEnumerateBlock(YES);
				  
				  return;
			  }
			  
			  
			  [self
			   saveMainDocumentShouldSkipMerge:NO
			   withFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
				   DidEnumerateBlock(didFinish);
			   }];
		  }];
	 }];
}

#pragma mark -
- (void)saveManagedContext:(NSManagedObjectContext*)managedContext withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_SEPARATE;
	
	FXDLog(@"1.%@ %@", _BOOL(managedContext.hasChanges), _Variable(managedContext.concurrencyType));

	if (managedContext == nil) {
		managedContext = self.mainDocument.managedObjectContext;

		FXDLog(@"2.%@ %@", _BOOL(managedContext.hasChanges), _Variable(managedContext.concurrencyType));

		if (managedContext.hasChanges == NO
			&& managedContext.concurrencyType != self.mainDocument.managedObjectContext.parentContext.concurrencyType) {
			
			managedContext = self.mainDocument.managedObjectContext.parentContext;

			FXDLog(@"3.%@ %@", _BOOL(managedContext.hasChanges), _Variable(managedContext.concurrencyType));
		}
	}

	FXDLog(@"%@ %@ %@", _Object(managedContext), _BOOL(managedContext.hasChanges), _Variable(managedContext.concurrencyType));

	if (managedContext == nil || managedContext.hasChanges == NO) {

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}

		return;
	}

	
	void (^ManagedContextSavingBlock)(void) = ^{
		NSError *error = nil;
		BOOL didSave = [managedContext save:&error];
		FXDLog_ERROR;

		FXDLog_DEFAULT;
		FXDLog(@"%@ %@", _BOOL(didSave), _Variable(managedContext.concurrencyType));
		FXDLog(@"4.%@ %@", _BOOL(managedContext.hasChanges), _Variable(managedContext.concurrencyType));
		
		if (finishCallback) {
			finishCallback(_cmd, didSave, nil);
		}
	};


	FXDLog_IsMainThread;
	
	if ([NSThread isMainThread]) {
		[managedContext performBlockAndWait:ManagedContextSavingBlock];
	}
	else {
		ManagedContextSavingBlock();
	}
}

- (void)saveMainDocumentShouldSkipMerge:(BOOL)shouldSkipMerge withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_SEPARATE;
	
	FXDLogBOOL(shouldSkipMerge);
	FXDLog(@"1.%@", _Variable(self.mainDocument.documentState));
	FXDLog(@"1.%@", _BOOL([self.mainDocument hasUnsavedChanges]));
	
	if (shouldSkipMerge) {
		self.shouldMergeForManagedContext = NO;
	}
	else {
		self.shouldMergeForManagedContext = YES;
	}
	
	FXDLogBOOL(self.shouldMergeForManagedContext);
	
	
	[self.mainDocument
	 saveToURL:self.mainDocument.fileURL
	 forSaveOperation:UIDocumentSaveForOverwriting
	 completionHandler:^(BOOL success) {
		 FXDLog_BLOCK(self.mainDocument, @selector(saveToURL:forSaveOperation:completionHandler:));
		 FXDLogBOOL(success);
		 
		 FXDLog(@"2.%@", _Variable(self.mainDocument.documentState));
		 FXDLog(@"2.%@", _BOOL([self.mainDocument hasUnsavedChanges]));
		 
		 if (finishCallback) {
			 finishCallback(_cmd, success, nil);
		 }
	 }];
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {FXDLog_DEFAULT;
	//MARK: Re-consider about saving context here
}

- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog_REMAINING;

	UIApplication *application = [UIApplication sharedApplication];

	__weak FXDsuperMainCoredata *weakSelf = self;

	weakSelf.dataSavingTask =
	[application
	 beginBackgroundTaskWithExpirationHandler:^{
		 __strong FXDsuperMainCoredata *strongSelf = weakSelf;

		 if (strongSelf) {
			 [application endBackgroundTask:strongSelf.dataSavingTask];
			 strongSelf.dataSavingTask = UIBackgroundTaskInvalid;
		 }
	 }];
	
	FXDLogVariable(self.dataSavingTask);


	[self
	 saveMainDocumentShouldSkipMerge:NO
	 withFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
		 FXDLog_BLOCK(self, caller);

		 FXDLog_REMAINING;

		 FXDLogVariable(self.dataSavingTask);

		 [application endBackgroundTask:self.dataSavingTask];
		 self.dataSavingTask = UIBackgroundTaskInvalid;
	 }];
}

#pragma mark -
- (void)observedUIDocumentStateChanged:(NSNotification*)notification {	FXDLog_DEFAULT;
	//notification: NSConcreteNotification 0x1a3746e0 {name = UIDocumentStateChangedNotification; object = <FXDManagedDocument: 0x16d94d10> fileURL: file:///var/mobile/Applications/A2651A45-6230-4225-A538-420889FD5693/Documents/managed.coredata.document documentState: [EditingDisabled | SavingError]}

	FXDLogObject(notification);
	FXDLogObject(self.mainDocument.fileModificationDate);
	FXDLogVariable(self.mainDocument.documentState);
}

#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@", _Object(notification.object), _Variable([(NSManagedObjectContext*)notification.object concurrencyType]));
}

- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@", _Object(notification.object), _Variable([(NSManagedObjectContext*)notification.object concurrencyType]));
}

- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"%@ %@", _Object(notification.object), _Variable([(NSManagedObjectContext*)notification.object concurrencyType]));
	FXDLogBOOL([notification.object isEqual:self.mainDocument.managedObjectContext]);

	// Distinguish notification from main managedObjectContext and private managedObjectContext
	if ([notification.object isEqual:self.mainDocument.managedObjectContext]) {
		return;
	}
	
	
	FXDLog_IsMainThread;
	FXDLog(@"NOTIFIED: mergeChangesFromContextDidSaveNotification:");
	FXDLog(@"inserted: %lu", (unsigned long)[(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %lu", (unsigned long)[(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %lu", (unsigned long)[(notification.userInfo)[@"updated"] count]);
	
	//MARK: Merge only if persistentStore is same
	NSString *mainStoreUUID = nil;
	NSInteger mainStoreIndex = 0;	//MARK: Assume first one is the mainStore
	
	if ([[self.mainDocument.managedObjectContext persistentStoreCoordinator] persistentStores].count > 0) {
		NSPersistentStore *mainPersistentStore = [[self.mainDocument.managedObjectContext persistentStoreCoordinator] persistentStores][mainStoreIndex];
		mainStoreUUID = [mainPersistentStore metadata][@"NSStoreUUID"];
		
		FXDLogObject(mainStoreUUID);
	}
	
	NSString *notifyingStoreUUID = nil;
	
	if ([[(NSManagedObjectContext*)notification.object persistentStoreCoordinator] persistentStores].count > 0) {
		NSPersistentStore *notifyingPersistentStore = [[(NSManagedObjectContext*)notification.object persistentStoreCoordinator] persistentStores][mainStoreIndex];
		notifyingStoreUUID = [notifyingPersistentStore metadata][@"NSStoreUUID"];
		
		FXDLogObject(notifyingStoreUUID);
	}
	
	FXDLogBOOL([mainStoreUUID isEqualToString:notifyingStoreUUID]);
	
	FXDLog(@"1.%@", _BOOL(self.shouldMergeForManagedContext));
	
	if (mainStoreUUID && notifyingStoreUUID && [mainStoreUUID isEqualToString:notifyingStoreUUID]) {

		//MARK: Unless save is done for private context in background, you can skip merging"
		if (self.shouldMergeForManagedContext) {
			[self.mainDocument.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
			FXDLog(@"DID MERGE: %@", _BOOL(self.mainDocument.managedObjectContext.hasChanges));
		}
		
		self.shouldMergeForManagedContext = NO;
	}
	
	FXDLog(@"2.%@", _BOOL(self.shouldMergeForManagedContext));
}

#pragma mark -
- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLogObject(notification.object);
	
	FXDLog(@"inserted: %lu", (unsigned long)[(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %lu", (unsigned long)[(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %lu", (unsigned long)[(notification.userInfo)[@"updated"] count]);
}


//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {
	
	__strong id<NSFetchedResultsControllerDelegate> strongDelegate = controller.extraDelegate;
	[strongDelegate controllerWillChangeContent:controller];
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	
	__strong id<NSFetchedResultsControllerDelegate> strongDelegate = controller.extraDelegate;
	[strongDelegate controllerDidChangeContent:controller];
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	__strong id<NSFetchedResultsControllerDelegate> strongDelegate = controller.extraDelegate;
	[strongDelegate controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	__strong id<NSFetchedResultsControllerDelegate> strongDelegate = controller.extraDelegate;	
	[strongDelegate controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

@end