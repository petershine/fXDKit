

#import "FXDmoduleGPU.h"

#import "FXDmoduleCapture.h"


@implementation FXDcameraGPU
@end

@implementation FXDfilterGPU
@end

@implementation FXDimageviewGPU
+ (instancetype)imageviewForBounds:(CGRect)bounds withGPUImageOutput:(GPUImageOutput*)gpuimageOutput {	FXDLog_DEFAULT;
	FXDLogRect(bounds);

	FXDimageviewGPU *gpuviewCaptured = [[[self class] alloc] initWithFrame:bounds];
	gpuviewCaptured.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	gpuviewCaptured.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

	[gpuimageOutput addTarget:gpuviewCaptured];
	FXDLogObject([gpuimageOutput targets]);

	return gpuviewCaptured;
}
@end

@implementation FXDwriterGPU
- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_uniqueKey);
}

+ (instancetype)movieWriterWithVideoSize:(CGSize)videoSize withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput {	FXDLog_DEFAULT;

	FXDLog(@"%@ %f", _Size(videoSize), (MAX(videoSize.width, videoSize.height)/MIN(videoSize.width, videoSize.height)));
	FXDLogObject(fileURL);
	FXDLogObject(gpuimageOutput);

	FXDwriterGPU *gpumovieWriter = [[FXDwriterGPU alloc]
									initWithMovieURL:fileURL
									size:videoSize
									fileType:AVFileTypeQuickTimeMovie
									outputSettings:nil];

	gpumovieWriter.uniqueKey = [NSString uniqueKeyFrom:[[NSDate date] timeIntervalSince1970]];

	gpumovieWriter.encodingLiveVideo = YES;
	[gpumovieWriter setHasAudioTrack:YES audioSettings:nil];

	[gpuimageOutput addTarget:gpumovieWriter];
	FXDLogObject([gpuimageOutput targets]);

	return gpumovieWriter;
}

@end


@implementation FXDmoduleGPU

#pragma mark - Memory management
- (void)dealloc {
	[self resetGPUManager];
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSMutableArray*)filterNameArray {
	if (_filterNameArray) {
		return _filterNameArray;
	}

	FXDLog_DEFAULT;

	_filterNameArray =
	[@[NSStringFromClass([GPUImageRGBFilter class]),

	   NSStringFromClass([GPUImageAmatorkaFilter class]),

	   NSStringFromClass([GPUImageGrayscaleFilter class]),
	   NSStringFromClass([GPUImageHazeFilter class]),

	   NSStringFromClass([GPUImageMissEtikateFilter class]),

	   NSStringFromClass([GPUImagePixellateFilter class]),
	   NSStringFromClass([GPUImagePosterizeFilter class]),

	   NSStringFromClass([GPUImageSepiaFilter class]),
	   NSStringFromClass([GPUImageSketchFilter class]),
	   NSStringFromClass([GPUImageSoftEleganceFilter class]),

	   NSStringFromClass([GPUImageXYDerivativeFilter class]),

	   ] mutableCopy];

	FXDLogVariable(_filterNameArray.count);

	return _filterNameArray;
}

#pragma mark -
- (FXDcameraGPU*)videoCamera {
	if (_videoCamera) {
		return _videoCamera;
	}


	FXDLog_DEFAULT;

	_videoCamera = [[FXDcameraGPU alloc] initWithSessionPreset:AVCaptureSessionPresetHigh
												cameraPosition:AVCaptureDevicePositionBack];
	[_videoCamera setOutputImageOrientation:(UIInterfaceOrientation)AVCaptureVideoOrientationPortrait];

	[_videoCamera.inputCamera applyDefaultConfigurationWithFlashMode:AVCaptureFlashModeAuto];

	[_videoCamera addAudioInputsAndOutputs];

	return _videoCamera;
}

- (FXDfilterGPU*)cameraFilter {
	if (_cameraFilter) {
		return _cameraFilter;
	}


	FXDLog_DEFAULT;

	[self applyGPUfilterAtFilterIndex:self.lastFilterIndex];

	return _cameraFilter;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareGPUManager {	FXDLog_DEFAULT;
	//MARK: Make sure camera and filter are initialized here
	[self.videoCamera addTarget:self.cameraFilter];
}

- (void)resetGPUManager {	FXDLog_DEFAULT;
	[_videoCamera removeAllTargets];
	_videoCamera = nil;

	[_cameraFilter removeAllTargets];
	_cameraFilter = nil;
}

#pragma mark -
- (void)cycleGPUfiltersForward:(BOOL)isForward withCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

	NSInteger filterIndex = self.lastFilterIndex +(isForward ? 1:(-1));

	if (filterIndex < 0) {
		filterIndex = self.filterNameArray.count-1;
	}
	else if (filterIndex == self.filterNameArray.count) {
		filterIndex = 0;
	}


	[self applyGPUfilterAtFilterIndex:filterIndex];


	if (callback) {
		callback(_cmd, YES, @(filterIndex));
	}
}

- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex {	FXDLog_DEFAULT;
	FXDLogVariable(filterIndex);
	self.lastFilterIndex = filterIndex;
	
	NSString *filterName = self.filterNameArray[filterIndex];
	FXDLogObject(filterName);


	[_videoCamera removeTarget:_cameraFilter];

	[_cameraFilter removeAllTargets];
	_cameraFilter = nil;


	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	_cameraFilter = [[NSClassFromString(filterName) alloc] init];
	[_cameraFilter forceProcessingAtSizeRespectingAspectRatio:screenBounds.size];

	[_videoCamera addTarget:_cameraFilter];
}

@end
