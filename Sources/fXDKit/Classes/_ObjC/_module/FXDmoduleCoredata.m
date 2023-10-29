

#import "FXDmoduleCoredata.h"


@implementation FXDmoduleCoredata

#pragma mark - Memory management
- (void)dealloc {
	[_enumeratingOperationQueue cancelAllOperations];
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSOperationQueue*)enumeratingOperationQueue {
	if (_enumeratingOperationQueue == nil) {
		_enumeratingOperationQueue = [NSOperationQueue newSerialQueueWithName:NSStringFromSelector(_cmd)];
	}
	return _enumeratingOperationQueue;
}

#pragma mark -
- (NSString*)coredataName {
	if (_coredataName == nil) {
		_coredataName = application_BundleIdentifier;

		FXDLog_OVERRIDE;
		FXDLogObject(_coredataName);
	}

	return _coredataName;
}

- (NSString*)ubiquitousContentName {
	if (_ubiquitousContentName == nil) {
		_ubiquitousContentName = [self.coredataName stringByReplacingOccurrencesOfString:@"." withString:@"_"];

		FXDLog_OVERRIDE;
		FXDLogObject(_ubiquitousContentName);
	}

	return _ubiquitousContentName;
}

- (NSString*)sqlitePathComponent {
	
	//MARK: Use different name for better controlling between developer build and release build
	if (_sqlitePathComponent == nil) {
		_sqlitePathComponent = [NSString stringWithFormat:@"%@.sqlite", self.coredataName];

	#if DEBUG
		_sqlitePathComponent = [NSString stringWithFormat:@"DEV_%@.sqlite", self.coredataName];
	#endif

		FXDLog_OVERRIDE;
		FXDLogObject(_sqlitePathComponent);
	}
	
	return _sqlitePathComponent;
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


#pragma mark - Method overriding

#pragma mark - Public
- (void)initializeWithBundledSqliteFile:(NSString*)sqliteFile {

	if (self.doesStoredSqliteExist) {
		return;
	}


	FXDLog_DEFAULT

	NSString *bundledSqlitePath = [[NSBundle mainBundle] pathForResource:sqliteFile ofType:@"sqlite"];
	FXDLogObject(bundledSqlitePath);

	[self storeCopiedItemFromSqlitePath:bundledSqlitePath toStoredPath:nil];
}

- (void)transferFromOldSqliteFile:(NSString*)sqliteFile {

	if (self.doesStoredSqliteExist) {
		return;
	}


	FXDLog_DEFAULT
	
	NSString *pathComponent = [NSString stringWithFormat:@"%@.sqlite", sqliteFile];

	NSString *oldSqlitePath = [appSearhPath_Document stringByAppendingPathComponent:pathComponent];
	FXDLogObject(oldSqlitePath);

	[self storeCopiedItemFromSqlitePath:oldSqlitePath toStoredPath:nil];
}

- (BOOL)doesStoredSqliteExist {	FXDLog_DEFAULT
	NSString *storedPath = [appSearhPath_Document stringByAppendingPathComponent:self.sqlitePathComponent];
	FXDLogObject(storedPath);

	BOOL storedSqliteExists = [[NSFileManager defaultManager] fileExistsAtPath:storedPath];
	FXDLogBOOL(storedSqliteExists);

	return storedSqliteExists;
}

- (BOOL)storeCopiedItemFromSqlitePath:(NSString*)sqlitePath toStoredPath:(NSString*)storedPath {	FXDLog_DEFAULT
	NSFileManager *fileManager = [NSFileManager defaultManager];

	BOOL sqliteExists = [fileManager fileExistsAtPath:sqlitePath];
	FXDLogBOOL(sqliteExists);

	if (sqliteExists == NO) {
		return NO;
	}


	if (storedPath == nil) {
		storedPath = [appSearhPath_Document stringByAppendingPathComponent:self.sqlitePathComponent];
	}

	NSError *error = nil;

	BOOL didCopy = [fileManager copyItemAtPath:sqlitePath toPath:storedPath error:&error];
	FXDLogBOOL(didCopy);
	FXDLog_ERROR;


	return didCopy;
}

#pragma mark -
- (void)prepareWithUbiquityContainerURL:(nullable NSURL*)ubiquityContainerURL protectionOption:(nullable NSString*)protectionOption managedDocument:(nullable FXDManagedDocument*)managedDocument finishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT

	if (managedDocument == nil) {
		FXDLog(@"CHECK if bundle has more than 1 momd");

		NSURL *documentURL = [appDirectory_Document URLByAppendingPathComponent:[NSString stringWithFormat:@"managedDocument.%@", self.coredataName]];

		//MARK: Models may merge manually
		managedDocument = [[FXDManagedDocument alloc] initWithFileURL:documentURL];
	}


	FXDLogObject(ubiquityContainerURL);
	FXDLogObject(protectionOption);
	FXDLogObject(managedDocument);

	self.mainDocument = managedDocument;


	NSURL *rootURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
	NSURL *storeURL = [rootURL URLByAppendingPathComponent:self.sqlitePathComponent];
	FXDLogObject(storeURL);


	NSMutableDictionary *storeOptions = [[NSMutableDictionary alloc] initWithCapacity:0];
	storeOptions[NSMigratePersistentStoresAutomaticallyOption] = @(YES);
	storeOptions[NSInferMappingModelAutomaticallyOption] = @(YES);

	if (ubiquityContainerURL) {
		//DEPRECATED: API_DEPRECATED("Please see the release notes and Core Data documentation.", macosx(10.7,10.12), ios(5.0,10.0));
		/*
		storeOptions[NSPersistentStoreUbiquitousContentNameKey] = self.ubiquitousContentName;
		storeOptions[NSPersistentStoreUbiquitousContentURLKey] = ubiquityContainerURL;
		 */
	}

	//MARK: NSFileProtectionCompleteUntilFirstUserAuthentication is already used as default
	if (protectionOption.length > 0) {
		storeOptions[NSPersistentStoreFileProtectionKey] = protectionOption;
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

#if DEBUG
	NSPersistentStoreCoordinator *storeCoordinator = self.mainDocument.managedObjectContext.persistentStoreCoordinator;

	for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
		FXDLogObject(persistentStore.URL);
		FXDLogObject([storeCoordinator metadataForPersistentStore:persistentStore]);
	}
#endif

	FXDAssert_IsMainThread;
	FXDLog(@"2.%@", _BOOL(didConfigure));

	//MARK: If iCloud connection is not working, CHECK if cellular transferring is enabled on device"
	FXDLog_ERROR;


	FXDLogObject([UIManagedDocument persistentStoreName]);

	FXDLogObject(self.mainDocument.modelConfiguration);
	FXDLogObject(self.mainDocument.managedObjectModel.versionIdentifiers);
	FXDLogObject(self.mainDocument.managedObjectModel.entities);


	[self
	 upgradeAllAttributesForNewDataModelWithFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
		 FXDLog_BLOCK(self, caller);

#if DEBUG
		 if (ubiquityContainerURL) {
			 NSFileManager *fileManager = [NSFileManager defaultManager];
			 FXDLogObject([fileManager infoDictionaryForFolderURL:ubiquityContainerURL]);
			 FXDLogObject([fileManager infoDictionaryForFolderURL:appDirectory_Caches]);
			 FXDLogObject([fileManager infoDictionaryForFolderURL:appDirectory_Document]);
		 }
#endif

		 if (finishCallback) {
			 finishCallback(_cmd, didConfigure, nil);
		 }

		 //MARK: Careful with order of operations
		 [self startObservingCoreDataNotifications];
	 }];
}

