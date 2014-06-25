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

@implementation FXDimageviewGPU
- (void)dealloc {	FXDLog_DEFAULT;
}

+ (instancetype)imageviewWithGPUImageOutput:(GPUImageOutput*)gpuimageOutput {	FXDLog_DEFAULT;

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	FXDimageviewGPU *gpuviewCaptured = [[[self class] alloc] initWithFrame:screenBounds];
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

+ (instancetype)movieWriterWithFormatDescription:(CMFormatDescriptionRef)formatDescription withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput {	FXDLog_DEFAULT;

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


	FXDwriterGPU *gpumovieWriter = [[FXDwriterGPU alloc]
									initWithMovieURL:fileURL
									size:videoSize
									fileType:filetypeVideoDefault
									outputSettings:nil];

	gpumovieWriter.uniqueKey = [NSString uniqueKeyFrom:[[NSDate date] timeIntervalSince1970]];

	gpumovieWriter.encodingLiveVideo = YES;
	[gpumovieWriter setHasAudioTrack:YES audioSettings:nil];

	[gpuimageOutput addTarget:gpumovieWriter];
	FXDLogObject(gpuimageOutput.targets);

	return gpumovieWriter;
}

@end


#pragma mark - Public implementation
@implementation FXDsuperGPUManager


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
	[_gpuvideoCamera.inputCamera addDefaultNotificationObserver:self];

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
- (void)cycleGPUfiltersForward:(BOOL)isForward withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	NSInteger filterIndex = self.lastFilterIndex +(isForward ? 1:(-1));

	if (filterIndex < 0) {
		filterIndex = self.cycledFilterNameArray.count-1;
	}
	else if (filterIndex == self.cycledFilterNameArray.count) {
		filterIndex = 0;
	}

	FXDLogVariable(filterIndex);
	self.lastFilterIndex = filterIndex;


	[self applyGPUfilterAtFilterIndex:filterIndex];


	if (finishCallback) {
		finishCallback(_cmd, YES, @(filterIndex));
	}
}

- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex {	FXDLog_DEFAULT;
	NSString *filterName = self.cycledFilterNameArray[filterIndex];
	FXDLogObject(filterName);

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	GPUImageFilter *nextFilter = [[NSClassFromString(filterName) alloc] init];
	[nextFilter forceProcessingAtSizeRespectingAspectRatio:screenBounds.size];

	self.gpufilterGroup.initialFilters = @[nextFilter];
	self.gpufilterGroup.terminalFilter = nextFilter;
}


//MARK: - Observer implementation
- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLogObject(notification);
}

- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification {	FXDLog_OVERRIDE;
	FXDLogObject(notification);
}

- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification {	//FXDLog_DEFAULT;
	/*
#if ForDEVELOPER
	AVCaptureDevice *captureDevice = notification.object;

	NSString *log = @"";

	if (captureDevice.isAdjustingFocus) {
		log = [NSString stringWithFormat:@"%@", _BOOL(captureDevice.isAdjustingFocus)];
	}

	if (captureDevice.isAdjustingExposure) {
		log = [NSString stringWithFormat:@"%@ %@", log, _BOOL(captureDevice.isAdjustingExposure)];
	}

	if (captureDevice.isAdjustingWhiteBalance) {
		log = [NSString stringWithFormat:@"%@ %@", log, _BOOL(captureDevice.isAdjustingWhiteBalance)];
	}

	if (log.length > 0) {
		FXDLog(@"%@", log);
	}
#endif
	 */
}

//MARK: - Delegate implementation

@end
