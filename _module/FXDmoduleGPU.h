
#import "FXDKit.h"


@import AVFoundation;

#import <GPUImage.h>


@interface FXDcameraGPU : GPUImageVideoCamera
@end

@interface FXDfiltergroupGPU : GPUImageFilterGroup
@end

@interface FXDimageviewGPU : GPUImageView
+ (instancetype)imageviewWithGPUImageOutput:(GPUImageOutput*)gpuimageOutput;
@end

@interface FXDwriterGPU : GPUImageMovieWriter
@property (nonatomic) CMTime startTime;
@property (strong, nonatomic) NSString *uniqueKey;

+ (instancetype)movieWriterWithVideoSize:(CGSize)videoSize withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput;
@end


@interface FXDmoduleGPU : FXDsuperModule
@property (nonatomic) NSInteger lastFilterIndex;

@property (strong, nonatomic) NSMutableArray *cycledFilterNameArray;

@property (strong, nonatomic) FXDcameraGPU *gpuvideoCamera;
@property (strong, nonatomic) FXDfiltergroupGPU *gpufilterGroup;


- (void)prepareGPUManager;
- (void)resetGPUManager;

- (void)cycleGPUfiltersForward:(BOOL)isForward withCallback:(FXDcallbackFinish)finishCallback;
- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex;


#pragma mark - Observer
- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification;

#pragma mark - Delegate

@end
