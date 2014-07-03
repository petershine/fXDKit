

#import "FXDmoduleAssets.h"


@implementation FXDmoduleAssets

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (ALAssetsLibrary*)mainAssetsLibrary {
	if (_mainAssetsLibrary) {
		return _mainAssetsLibrary;
	}
	
	
	FXDLog_DEFAULT;
	ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
	FXDLogBOOL(authorizationStatus);
	
	if (authorizationStatus != ALAuthorizationStatusRestricted
		&& authorizationStatus != ALAuthorizationStatusDenied) {
		
		_mainAssetsLibrary = [[ALAssetsLibrary alloc] init];
	}
	
	return _mainAssetsLibrary;
}

#pragma mark - Method overriding

#pragma mark - Public
- (void)startObservingAssetsLibraryNotifications {	FXDLog_DEFAULT;
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedALAssetsLibraryChanged:)
	 name:ALAssetsLibraryChangedNotification
	 object:nil];
}

#pragma mark -
- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	
	if (self.mainAssetsLibrary == nil) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		
		return;
	}
	
	
	__block NSMutableArray *collectedGroupsArray = nil;
	
	[self.mainAssetsLibrary
	 enumerateGroupsWithTypes:types
	 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
		 FXDLog(@"%@ %@", _BOOL(*stop), _Object(group));
		 
		 if (group) {
			 if (collectedGroupsArray == nil) {
				 collectedGroupsArray = [[NSMutableArray alloc] initWithCapacity:0];
			 }
			 
			 [collectedGroupsArray addObject:group];
		 }
		 else {
			 if (finishCallback) {
				 finishCallback(_cmd, YES, collectedGroupsArray);
			 }
		 }
	 }
	 failureBlock:^(NSError *error) {
		 FXDLog_ERROR;
		 
		 if (finishCallback) {
			 finishCallback(_cmd, NO, collectedGroupsArray);
		 }
	 }];
}

- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	
	__block NSMutableArray *collectedAssetsArray = nil;
	
	[group
	 enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
		 
		 if (asset) {
			 if (collectedAssetsArray == nil) {
				 collectedAssetsArray = [[NSMutableArray alloc] initWithCapacity:0];
			 }
			 
			 [collectedAssetsArray addObject:asset];
		 }
		 else {
			 if (finishCallback) {
				 finishCallback(_cmd, YES, collectedAssetsArray);
			 }
		 }
	 }];
}


#pragma mark - Observer
- (void)observedALAssetsLibraryChanged:(NSNotification *)notification {	FXDLog_DEFAULT;
	FXDLogObject(notification);
	
	/*
	extern NSString *const ALAssetLibraryUpdatedAssetsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	extern NSString *const ALAssetLibraryInsertedAssetGroupsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	extern NSString *const ALAssetLibraryUpdatedAssetGroupsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	extern NSString *const ALAssetLibraryDeletedAssetGroupsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	 */
}

#pragma mark - Delegate

@end
