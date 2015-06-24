#ifndef __IPHONE_9_0


@import AssetsLibrary;

@interface ALAsset (MultimediaFrameworks)
- (id)valueForKey:(NSString *)key;
@end


#import "FXDsuperModule.h"
@interface FXDmoduleAssets : FXDsuperModule

@property (strong, nonatomic) ALAssetsLibrary *mainAssetsLibrary;


- (void)groupsArrayWithTypes:(ALAssetsGroupType)types withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)assetsArrayFromGroup:(ALAssetsGroup*)group withFinishCallback:(FXDcallbackFinish)finishCallback;

@end


#endif