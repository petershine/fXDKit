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
- (instancetype)init {
	self = [super init];

	if (self) {
		FXDLog_SEPARATE;
	}

	return self;
}

+ (FXDsuperMainCoredata*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
//MARK: Override if using extra data model
- (NSString*)mainModelName {
	
	if (_mainModelName == nil) {	FXDLog_OVERRIDE;
		_mainModelName = application_BundleIdentifier;
		FXDLog(@"_mainModelName: %@", _mainModelName);
	}

	return _mainModelName;
}

- (FXDManagedDocument*)mainDocument {
	
	if (_mainDocument == nil) {	FXDLog_DEFAULT;
		NSURL *documentURL = [appDirectory_Document URLByAppendingPathComponent:[NSString stringWithFormat:@"managedDocument.%@", self.mainModelName]];

		_mainDocument = [[FXDManagedDocument alloc] initWithFileURL:documentURL];
		FXDLog(@"_mainDocument: %@", _mainDocument);
	}
	
	return _mainDocument;
}

#pragma mark -
- (NSString*)mainSqlitePathComponent {

	if (_mainSqlitePathComponent == nil) {	FXDLog_DEFAULT;
		_mainSqlitePathComponent = [NSString stringWithFormat:@"%@.sqlite", self.mainModelName];

		//MARK: Use different name for better controlling between developer build and release build
	#if ForDEVELOPER
	#else
		_mainSqlitePathComponent = [NSString stringWithFormat:@".%@", _mainSqlitePathComponent];
	#endif

		FXDLog(@"_mainSqlitePathComponent: %@", _mainSqlitePathComponent);

		LOGEVENT_FULL(@"_mainSqlitePathComponent", @{@"_mainSqlitePathComponent": _mainSqlitePathComponent}, NO);
	}
	
	return _mainSqlitePathComponent;
}

- (NSString*)mainUbiquitousContentName {
	if (_mainUbiquitousContentName == nil) {	FXDLog_DEFAULT;
		_mainUbiquitousContentName = [NSString stringWithFormat:@"ubiquitousContent.%@", self.mainModelName];
		FXDLog(@"_mainUbiquitousContentName: %@", _mainUbiquitousContentName);

		LOGEVENT_FULL(@"_mainUbiquitousContentName", @{@"_mainUbiquitousContentName": _mainUbiquitousContentName}, NO);
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

	if ([self isSqliteAlreadyStored]) {
		return;
	}


	NSString *bundledSqlitePath = [[NSBundle mainBundle] pathForResource:sqliteFile ofType:@"sqlite"];
	FXDLog(@"bundledSqlitePath: %@", bundledSqlitePath);

	[self storeCopiedItemFromSqlitePath:bundledSqlitePath toStoredPath:nil];
}

- (void)tranferFromOldSqliteFile:(NSString*)sqliteFile {	FXDLog_DEFAULT;

	if ([self isSqliteAlreadyStored]) {
		return;
	}


	NSString *pathComponent = [NSString stringWithFormat:@".%@.sqlite", sqliteFile];

#if ForDEVELOPER
	pathComponent = [NSString stringWithFormat:@"%@.sqlite", sqliteFile];
#endif

	NSString *oldSqlitePath = [appSearhPath_Document stringByAppendingPathComponent:pathComponent];
	FXDLog(@"oldSqlitePath: %@", oldSqlitePath);

	[self storeCopiedItemFromSqlitePath:oldSqlitePath toStoredPath:nil];
}

- (BOOL)isSqliteAlreadyStored {
	NSString *storedSqlitePath = [appSearhPath_Document stringByAppendingPathComponent:self.mainSqlitePathComponent];
	FXDLog(@"storedSqlitePath: %@", storedSqlitePath);

	BOOL isAlreadyStored = [[NSFileManager defaultManager] fileExistsAtPath:storedSqlitePath];
	FXDLog(@"isAlreadyStored: %d", isAlreadyStored);

	return isAlreadyStored;
}

- (BOOL)storeCopiedItemFromSqlitePath:(NSString*)sqlitePath toStoredPath:(NSString*)storedPath {
	NSFileManager *fileManager = [NSFileManager defaultManager];

	BOOL sqliteFileExists = [fileManager fileExistsAtPath:sqlitePath];
	FXDLog(@"sqliteFileExists: %d", sqliteFileExists);

	if (sqliteFileExists == NO) {
		return NO;
	}


	if (storedPath == nil) {
		storedPath = [appSearhPath_Document stringByAppendingPathComponent:self.mainSqlitePathComponent];
	}

	NSError *error = nil;

	BOOL didCopy = [fileManager copyItemAtPath:sqlitePath toPath:storedPath error:&error];
	FXDLog(@"didCopy: %d", didCopy);

	FXDLog_ERROR_ALERT;

	return didCopy;
}

#pragma mark -
- (void)prepareWithUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection didFinishBlock:(FXDblockDidFinish)didFinishBlock {	//FXDLog_DEFAULT;
	
	[[NSOperationQueue new]
	 addOperationWithBlock:^{	FXDLog_DEFAULT;
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
			 FXDLog(@"ubiquitousContentURL: %@", ubiquitousContentURL);
			 
			 options[NSPersistentStoreUbiquitousContentNameKey] = self.mainUbiquitousContentName;
			 options[NSPersistentStoreUbiquitousContentURLKey] = ubiquitousContentURL;
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
		 
		 FXDLog_ERROR;
		 
		 FXDLog(@"1.didConfigure: %d", didConfigure);
		 
#if ForDEVELOPER
		 NSPersistentStoreCoordinator *storeCoordinator = self.mainDocument.managedObjectContext.persistentStoreCoordinator;
		 
		 for (NSPersistentStore *persistentStore in storeCoordinator.persistentStores) {
			 FXDLog(@"persistentStore: %@", persistentStore.URL);
			 FXDLog(@"metadataForPersistentStore:\n%@", [storeCoordinator metadataForPersistentStore:persistentStore]);
		 }
#endif
		 
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  FXDLog(@"2.didConfigure: %d", didConfigure);
			  
#warning "//MARK: If iCloud connection is not working, CHECK if cellular transferring is enabled on device"
			  FXDLog_ERROR_ALERT;

			  //TODO: learn how to handle ubiquitousToken change, and migrate to new persistentStore
			  //TODO: prepare what to do when Core Data is not setup

			  [self
			   upgradeAllAttributesForNewDataModelWithDidFinishBlock:^(BOOL finished) {
				   FXDLog(@"finished: %d", finished);

				   [self startObservingCoreDataNotifications];

				   if (didFinishBlock) {
					   didFinishBlock(didConfigure);
				   }
			   }];
		  }];
	 }];
}

