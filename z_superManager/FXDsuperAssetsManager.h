//
//  FXDsuperAssetsManager.h
//
//
//  Created by petershine on 5/2/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - ALAsset Category
@interface ALAsset (Added)
- (id)valueForKey:(NSString *)key;
@end


@interface FXDsuperAssetsManager : FXDObject

// Properties
@property (strong, nonatomic) ALAssetsLibrary *mainAssetsLibrary;
@property (strong, nonatomic) ALAssetsGroup *assetsgroupSavedPhotos;


#pragma mark - Initialization
+ (FXDsuperAssetsManager*)sharedInstance;


#pragma mark - Public
- (void)startObservingAssetsLibraryNotifications;

- (void)prepareSavedPhotosAssetsGroupWithDidFinishBlock:(void(^)(BOOL finished))didFinishBlock;
- (void)assetsArrayForSavedPhotosWithDidFinishBlock:(void(^)(NSMutableArray *assetsArray))didFinishBlock;


//MARK: - Observer implementation
- (void)observedALAssetsLibraryChanged:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
