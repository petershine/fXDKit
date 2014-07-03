
#import "FXDKit.h"


@import AssetsLibrary;


@interface FXDmoduleAssets : FXDsuperModule
@property (strong, nonatomic) ALAssetsLibrary *mainAssetsLibrary;


- (void)startObservingAssetsLibraryNotifications;

- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withFinishCallback:(FXDcallbackFinish)finishCallback;


#pragma mark - Observer
- (void)observedALAssetsLibraryChanged:(NSNotification*)notification;

#pragma mark - Delegate

@end
