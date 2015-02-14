
#import "FXDimportCore.h"

@import AssetsLibrary;


@interface ALAsset (MultimediaFrameworks)
- (id)valueForKey:(NSString *)key;
@end


@interface FXDmoduleAssets : FXDsuperModule

@property (strong, nonatomic) ALAssetsLibrary *mainAssetsLibrary;


- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withFinishCallback:(FXDcallbackFinish)finishCallback;

@end