#pragma mark -
- (void)upgradeAllAttributesForNewDataModelWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_OVERRIDE;
	//TODO: Learn about NSMigrationPolicy implementation

	if (finishCallback) {
		finishCallback(_cmd, YES, nil);
	}
}

#pragma mark -
- (void)startObservingCoreDataNotifications {	FXDLog_DEFAULT
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
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
	

	//DEPRECATED: API_DEPRECATED("Please see the release notes and Core Data documentation.", macosx(10.7,10.12), ios(5.0,10.0));
	/*
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedNSPersistentStoreDidImportUbiquitousContentChanges:)
	 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
	 object:nil];
	 */
	
	
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
- (void)deleteAllDataWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT

	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:nil
										  message:nil
										  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *cancelAction =
	[UIAlertAction
	 actionWithTitle:NSLocalizedString(@"Cancel", nil)
	 style:UIAlertActionStyleCancel
	 handler:^(UIAlertAction * _Nonnull action) {
		 if (finishCallback) {
			 finishCallback(_cmd, NO, nil);
		 }
	 }];

	UIAlertAction *deleteAllAction =
	[UIAlertAction
	 actionWithTitle:NSLocalizedString(@"Delete All", nil)
	 style:UIAlertActionStyleDestructive
	 handler:^(UIAlertAction * _Nonnull action) {

		 [self
		  enumerateAllDataWithPrivateContext:NO
		  shouldShowInformationView:YES
		  withEnumerationBlock:^(NSManagedObjectContext *managedContext,
								 NSManagedObject *mainEntityObj,
								 BOOL *shouldBreak) {

			  if (*shouldBreak) {
				  FXDLogBOOL(*shouldBreak);
			  }

			  [managedContext deleteObject:mainEntityObj];
		  }
		  withFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
			  FXDLog_BLOCK(self, caller);

			  [self saveMainDocumentWithFinishCallback:finishCallback];
		  }];
	 }];

	[alertController addAction:deleteAllAction];
	[alertController addAction:cancelAction];

	UIWindow *mainWindow = [[UIApplication sharedApplication] performSelector:@selector(mainWindow:)];
	FXDLogObject(mainWindow);

	UIViewController *presentingScene = mainWindow.rootViewController;
	FXDLogObject(presentingScene);

	[presentingScene
	 presentViewController:alertController
	 animated:YES
	 completion:nil];
}

