

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
		 [self performSelector:@selector(startObservingCoreDataNotifications)];
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

@end
