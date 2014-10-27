

#import "FXDmoduleGPU.h"

#import "FXDmoduleCapture.h"


@implementation FXDcameraGPU
- (void)rotateCamera {
	if (GlobalModule.isDevice_iPhoneFour.boolValue == NO) {
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
	//FXDLogObject([gpuimageFilter targets]);

	return gpuviewCaptured;
}
@end

@implementation FXDwriterGPU
- (void)dealloc {
	FXDLog_DEFAULT;
}

+ (instancetype)movieWriterWithVideoSize:(CGSize)videoSize withFileURL:(NSURL*)fileURL withImageFilter:(GPUImageFilter*)gpuimageFilter {	FXDLog_DEFAULT;

	FXDLog(@"%@ %f", _Size(videoSize), (MAX(videoSize.width, videoSize.height)/MIN(videoSize.width, videoSize.height)));
	FXDLogObject(fileURL);
	FXDLogObject(gpuimageFilter);

	FXDwriterGPU *gpumovieWriter = [[[self class] alloc] initWithMovieURL:fileURL
																	 size:videoSize
																 fileType:AVFileTypeQuickTimeMovie
														   outputSettings:nil];

	gpumovieWriter.encodingLiveVideo = YES;
	[gpumovieWriter setHasAudioTrack:YES audioSettings:nil];	

	[gpuimageFilter addTarget:gpumovieWriter];
	//FXDLogObject([gpuimageFilter targets]);

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

	   NSStringFromClass([GPUImageiOSBlurFilter class]),

	   NSStringFromClass([GPUImageAdaptiveThresholdFilter class]),
	   NSStringFromClass([GPUImageAmatorkaFilter class]),
	   NSStringFromClass([GPUImageAverageLuminanceThresholdFilter class]),

	   NSStringFromClass([GPUImageCGAColorspaceFilter class]),
	   NSStringFromClass([GPUImageCannyEdgeDetectionFilter class]),
	   NSStringFromClass([GPUImageChromaKeyFilter class]),
	   NSStringFromClass([GPUImageClosingFilter class]),
	   NSStringFromClass([GPUImageCrosshatchFilter class]),

	   NSStringFromClass([GPUImageDilationFilter class]),

	   NSStringFromClass([GPUImageEmbossFilter class]),
	   NSStringFromClass([GPUImageErosionFilter class]),

	   NSStringFromClass([GPUImageFalseColorFilter class]),

	   NSStringFromClass([GPUImageGaussianBlurFilter class]),
	   NSStringFromClass([GPUImageGrayscaleFilter class]),
	   NSStringFromClass([GPUImageHalftoneFilter class]),
	   NSStringFromClass([GPUImageHazeFilter class]),
	   NSStringFromClass([GPUImageHighPassFilter class]),

	   NSStringFromClass([GPUImageKuwaharaRadius3Filter class]),

	   NSStringFromClass([GPUImageLocalBinaryPatternFilter class]),
	   NSStringFromClass([GPUImageLowPassFilter class]),
	   NSStringFromClass([GPUImageLuminanceRangeFilter class]),
	   NSStringFromClass([GPUImageLuminanceThresholdFilter class]),

	   NSStringFromClass([GPUImageMissEtikateFilter class]),
	   NSStringFromClass([GPUImageMonochromeFilter class]),
	   NSStringFromClass([GPUImageMotionBlurFilter class]),

	   NSStringFromClass([GPUImageNonMaximumSuppressionFilter class]),

	   NSStringFromClass([GPUImageOpeningFilter class]),

	   NSStringFromClass([GPUImagePinchDistortionFilter class]),
	   NSStringFromClass([GPUImagePixellateFilter class]),
	   NSStringFromClass([GPUImagePixellatePositionFilter class]),
	   NSStringFromClass([GPUImagePolarPixellateFilter class]),
	   NSStringFromClass([GPUImagePolkaDotFilter class]),
	   NSStringFromClass([GPUImagePosterizeFilter class]),
	   NSStringFromClass([GPUImagePrewittEdgeDetectionFilter class]),

	   NSStringFromClass([GPUImageSepiaFilter class]),
	   NSStringFromClass([GPUImageSharpenFilter class]),
	   NSStringFromClass([GPUImageSketchFilter class]),
	   NSStringFromClass([GPUImageSmoothToonFilter class]),
	   NSStringFromClass([GPUImageSobelEdgeDetectionFilter class]),
	   NSStringFromClass([GPUImageSoftEleganceFilter class]),
	   NSStringFromClass([GPUImageStretchDistortionFilter class]),
	   NSStringFromClass([GPUImageSwirlFilter class]),

	   NSStringFromClass([GPUImageThresholdSketchFilter class]),
	   NSStringFromClass([GPUImageTiltShiftFilter class]),
	   NSStringFromClass([GPUImageToonFilter class]),


	   NSStringFromClass([GPUImageVignetteFilter class]),

	   NSStringFromClass([GPUImageXYDerivativeFilter class]),
	   NSStringFromClass([GPUImageZoomBlurFilter class]),

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

	[_videoCamera.inputCamera
	 applyConfigurationWithFlashMode:AVCaptureFlashModeAuto
	 withFocusMode:AVCaptureFocusModeContinuousAutoFocus];

	[_videoCamera addAudioInputsAndOutputs];

	return _videoCamera;
}

- (FXDfilterGPU*)cameraFilter {
	if (_cameraFilter) {
		return _cameraFilter;
	}


	FXDLog_DEFAULT;

	[self applyGPUfilterAtFilterIndex:self.lastFilterIndex shouldShowLabel:NO];

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
- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex shouldShowLabel:(BOOL)shouldShowLabel {	FXDLog_DEFAULT;
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