#pragma mark -
- (void)enumerateAllDataWithPrivateContext:(BOOL)shouldUsePrivateContext shouldShowInformationView:(BOOL)shouldShowProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT
	
	FXDLogBOOL(shouldUsePrivateContext);
	FXDLogVariable(self.enumeratingOperationQueue.operationCount);

	if (self.enumeratingOperationQueue.operationCount > 0) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	UIApplication *application = [UIApplication sharedApplication];

	__weak FXDmoduleCoredata *weakSelf = self;

	weakSelf.enumeratingTask =
	[application
	 beginBackgroundTaskWithExpirationHandler:^{
		__strong FXDmoduleCoredata *strongSelf = weakSelf;

		if (strongSelf) {
			[application endBackgroundTask:strongSelf.enumeratingTask];
			strongSelf.enumeratingTask = UIBackgroundTaskInvalid;
		}
	}];

	FXDLogVariable(weakSelf.enumeratingTask);
	
	
	UIWindow *mainWindow = nil;
	
	if (shouldShowProgressView) {
		mainWindow = [[UIApplication sharedApplication] performSelector:@selector(mainWindow:)];
		[mainWindow performSelector:@selector(showInformationView:)];
	}
	
	
	__block BOOL shouldBreak = NO;
	
	NSManagedObjectContext *managedContext = (shouldUsePrivateContext) ? weakSelf.mainDocument.managedObjectContext.parentContext:weakSelf.mainDocument.managedObjectContext;

	[weakSelf.enumeratingOperationQueue
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
				 NSManagedObject *mainEntityObj = [managedContext objectWithID:fetchedObj.objectID];
				 
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

		 
		 [[NSOperationQueue currentQueue]
		  addOperationWithBlock:^{
			  FXDLog_BLOCK(weakSelf, _cmd);

			  if (shouldShowProgressView) {
				  [mainWindow performSelector:@selector(hideInformationView:)];
			  }

			  FXDLogBOOL(!shouldBreak);

			  if (finishCallback) {
				  finishCallback(_cmd, !shouldBreak, nil);
			  }


			  FXDLog_REMAINING;

			  FXDLogVariable(weakSelf.enumeratingTask);

			  [application endBackgroundTask:weakSelf.enumeratingTask];
			  weakSelf.enumeratingTask = UIBackgroundTaskInvalid;
		  }];
	 }];
}

#pragma mark -
- (void)saveManagedContext:(NSManagedObjectContext*)managedContext withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_SEPARATE;
	//TODO: Evaluate if this method is necessary
	
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

		FXDLog_DEFAULT
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