#pragma mark -
- (void)upgradeAllAttributesForNewDataModelWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;
#warning "//TODO: Learn about NSMigrationPolicy implementation

	if (didFinishBlock) {
		didFinishBlock(YES);
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
	FXDLog(@"notifyingContext: %@", notifyingContext);
	
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
- (id)initializedMainEntityObj {
	if (self.mainEntityName == nil) {	FXDLog_OVERRIDE;
		return nil;
	}
	
	
	if ([NSThread isMainThread] == NO) {	FXDLog_OVERRIDE;
		//MARK: Default is to skip
		FXDLog(@"NSThread isMainThread: %d", [NSThread isMainThread]);
		return nil;
	}
	
	
	NSEntityDescription *mainEntity = [NSEntityDescription entityForName:self.mainEntityName inManagedObjectContext:self.mainDocument.managedObjectContext];

	if (mainEntity == nil) {
		return nil;
	}

	
	id mainEntityObj = [(FXDManagedObject*)[[NSClassFromString(self.mainEntityName) class] alloc] initWithEntity:mainEntity insertIntoManagedObjectContext:self.mainDocument.managedObjectContext];
	
	return mainEntityObj;
}

#pragma mark -
- (void)deleteAllDataWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock {
	
	FXDWindow *applicationWindow = [FXDWindow applicationWindow];
	
	[applicationWindow
	 showMessageViewWithNibName:nil
	 withTitle:NSLocalizedString(@"Do want to delete ALL?", nil)
	 message:NSLocalizedString(@"Please be warned. Deleted data CAN NEVER BE RESTORED!", nil)
	 cancelButtonTitle:NSLocalizedString(text_Cancel, nil)
	 acceptButtonTitle:NSLocalizedString(text_DeleteAll, nil)
	 clickedButtonAtIndexBlock:^(id alertObj, NSInteger buttonIndex) {
		 FXDLog(@"alertObj: %@, buttonIndex: %ld", alertObj, (long)buttonIndex);
		 
		 if (buttonIndex == buttonIndexAccept) {
			 [self
			  enumerateAllMainEntityObjWithDefaultProgressView:YES
			  withEnumerationBlock:^(NSManagedObjectContext *managedContext,
									 NSManagedObject *mainEntityObj,
									 BOOL *shouldBreak) {
				  
				  //TODO: Implement shouldBreak different, making this block to return boolean
				  if (*shouldBreak) {
					  FXDLog(@"enumerateAllMainEntityObjWithDefaultProgressView shouldBreak: %d", *shouldBreak);
				  }
				  
				  [managedContext deleteObject:mainEntityObj];
				  
			  } withDidFinishBlock:didFinishBlock];
		 }
	 }];
}

#pragma mark -
- (void)enumerateAllMainEntityObjWithDefaultProgressView:(BOOL)withDefaultProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {
	
	[self
	 enumerateAllMainEntityObjShouldUsePrivateContext:NO
	 shouldSaveAtTheEnd:YES
	 withDefaultProgressView:withDefaultProgressView
	 withEnumerationBlock:enumerationBlock
	 withDidFinishBlock:didFinishBlock];
}

- (void)enumerateAllMainEntityObjShouldUsePrivateContext:(BOOL)shouldUsePrivateContext shouldSaveAtTheEnd:(BOOL)shouldSaveAtTheEnd withDefaultProgressView:(BOOL)withDefaultProgressView withEnumerationBlock:(void(^)(NSManagedObjectContext *managedContext, NSManagedObject *mainEntityObj, BOOL *shouldBreak))enumerationBlock withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;
	
	FXDLog(@"shouldUsePrivateContext: %d", shouldUsePrivateContext);
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
	FXDLog(@"1.enumeratingTaskIdentifier: %lu", (unsigned long)self.enumeratingTaskIdentifier);
	
	
	FXDWindow *applicationWindow = nil;
	
	if (withDefaultProgressView) {
		applicationWindow = [FXDWindow applicationWindow];
		[applicationWindow showDefaultProgressView];
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
			  FXDLog(@"1.self.didStartEnumerating: %d", self.didStartEnumerating);
			  self.didStartEnumerating = NO;
			  FXDLog(@"2.self.didStartEnumerating: %d", self.didStartEnumerating);
			  
			  
			  FXDblockDidFinish DidEnumerateBlock = ^(BOOL finished) {
				  FXDLog(@"finished: %d shouldBreak: %d", finished, shouldBreak);
				  
				  if (withDefaultProgressView) {
					  [applicationWindow hideProgressView];
				  }
				  
				  if (shouldBreak) {
					  finished = NO;
				  }
				  
				  FXDLog(@"finished: %d, shouldBreak: %d", finished, shouldBreak);
				  
				  
				  FXDLog_REMAINING;
				  
				  FXDLog(@"2.enumeratingTaskIdentifier: %lu", (unsigned long)self.enumeratingTaskIdentifier);
				  
				  [[UIApplication sharedApplication] endBackgroundTask:self.enumeratingTaskIdentifier];
				  self.enumeratingTaskIdentifier = UIBackgroundTaskInvalid;
				  
				  if (didFinishBlock) {
					  didFinishBlock(finished);
				  }
			  };
			  
			  
			  if (shouldSaveAtTheEnd == NO) {
				  DidEnumerateBlock(YES);
				  
				  return;
			  }
			  
			  
			  [self
			   saveMainDocumentShouldSkipMerge:NO
			   withDidFinishBlock:DidEnumerateBlock];
		  }];
	 }];
}

