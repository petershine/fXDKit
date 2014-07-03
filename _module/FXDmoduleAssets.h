
#import "FXDKit.h"


@import AssetsLibrary;


@interface FXDmoduleAssets : FXDsuperModule

@property (strong, nonatomic) ALAssetsLibrary *mainAssetsLibrary;


- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withFinishCallback:(FXDcallbackFinish)finishCallback;

@end