- (void)saveMainDocumentWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_SEPARATE;
	FXDLogVariable(self.mainDocument.documentState);
	FXDLogBOOL([self.mainDocument hasUnsavedChanges]);

	//MAR: Following error may happen for iOS 11
	/*
	 2017-09-28 22:39:05.884304-0400 PopToo[5616:173973] [default] [ERROR] Could not get attribute values for item file:///
	 Error: Error Domain=NSFileProviderInternalErrorDomain Code=1 "The reader is not permitted to access the URL." UserInfo={NSLocalizedDescription=The reader is not permitted to access the URL.}
	 */


	[self.mainDocument
	 saveToURL:self.mainDocument.fileURL
	 forSaveOperation:UIDocumentSaveForOverwriting
	 completionHandler:^(BOOL success) {
		 FXDLog_BLOCK(self.mainDocument, @selector(saveToURL:forSaveOperation:completionHandler:));
		 FXDLogBOOL(success);
		 
		 FXDLogVariable(self.mainDocument.documentState);
		 FXDLogBOOL([self.mainDocument hasUnsavedChanges]);
		 
		 if (finishCallback) {
			 finishCallback(_cmd, success, nil);
		 }
	 }];
}


#pragma mark - Observer
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_DEFAULT
	FXDLog_REMAINING;

	UIApplication *application = [UIApplication sharedApplication];

	__weak FXDmoduleCoredata *weakSelf = self;

	weakSelf.dataSavingTask =
	[application
	 beginBackgroundTaskWithExpirationHandler:^{
		 __strong FXDmoduleCoredata *strongSelf = weakSelf;

		 if (strongSelf) {
			 [application endBackgroundTask:strongSelf.dataSavingTask];
			 strongSelf.dataSavingTask = UIBackgroundTaskInvalid;
		 }
	 }];
	
	FXDLogVariable(weakSelf.dataSavingTask);


	[weakSelf
	 saveMainDocumentWithFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
		 FXDLog_BLOCK(weakSelf, caller);

		 FXDLog_REMAINING;

		 FXDLogVariable(weakSelf.dataSavingTask);

		 [application endBackgroundTask:weakSelf.dataSavingTask];
		 weakSelf.dataSavingTask = UIBackgroundTaskInvalid;
	 }];
}

#pragma mark -
- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLogVariable([(NSManagedObjectContext*)notification.object concurrencyType]);

	//MARK: Distinguish notification from main managedObjectContext and private managedObjectContext
	NSManagedObjectContext *notifyingContext = self.mainDocument.managedObjectContext.parentContext;
	FXDLogBOOL([notification.object isEqual:notifyingContext]);

	if ([notification.object isEqual:notifyingContext] == NO) {
		return;
	}


	NSPersistentStore *mainPersistentStore = (self.mainDocument.managedObjectContext).persistentStoreCoordinator.persistentStores.firstObject;
	NSPersistentStore *notifyingPersistentStore = ((NSManagedObjectContext*)notification.object).persistentStoreCoordinator.persistentStores.firstObject;

	NSString *mainStoreUUID = mainPersistentStore.metadata[@"NSStoreUUID"];
	NSString *notifyingStoreUUID = notifyingPersistentStore.metadata[@"NSStoreUUID"];


	//MARK: Merge only if persistentStore is same
	FXDLogObject(mainStoreUUID);
	FXDLogObject(notifyingStoreUUID);
	FXDLogBOOL([mainStoreUUID isEqualToString:notifyingStoreUUID]);

	if (mainStoreUUID.length == 0
		|| notifyingStoreUUID.length == 0
		|| [mainStoreUUID isEqualToString:notifyingStoreUUID] == NO) {
		return;
	}


	FXDLog(@"inserted: %lu", (unsigned long)[(NSArray*)(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %lu", (unsigned long)[(NSArray*)(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %lu", (unsigned long)[(NSArray*)(notification.userInfo)[@"updated"] count]);

	[self.mainDocument.managedObjectContext
	 performBlock:^{
		 FXDLog_BLOCK(self.mainDocument.managedObjectContext, @selector(performBlock:));

		 [self.mainDocument.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
		 FXDLog(@"DID MERGE: %@", _BOOL(self.mainDocument.managedObjectContext.hasChanges));
	 }];
}

#pragma mark - Delegate

@end