#pragma mark -
- (void)saveManagedContext:(NSManagedObjectContext*)managedContext withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_SEPARATE;
	
	FXDLog(@"1.hasChanges: %d concurrencyType: %lu", managedContext.hasChanges, (unsigned long)managedContext.concurrencyType);

	if (managedContext == nil) {
		managedContext = self.mainDocument.managedObjectContext;

		FXDLog(@"2.hasChanges: %d concurrencyType: %lu", managedContext.hasChanges, (unsigned long)managedContext.concurrencyType);

		if (managedContext.hasChanges == NO
			&& managedContext.concurrencyType != self.mainDocument.managedObjectContext.parentContext.concurrencyType) {
			
			managedContext = self.mainDocument.managedObjectContext.parentContext;

			FXDLog(@"3.hasChanges: %d concurrencyType: %lu", managedContext.hasChanges, (unsigned long)managedContext.concurrencyType);
		}
	}
	
	FXDLog(@"managedContext: %@ hasChanges: %d concurrencyType: %lu", managedContext, managedContext.hasChanges, (unsigned long)managedContext.concurrencyType);

	if (managedContext == nil || managedContext.hasChanges == NO) {

		if (didFinishBlock) {
			didFinishBlock(NO);
		}

		return;
	}

	
	void (^ManagedContextSavingBlock)(void) = ^{
		NSError *error = nil;
		BOOL didSave = [managedContext save:&error];FXDLog_ERROR;
		
		FXDLog_DEFAULT;
		FXDLog(@"didSave: %d concurrencyType: %lu", didSave, (unsigned long)managedContext.concurrencyType);
		FXDLog(@"4.hasChanges: %d concurrencyType: %lu", managedContext.hasChanges, (unsigned long)managedContext.concurrencyType);
		
		if (didFinishBlock) {
			didFinishBlock(didSave);
		}
	};

	
	FXDLog(@"[NSThread isMainThread]: %d", [NSThread isMainThread]);
	
	if ([NSThread isMainThread]) {
		[managedContext performBlockAndWait:ManagedContextSavingBlock];
	}
	else {
		ManagedContextSavingBlock();
	}
}

