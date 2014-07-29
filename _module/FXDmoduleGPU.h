
@import AVFoundation;
#import <GPUImage.h>

#import "FXDKit.h"


@class FXDmoduleCapture;


@interface FXDcameraGPU : GPUImageVideoCamera
@end

@interface FXDfilterGPU : GPUImageFilter
@end

@interface FXDimageviewGPU : GPUImageView
+ (instancetype)imageviewForBounds:(CGRect)bounds withImageFilter:(GPUImageFilter*)gpuimageFilter;
@end

@interface FXDwriterGPU : GPUImageMovieWriter
@property (nonatomic) CMTime startTime;
@property (strong, nonatomic) NSString *uniqueKey;

+ (instancetype)movieWriterWithVideoSize:(CGSize)videoSize withFileURL:(NSURL*)fileURL withImageFilter:(GPUImageFilter*)gpuimageFilter;
@end


@interface FXDmoduleGPU : FXDsuperModule {
	NSInteger _lastFilterIndex;

	NSMutableArray *_filterNameArray;

	FXDcameraGPU *_videoCamera;
	FXDfilterGPU *_cameraFilter;
}

@property (nonatomic) NSInteger lastFilterIndex;

@property (strong, nonatomic) NSMutableArray *filterNameArray;

@property (strong, nonatomic) FXDcameraGPU *videoCamera;
@property (strong, nonatomic) FXDfilterGPU *cameraFilter;


- (void)prepareGPUmodule;
- (void)resetGPUmodule;

- (void)cycleGPUfiltersForward:(BOOL)isForward withCallback:(FXDcallbackFinish)finishCallback;
- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex;

@end
