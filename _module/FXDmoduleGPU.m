

#import "FXDmoduleGPU.h"

#import "FXDmoduleCapture.h"


@implementation FXDcameraGPU
- (void)rotateCamera {
	if (GlobalModule.isDeviceOld == NO) {
		[super rotateCamera];
		return;
	}


	FXDLog_DEFAULT;

	FXDLogBOOL(self.frontFacingCameraPresent);
	if (self.frontFacingCameraPresent == NO) {
		return;
	}


	NSError *error = nil;
	AVCaptureDeviceInput *captureInput = nil;

	AVCaptureDevicePosition modifiedPosition = [[videoInput device] position];
	modifiedPosition = (modifiedPosition == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;

	AVCaptureDevice *captureDevice = nil;
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];

	for (AVCaptureDevice *device in devices) {
		if ([device position] == modifiedPosition) {
			captureDevice = device;
		}
	}

	captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
	FXDLog_ERROR;

	if (captureInput != nil) {
		[_captureSession beginConfiguration];

		[_captureSession removeInput:videoInput];


		//MARK: In case of old device, preset has to be different
		_captureSession.sessionPreset = (modifiedPosition == AVCaptureDevicePositionBack) ? sessionPresetOptimalCapture:AVCaptureSessionPresetHigh;
		FXDLogObject(_captureSession.sessionPreset);


		if ([_captureSession canAddInput:captureInput]) {
			[_captureSession addInput:captureInput];
			videoInput = captureInput;
		}
		else {
			[_captureSession addInput:videoInput];
		}

		[_captureSession commitConfiguration];
	}

	_inputCamera = captureDevice;

	[self setOutputImageOrientation:self.outputImageOrientation];
}
@end

@implementation FXDfilterGPU
@end

@implementation FXDimageviewGPU
+ (instancetype)imageviewForBounds:(CGRect)bounds withImageFilter:(GPUImageFilter*)gpuimageFilter {	FXDLog_DEFAULT;
	FXDLogRect(bounds);

	FXDimageviewGPU *gpuviewCaptured = [[[self class] alloc] initWithFrame:bounds];
	gpuviewCaptured.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	gpuviewCaptured.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

	[gpuimageFilter addTarget:gpuviewCaptured];
	FXDLogObject([gpuimageFilter targets]);

	return gpuviewCaptured;
}
@end

@implementation FXDwriterGPU
+ (instancetype)movieWriterWithVideoSize:(CGSize)videoSize withFileURL:(NSURL*)fileURL withImageFilter:(GPUImageFilter*)gpuimageFilter {	FXDLog_DEFAULT;

	FXDLog(@"%@ %f", _Size(videoSize), (MAX(videoSize.width, videoSize.height)/MIN(videoSize.width, videoSize.height)));
	FXDLogObject(fileURL);
	FXDLogObject(gpuimageFilter);

	FXDwriterGPU *gpumovieWriter = [[FXDwriterGPU alloc]
									initWithMovieURL:fileURL
									size:videoSize
									fileType:AVFileTypeQuickTimeMovie
									outputSettings:nil];

	gpumovieWriter.uniqueKey = [NSString uniqueKeyFrom:[[NSDate date] timeIntervalSince1970]];

	gpumovieWriter.encodingLiveVideo = YES;
	[gpumovieWriter setHasAudioTrack:YES audioSettings:nil];

	[gpuimageFilter addTarget:gpumovieWriter];
	FXDLogObject([gpuimageFilter targets]);

	return gpumovieWriter;
}
@end


@implementation FXDmoduleGPU

#pragma mark - Memory management
- (void)dealloc {
	[self resetGPUmodule];
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

#warning //TODO: Test with more filters.
#warning //TODO: Find the way to apply filter AFTER recording

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

	_videoCamera = [[FXDcameraGPU alloc] initWithSessionPreset:sessionPresetOptimalCapture
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
- (void)prepareGPUmodule {	FXDLog_DEFAULT;
	//MARK: Make sure camera and filter are initialized here
	[self.videoCamera addTarget:self.cameraFilter];
}

- (void)resetGPUmodule {	FXDLog_DEFAULT;
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
	_cameraFilter = [[NSClassFromString(filterName) alloc] init];
	
	[_videoCamera addTarget:_cameraFilter];
}

@end