- (void)saveMainDocumentShouldSkipMerge:(BOOL)shouldSkipMerge withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_SEPARATE;
	
	FXDLog(@"shouldSkipMerge: %d", shouldSkipMerge);
	FXDLog(@"1.self.mainDocument.documentState: %lu", (unsigned long)self.mainDocument.documentState);
	FXDLog(@"1.self.mainDocument hasUnsavedChanges: %d", [self.mainDocument hasUnsavedChanges]);
	
	if (shouldSkipMerge) {
		self.shouldMergeForManagedContext = NO;
	}
	else {
		self.shouldMergeForManagedContext = YES;
	}
	
	FXDLog(@"self.shouldMergeForManagedContext: %d", self.shouldMergeForManagedContext);
	
	
	[self.mainDocument
	 saveToURL:self.mainDocument.fileURL
	 forSaveOperation:UIDocumentSaveForOverwriting
	 completionHandler:^(BOOL success) {
		 FXDLog(@"saveToURL:forSaveOperation: success: %d", success);
		 
		 FXDLog(@"2.self.mainDocument.documentState: %lu", (unsigned long)self.mainDocument.documentState);
		 FXDLog(@"2.self.mainDocument hasUnsavedChanges: %d", [self.mainDocument hasUnsavedChanges]);
		 
		 if (didFinishBlock) {
			 didFinishBlock(success);
		 }
	 }];
}


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification {FXDLog_DEFAULT;
	//MARK: Re-consider about saving context here
}

