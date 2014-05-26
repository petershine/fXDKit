//
//  FXDsuperGPUManager.m
//
//
//  Created by petershine on 5/21/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperGPUManager.h"


@implementation FXDcameraGPU
- (void)dealloc {	FXDLog_DEFAULT;
}
@end

@implementation FXDfiltergroupGPU
- (void)dealloc {	FXDLog_DEFAULT;
}
@end

@implementation FXDwriterGPU
- (void)dealloc {	FXDLog_DEFAULT;
}
@end

@implementation FXDimageviewGPU
- (void)dealloc {	FXDLog_DEFAULT;
}
@end


#pragma mark - Public implementation
@implementation FXDsuperGPUManager


#pragma mark - Memory management
- (void)dealloc {
	[_gpuvideoCamera stopCameraCapture];

	[_gpuvideoCamera removeAllTargets];
	[_gpufilterGroup removeAllTargets];

	[_gpuviewCaptured removeFromSuperview];
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

	   /*
		NSStringFromClass([GPUImageUnsharpMaskFilter class]),
		NSStringFromClass([GPUImageVoronoiConsumerFilter class]),
		NSStringFromClass([GPUImageWhiteBalanceFilter class]),
		NSStringFromClass([GPUImageWeakPixelInclusionFilter class]),
		NSStringFromClass([GPUimageDirectionalSobelEdgeDetectionFilter class]),
		NSStringFromClass([GPUImageThresholdEdgeDetectionFilter class]),
		NSStringFromClass([GPUImageThresholdedNonMaximumSuppressionFilter class]),
		NSStringFromClass([GPUImageToneCurveFilter class]),
		NSStringFromClass([GPUImageTransformFilter class]),
		NSStringFromClass([GPUImageTwoInputCrossTextureSamplingFilter class]),
		NSStringFromClass([GPUImageTwoInputFilter class]),
		NSStringFromClass([GPUImageTwoPassFilter class]),
		NSStringFromClass([GPUImageTwoPassTextureSamplingFilter class]),
		NSStringFromClass([GPUImageSaturationBlendFilter class]),
		NSStringFromClass([GPUImageSaturationFilter class]),
		NSStringFromClass([GPUImageScreenBlendFilter class]),
		NSStringFromClass([GPUImageShiTomasiFeatureDetectionFilter class]),
		NSStringFromClass([GPUImageSoftLightBlendFilter class]),
		NSStringFromClass([GPUImageSourceOverBlendFilter class]),
		NSStringFromClass([GPUImageSphereRefractionFilter class]),
		NSStringFromClass([GPUImageSubtractBlendFilter class]),
		NSStringFromClass([GPUImageSingleComponentGaussianBlurFilter class]),
		NSStringFromClass([GPUImageRGBClosingFilter class]),
		NSStringFromClass([GPUImageRGBDilationFilter class]),
		NSStringFromClass([GPUImageRGBErosionFilter class]),
		NSStringFromClass([GPUImageRGBOpeningFilter class]),
		NSStringFromClass([GPUImageParallelCoordinateLineTransformFilter class]),
		NSStringFromClass([GPUImagePerlinNoiseFilter class]),
		NSStringFromClass([GPUImagePoissonBlendFilter class]),
		NSStringFromClass([GPUImageNobleCornerDetectionFilter class]),
		NSStringFromClass([GPUImageNormalBlendFilter class]),

		NSStringFromClass([GPUImageOpacityFilter class]),
		NSStringFromClass([GPUImageOverlayBlendFilter class]),
		NSStringFromClass([GPUImageMosaicFilter class]),
		NSStringFromClass([GPUImageMultiplyBlendFilter class]),
		NSStringFromClass([GPUImageLanczosResamplingFilter class]),
		NSStringFromClass([GPUImageLaplacianFilter class]),
		NSStringFromClass([GPUImageLevelsFilter class]),
		NSStringFromClass([GPUImageLightenBlendFilter class]),
		NSStringFromClass([GPUImageLinearBurnBlendFilter class]),
		NSStringFromClass([GPUImageLookupFilter class]),
		NSStringFromClass([GPUImageLuminosityBlendFilter class]),

		NSStringFromClass([GPUImageMaskFilter class]),
		NSStringFromClass([GPUImageMedianFilter class]),
		NSStringFromClass([GPUImageJFAVoronoiFilter class]),
		NSStringFromClass([GPUImageDirectionalNonMaximumSuppressionFilter class]),
		NSStringFromClass([GPUImageHSBFilter class]),
		NSStringFromClass([GPUImageHardLightBlendFilter class]),
		NSStringFromClass([GPUImageHarrisCornerDetectionFilter class]),
		NSStringFromClass([GPUImageHighlightShadowFilter class]),
		NSStringFromClass([GPUImageHistogramFilter class]),
		NSStringFromClass([GPUImageHueBlendFilter class]),
		NSStringFromClass([GPUImageGaussianBlurPositionFilter class]),
		NSStringFromClass([GPUImageGaussianSelectiveBlurFilter class]),
		NSStringFromClass([GPUImageGlassSphereFilter class]),
		NSStringFromClass([GPUImageExclusionBlendFilter class]),
		NSStringFromClass([GPUImageExposureFilter class]),
		NSStringFromClass([GPUImageGammaFilter class]),
		NSStringFromClass([GPUImageCropFilter class]),
		NSStringFromClass([GPUImageDifferenceBlendFilter class]),
		NSStringFromClass([GPUImageDissolveBlendFilter class]),
		NSStringFromClass([GPUImageDivideBlendFilter class]),
		NSStringFromClass([GPUImage3x3ConvolutionFilter class]),
		NSStringFromClass([GPUImage3x3TextureSamplingFilter class]),
		NSStringFromClass([GPUImageAddBlendFilter class]),
		NSStringFromClass([GPUImageAlphaBlendFilter class]),
		NSStringFromClass([GPUImageBilateralFilter class]),
		NSStringFromClass([GPUImageChromaKeyBlendFilter class]),
		NSStringFromClass([GPUImageColorBlendFilter class]),
		NSStringFromClass([GPUImageColorBurnBlendFilter class]),
		NSStringFromClass([GPUImageColorInvertFilter class]),
		NSStringFromClass([GPUImageColorDodgeBlendFilter class]),
		NSStringFromClass([GPUImageBoxBlurFilter class]),
		NSStringFromClass([GPUImageBrightnessFilter class]),
		NSStringFromClass([GPUImageColorMatrixFilter class]),
		NSStringFromClass([GPUImageColorPackingFilter class]),
		NSStringFromClass([GPUImageContrastFilter class]),

		//MARK: Frame rate is terrible
		NSStringFromClass([GPUImageKuwaharaFilter class]),
		*/

	   ] mutableCopy];

	FXDLogVariable([_cycledFilterNameArray count]);

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

	[_gpuvideoCamera setDelegate:self];

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

