//
//  FXDsuperAssetsManager.m
//
//
//  Created by petershine on 5/2/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperAssetsManager.h"

#pragma mark - ALAsset Category
@implementation ALAsset (Added)
- (id)valueForKey:(NSString *)key {
	return [self valueForProperty:key];
}

@end


#pragma mark - Public implementation
@implementation FXDsuperAssetsManager


#pragma mark - Memory management
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	// Instance variables
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}

#pragma mark -
+ (FXDsuperAssetsManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (ALAssetsLibrary*)mainAssetsLibrary {
	if (_mainAssetsLibrary) {
		return _mainAssetsLibrary;
	}
	
	
	FXDLog_DEFAULT;
	ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
	FXDLog(@"authorizationStatus: %d", authorizationStatus);
	
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
- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withDidFinishBlock:(void(^)(NSMutableArray* groupsArray))didFinishBlock {	FXDLog_DEFAULT;
	
	if (self.mainAssetsLibrary == nil) {
		if (didFinishBlock) {
			didFinishBlock(nil);
		}
		
		return;
	}
	
	
	__block NSMutableArray *collectedGroupsArray = nil;
	
	[self.mainAssetsLibrary
	 enumerateGroupsWithTypes:types
	 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
		 FXDLog(@"*stop: %d group: %@", *stop, group);
		 
		 if (group) {
			 if (collectedGroupsArray == nil) {
				 collectedGroupsArray = [[NSMutableArray alloc] initWithCapacity:0];
			 }
			 
			 [collectedGroupsArray addObject:group];
		 }
		 else {
			 if (didFinishBlock) {
				 didFinishBlock(collectedGroupsArray);
			 }
		 }
	 }
	 failureBlock:^(NSError *error) {
		 FXDLog_ERROR;
		 
		 /*
		  ALBmanagerAssets__73-[FXDsuperAssetsManager prepareSavedPhotosAssetsGroupWithDidFinishBlock:]_block_invoke41
		  file: /Users/thckbrws/Desktop/_WORK_Provus/_PROJECT/PhotoAlbum/_Submodules/FXDKit_PhotoAlbum/z_superManager/FXDsuperAssetsManager.m
		  line: 105
		  
		  localizedDescription: User denied access
		  domain: ALAssetsLibraryErrorDomain
		  code: -3311
		  userInfo:
		  {
		  NSLocalizedDescription = "User denied access";
		  NSLocalizedFailureReason = "The user has denied the application access to their media.";
		  NSUnderlyingError = "Error Domain=ALAssetsLibraryErrorDomain Code=-3311 \"The operation couldn\U2019t be completed. (ALAssetsLibraryErrorDomain error -3311.)\"";
		  }
		  */
		 
		 if (didFinishBlock) {
			 didFinishBlock(collectedGroupsArray);
		 }
	 }];
}

- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withDidFinishBlock:(void(^)(NSMutableArray *assetsArray))didFinishBlock {	FXDLog_DEFAULT;
	
	__block NSMutableArray *collectedAssetsArray = nil;
	
	[group
	 enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
		 //FXDLog(@"*stop: %d index: %d group: %@", *stop, index, asset);
		 
		 if (asset) {
			 if (collectedAssetsArray == nil) {
				 collectedAssetsArray = [[NSMutableArray alloc] initWithCapacity:0];
			 }
			 
			 [collectedAssetsArray addObject:asset];
		 }
		 else {
			 if (didFinishBlock) {
				 didFinishBlock(collectedAssetsArray);
			 }
		 }
	 }];
}


//MARK: - Observer implementation
- (void)observedALAssetsLibraryChanged:(NSNotification *)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
	
	/*
	extern NSString *const ALAssetLibraryUpdatedAssetsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	extern NSString *const ALAssetLibraryInsertedAssetGroupsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	extern NSString *const ALAssetLibraryUpdatedAssetGroupsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	extern NSString *const ALAssetLibraryDeletedAssetGroupsKey __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
	 */
}

//MARK: - Delegate implementation

@end