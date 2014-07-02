//
//  FXDmoduleAssets.h
//
//
//  Created by petershine on 5/2/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

@import AssetsLibrary;


@interface FXDmoduleAssets : FXDsuperModule
@property (strong, nonatomic) ALAssetsLibrary *mainAssetsLibrary;


- (void)startObservingAssetsLibraryNotifications;

- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withFinishCallback:(FXDcallbackFinish)finishCallback;


//MARK: - Observer implementation
- (void)observedALAssetsLibraryChanged:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
