//
//  FXDsuperAssetsManager.h
//
//
//  Created by petershine on 5/2/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

@import AssetsLibrary;


#import "FXDsuperModule.h"
@interface FXDsuperAssetsManager : FXDsuperModule
@property (strong, nonatomic) ALAssetsLibrary *mainAssetsLibrary;


#pragma mark - Initialization

#pragma mark - Public
- (void)startObservingAssetsLibraryNotifications;

- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withFinishCallback:(FXDcallbackFinish)finishCallback;


//MARK: - Observer implementation
- (void)observedALAssetsLibraryChanged:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
