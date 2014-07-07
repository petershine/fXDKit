

#import "FXDmoduleGPU.h"

#import "FXDmoduleCapture.h"


@implementation FXDcameraGPU
- (void)dealloc {	FXDLog_DEFAULT;
}
@end

@implementation FXDfiltergroupGPU
- (void)dealloc {	FXDLog_DEFAULT;
}
@end

@implementation FXDimageviewGPU
- (void)dealloc {	FXDLog_DEFAULT;
}

+ (instancetype)imageviewForBounds:(CGRect)bounds withGPUImageOutput:(GPUImageOutput*)gpuimageOutput {	FXDLog_DEFAULT;
	FXDLogRect(bounds);

	FXDimageviewGPU *gpuviewCaptured = [[[self class] alloc] initWithFrame:bounds];
	gpuviewCaptured.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	gpuviewCaptured.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

	[gpuimageOutput addTarget:gpuviewCaptured];
	FXDLogObject(gpuimageOutput.targets);

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
	FXDLogObject(gpuimageOutput.targets);

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
- (NSMutableArray*)cycledFilterNameArray {
	if (_cycledFilterNameArray) {
		return _cycledFilterNameArray;
	}

	FXDLog_DEFAULT;

	_cycledFilterNameArray =
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

	FXDLogVariable(_cycledFilterNameArray.count);

	return _cycledFilterNameArray;
}

#pragma mark -
- (FXDcameraGPU*)gpuvideoCamera {
	if (_gpuvideoCamera) {
		return _gpuvideoCamera;
	}


	FXDLog_DEFAULT;

	_gpuvideoCamera = [[FXDcameraGPU alloc] initWithSessionPreset:AVCaptureSessionPresetHigh
												   cameraPosition:AVCaptureDevicePositionBack];
	[_gpuvideoCamera setOutputImageOrientation:(UIInterfaceOrientation)AVCaptureVideoOrientationPortrait];

	[_gpuvideoCamera.inputCamera applyDefaultConfigurationWithFlashMode:AVCaptureFlashModeAuto];

	[_gpuvideoCamera addAudioInputsAndOutputs];

	return _gpuvideoCamera;
}

- (FXDfiltergroupGPU*)gpufilterGroup {
	if (_gpufilterGroup) {
		return _gpufilterGroup;
	}


	FXDLog_DEFAULT;

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	GPUImageRGBFilter *normalFilter = [[GPUImageRGBFilter alloc] init];
	[normalFilter forceProcessingAtSizeRespectingAspectRatio:screenBounds.size];

	_gpufilterGroup = [[FXDfiltergroupGPU alloc] init];
	[_gpufilterGroup addFilter:normalFilter];

	_gpufilterGroup.initialFilters = @[normalFilter];
	_gpufilterGroup.terminalFilter = normalFilter;

	FXDLogObject(_gpufilterGroup);

	return _gpufilterGroup;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareGPUManager {	FXDLog_DEFAULT;
	[self.gpuvideoCamera addTarget:self.gpufilterGroup];

	[self applyGPUfilterAtFilterIndex:self.lastFilterIndex];

	FXDLogObject([self.gpuvideoCamera targets]);
	FXDLogObject([self.gpufilterGroup targets]);
	FXDLogObject([self.gpufilterGroup.terminalFilter targets]);
}

- (void)resetGPUManager {	FXDLog_DEFAULT;
	[_gpuvideoCamera removeAllTargets];
	_gpuvideoCamera = nil;

	[_gpufilterGroup removeAllTargets];
	_gpufilterGroup = nil;
}

#pragma mark -
- (void)cycleGPUfiltersForward:(BOOL)isForward withCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT;

	NSInteger filterIndex = self.lastFilterIndex +(isForward ? 1:(-1));

	if (filterIndex < 0) {
		filterIndex = self.cycledFilterNameArray.count-1;
	}
	else if (filterIndex == self.cycledFilterNameArray.count) {
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
	
	NSString *filterName = self.cycledFilterNameArray[filterIndex];
	FXDLogObject(filterName);

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	GPUImageFilter *nextFilter = [[NSClassFromString(filterName) alloc] init];
	[nextFilter forceProcessingAtSizeRespectingAspectRatio:screenBounds.size];

	self.gpufilterGroup.initialFilters = @[nextFilter];
	self.gpufilterGroup.terminalFilter = nextFilter;
}

@end