- (void)observedUIApplicationWillTerminate:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog_REMAINING;

	self.savingTaskIdentifier
	= [[UIApplication sharedApplication]
	   beginBackgroundTaskWithExpirationHandler:^{
		   [[UIApplication sharedApplication] endBackgroundTask:self.savingTaskIdentifier];
		   self.savingTaskIdentifier = UIBackgroundTaskInvalid;
	   }];
	FXDLog(@"1.savingTaskIdentifier: %lu", (unsigned long)self.savingTaskIdentifier);
	
	[self
	 saveMainDocumentShouldSkipMerge:NO
	 withDidFinishBlock:^(BOOL finished) {
		FXDLog(@"saveMainDocumentShouldSkipMerge finished: %d", finished);
		
		FXDLog_REMAINING;
		
		FXDLog(@"2.savingTaskIdentifier: %lu", (unsigned long)self.savingTaskIdentifier);
		
		[[UIApplication sharedApplication] endBackgroundTask:self.savingTaskIdentifier];
		self.savingTaskIdentifier = UIBackgroundTaskInvalid;
	}];
}

#pragma mark -
- (void)observedUIDocumentStateChanged:(NSNotification*)notification {	FXDLog_DEFAULT;
	//notification: NSConcreteNotification 0x1a3746e0 {name = UIDocumentStateChangedNotification; object = <FXDManagedDocument: 0x16d94d10> fileURL: file:///var/mobile/Applications/A2651A45-6230-4225-A538-420889FD5693/Documents/managed.coredata.document documentState: [EditingDisabled | SavingError]}

	FXDLog(@"notification: %@", notification);
	FXDLog(@"self.mainDocument.fileModificationDate: %@", self.mainDocument.fileModificationDate);
	FXDLog(@"self.mainDocument.documentState: %lu", (unsigned long)self.mainDocument.documentState);
}

#pragma mark -
- (void)observedNSManagedObjectContextObjectsDidChange:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %lu", notification.object, (unsigned long)[(NSManagedObjectContext*)notification.object concurrencyType]);
}

- (void)observedNSManagedObjectContextWillSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %lu", notification.object, (unsigned long)[(NSManagedObjectContext*)notification.object concurrencyType]);
}

- (void)observedNSManagedObjectContextDidSave:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@ concurrencyType: %lu", notification.object, (unsigned long)[(NSManagedObjectContext*)notification.object concurrencyType]);
	FXDLog(@"isEqual:self.mainDocument.managedObjectContext: %@", [notification.object isEqual:self.mainDocument.managedObjectContext] ? @"YES":@"NO");

	// Distinguish notification from main managedObjectContext and private managedObjectContext
	if ([notification.object isEqual:self.mainDocument.managedObjectContext]) {
		return;
	}
	
	
	FXDLog(@"NSThread isMainThread: %d", [NSThread isMainThread]);
	FXDLog(@"NOTIFIED: mergeChangesFromContextDidSaveNotification:");
	FXDLog(@"inserted: %lu", (unsigned long)[(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %lu", (unsigned long)[(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %lu", (unsigned long)[(notification.userInfo)[@"updated"] count]);
	
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

		//MARK: Unless save is done for private context in background, you can skip merging"
		if (self.shouldMergeForManagedContext) {
			[self.mainDocument.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
			FXDLog(@"DID MERGE: self.mainDocument.managedObjectContext.hasChanges: %d", self.mainDocument.managedObjectContext.hasChanges);
		}
		
		self.shouldMergeForManagedContext = NO;
	}
	
	FXDLog(@"2.self.shouldMergeForManagedContext: %d", self.shouldMergeForManagedContext);
}

#pragma mark -
- (void)observedNSPersistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLog(@"notification.object: %@", notification.object);
	
	FXDLog(@"inserted: %lu", (unsigned long)[(notification.userInfo)[@"inserted"] count]);
	FXDLog(@"deleted: %lu", (unsigned long)[(notification.userInfo)[@"deleted"] count]);
	FXDLog(@"updated: %lu", (unsigned long)[(notification.userInfo)[@"updated"] count]);
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

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	
	__strong typeof(controller.additionalDelegate) _strongDelegate = controller.additionalDelegate;
	
	if (_strongDelegate == nil) {
		return;
	}
	
	
	[_strongDelegate controllerDidChangeContent:controller];
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

@end