#pragma mark -
- (FXDimageviewGPU*)gpuviewCaptured {
	if (_gpuviewCaptured) {
		return _gpuviewCaptured;
	}


	FXDLog_DEFAULT;

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	_gpuviewCaptured = [[FXDimageviewGPU alloc] initWithFrame:screenBounds];
	_gpuviewCaptured.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	_gpuviewCaptured.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

	return _gpuviewCaptured;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareGPUManagerWithFlashMode:(AVCaptureFlashMode)flashMode {	FXDLog_DEFAULT;
	FXDLogVariable(flashMode);

	[self.gpuvideoCamera.inputCamera applyDefaultConfigurationWithFlashMode:flashMode];
	[self.gpuvideoCamera.inputCamera addDefaultNotificationObserver:self];

	[self.gpuvideoCamera addTarget:self.gpufilterGroup];

	[self.gpufilterGroup addTarget:self.gpuviewCaptured];


	FXDLogObject([self.gpuvideoCamera targets]);
	FXDLogObject([self.gpufilterGroup targets]);
	FXDLogObject([self.gpufilterGroup.terminalFilter targets]);
}

#pragma mark -
- (void)prepareMovieWriterWithFormatDescription:(CMFormatDescriptionRef)formatDescription withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput {	FXDLog_DEFAULT;

	//TODO: Must distinguish between different size from the last movieWriter, especially for Front/Back camera changing
	
	CMVideoDimensions dimension = CMVideoFormatDescriptionGetDimensions(formatDescription);
	FXDLogStruct(dimension);

	CGSize videoSize = CGSizeMake(dimension.width, dimension.height);

	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

	if (UIDeviceOrientationIsLandscape(deviceOrientation) == NO) {
		videoSize.width = MIN(dimension.width, dimension.height);
		videoSize.height = MAX(dimension.width, dimension.height);
	}
	FXDLogSize(videoSize);


	self.gpumovieWriter = [[FXDwriterGPU alloc] initWithMovieURL:fileURL
															size:videoSize
														fileType:filetypeVideoDefault
												  outputSettings:nil];

	[self.gpumovieWriter setDelegate:self];

	self.gpumovieWriter.encodingLiveVideo = YES;
	[self.gpumovieWriter setHasAudioTrack:YES audioSettings:nil];
	[self.gpuvideoCamera setAudioEncodingTarget:self.gpumovieWriter];


	if (gpuimageOutput == nil) {
		gpuimageOutput = self.gpuvideoCamera;
	}

	[gpuimageOutput addTarget:self.gpumovieWriter];
}

#pragma mark -
- (void)cycleGPUfiltersForward:(BOOL)isForward {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@ %@", _Object(_gpumovieWriter), _Object(_gpuviewCaptured), _BOOL(isForward));

	NSInteger nextIndex = self.lastFilterIndex +(isForward ? 1:(-1));

	if (nextIndex < 0) {
		nextIndex = [self.cycledFilterNameArray count]-1;
	}
	else if (nextIndex == [self.cycledFilterNameArray count]) {
		nextIndex = 0;
	}

	FXDLogVariable(nextIndex);
	self.lastFilterIndex = nextIndex;


	NSString *filterName = self.cycledFilterNameArray[nextIndex];
	FXDLogObject(filterName);


	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	GPUImageFilter *nextFilter = [[NSClassFromString(filterName) alloc] init];
	[nextFilter forceProcessingAtSizeRespectingAspectRatio:screenBounds.size];

	self.gpufilterGroup.initialFilters = @[nextFilter];
	self.gpufilterGroup.terminalFilter = nextFilter;

	[self.gpufilterGroup addTarget:self.gpuviewCaptured];


	//TEST:
	if ([filterName isEqualToString:NSStringFromClass([GPUImageRGBFilter class])]) {
		filterName = @"Default";
	}

	filterName = [filterName stringByReplacingOccurrencesOfString:@"GPUImage" withString:@""];
	filterName = [filterName stringByReplacingOccurrencesOfString:@"Filter" withString:@""];

	UILabel *filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	filterLabel.text = filterName;
	filterLabel.font = [UIFont boldSystemFontOfSize:20.0];
	filterLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alphaValue08];
	filterLabel.textColor = [UIColor whiteColor];
	filterLabel.textAlignment = NSTextAlignmentCenter;

	filterLabel.alpha = 0.0;
	FXDWindow *applicationWindow = [FXDWindow mainWindow];
	[applicationWindow addSubview:filterLabel];

	[filterLabel updateWithXYratio:CGPointMake(0.5, 0.5)
						 forBounds:applicationWindow.bounds
					   forDuration:0.0
					  withRotation:0.0];

	[UIView
	 animateWithDuration:durationSlowAnimation
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseInOut
	 animations:^{
		 filterLabel.alpha = 1.0;

	 } completion:^(BOOL finished) {
		 GlobalAppManager.snapshotManager.snapshotOverlay.layer.contents = nil;

		 [UIView
		  animateWithDuration:durationSlowAnimation
		  delay:0.0
		  options:UIViewAnimationOptionCurveEaseInOut
		  animations:^{
			  filterLabel.alpha = 0.0;

		  } completion:^(BOOL finished) {
			  [filterLabel removeFromSuperview];
		  }];
	 }];
}


//MARK: - Observer implementation
- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLogObject(notification);
}

- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLogObject(notification);
}

- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification {	//FXDLog_DEFAULT;
	//FXDLogObject(notification);
}

//MARK: - Delegate implementation
#pragma mark - GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {	FXDLog_OVERRIDE;
	FXDLogTime(CMSampleBufferGetPresentationTimeStamp(sampleBuffer));
}

#pragma mark - GPUImageMovieWriterDelegate
- (void)movieRecordingFailedWithError:(NSError*)error {	FXDLog_OVERRIDE;
	FXDLog_ERROR;
}

@end
