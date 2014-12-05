
@import AVFoundation;

#import <GPUImage.h>

#import "FXDKit.h"


#ifndef sessionPresetOptimalCapture
	#define sessionPresetOptimalCapture	AVCaptureSessionPreset1280x720
#endif


@class FXDmoduleCapture;


@interface FXDfilterGPU : GPUImageFilter
@end

@interface FXDgroupfilterGPU : GPUImageFilterGroup
@end


@interface FXDcameraGPU : GPUImageVideoCamera
- (void)rotateCameraWithOptimalPreset:(NSString*)optimalCaptureSessionPreset;
@end

@interface FXDimageviewGPU : GPUImageView
+ (instancetype)imageviewForBounds:(CGRect)bounds withImageFilter:(GPUImageFilter*)gpuimageFilter;
@end

@interface FXDwriterGPU : GPUImageMovieWriter
+ (instancetype)movieWriterWithVideoSize:(CGSize)videoSize withFileURL:(NSURL*)fileURL withImageFilter:(GPUImageFilter*)gpuimageFilter;
@end


@interface FXDmoduleGPU : FXDsuperModule {
	NSInteger _lastFilterIndex;

	NSArray *_filterNameArray;

	NSString *_optimalCaptureSessionPreset;

	FXDcameraGPU *_videoCamera;
	FXDfilterGPU *_cameraFilter;

	GPUImageCropFilter *_cropFilter;
}

@property (nonatomic) NSInteger lastFilterIndex;

@property (strong, nonatomic) NSArray *filterNameArray;

@property (strong, nonatomic) NSString *originalAudioSesssionCategory;
@property (strong, nonatomic) NSString *optimalCaptureSessionPreset;

@property (strong, nonatomic) FXDcameraGPU *videoCamera;
@property (strong, nonatomic) FXDfilterGPU *cameraFilter;

@property (strong, nonatomic) GPUImageCropFilter *cropFilter;


- (void)prepareGPUmodule;
- (void)resetGPUmodule;

- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex shouldShowLabel:(BOOL)shouldShowLabel;

@end
