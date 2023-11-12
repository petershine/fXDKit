

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
- (BOOL)doesStoredSqliteExist {	FXDLog_DEFAULT
	NSString *storedPath = [appSearchPath_Document stringByAppendingPathComponent:self.sqlitePathComponent];
	FXDLogObject(storedPath);

	BOOL storedSqliteExists = [[NSFileManager defaultManager] fileExistsAtPath:storedPath];
	FXDLogBOOL(storedSqliteExists);

	return storedSqliteExists;
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

@end
