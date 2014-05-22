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
- (instancetype)init {
	self = [super init];

	if (self) {
		//TEST:
		//_shouldUseGPUpreview = [GlobalAppManager.shouldUseGPUpreview boolValue];
		self.shouldUseGPUpreview = YES;
		FXDLogBOOL(_shouldUseGPUpreview);
	}

	return self;
}

#pragma mark - Property overriding
- (AVCaptureSession*)mainCaptureSession {
	if (_mainCaptureSession) {
		return _mainCaptureSession;
	}


	FXDLog_DEFAULT;
	_mainCaptureSession = self.gpuvideoCamera.captureSession;

	return _mainCaptureSession;
}

- (AVCaptureVideoPreviewLayer*)mainPreviewLayer {
	if (self.shouldUseGPUpreview) {
		return nil;
	}


	if (_mainPreviewLayer) {
		return _mainPreviewLayer;
	}


	_mainPreviewLayer = [super mainPreviewLayer];

	return _mainPreviewLayer;
}

#pragma mark -
- (FXDcameraGPU*)gpuvideoCamera {
	if (_gpuvideoCamera) {
		return _gpuvideoCamera;
	}


	FXDLog_DEFAULT;

	_gpuvideoCamera = [[FXDcameraGPU alloc] initWithSessionPreset:AVCaptureSessionPresetHigh
												   cameraPosition:self.cameraPosition];

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
- (void)prepareCaptureManagerWithScene:(UIViewController*)scene {
	[super prepareCaptureManagerWithScene:scene];

	//MARK: To re-apply new orientation
	[self observedUIDeviceOrientationDidChange:nil];


	[self.gpuvideoCamera.inputCamera applyDefaultConfigurationWithFlashMode:self.flashMode];
	[self.gpuvideoCamera.inputCamera addDefaultNotificationObserver:self];

	[self.gpuvideoCamera addTarget:self.gpufilterGroup];


	if (self.shouldUseGPUpreview) {
		[scene.view addSubview:self.gpuviewCaptured];
		[scene.view sendSubviewToBack:self.gpuviewCaptured];

		[self.gpufilterGroup addTarget:self.gpuviewCaptured];
	}
	else {
		[scene.view.layer insertSublayer:self.mainPreviewLayer atIndex:0];

		self.mainPreviewLayer.frame = self.mainPreviewLayer.superlayer.bounds;
	}

	FXDLogObject([self.gpuvideoCamera targets]);
	FXDLogObject([self.gpufilterGroup targets]);
	FXDLogObject([self.gpufilterGroup.terminalFilter targets]);


	@weakify(self);

	[RACObserve(GlobalAppManager, shouldUseMirroredFront)
	 subscribeNext:^(id shouldUseMirroredFront) {	@strongify(self);
		 FXDLog_REACT(shouldUseMirroredFront, shouldUseMirroredFront);

		 self.shouldUseMirroring = [shouldUseMirroredFront boolValue];

		 self.gpuvideoCamera.horizontallyMirrorFrontFacingCamera = self.shouldUseMirroring;
		 FXDLogVariable(self.gpuvideoCamera.horizontallyMirrorFrontFacingCamera);

		 self.mainPreviewLayer.connection.automaticallyAdjustsVideoMirroring = self.shouldUseMirroring;
		 FXDLogBOOL(self.mainPreviewLayer.connection.automaticallyAdjustsVideoMirroring);
	 }];

	[self.gpuvideoCamera startCameraCapture];
}

#pragma mark -
- (void)configurePreviewDisplayForBounds:(CGRect)bounds forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation forDuration:(NSTimeInterval)duration {

	if (self.shouldUseGPUpreview) {
		//MARK: Animation not working for GPUImageView
		self.gpuviewCaptured.frame = bounds;
		return;
	}


	[super configurePreviewDisplayForBounds:bounds
					forInterfaceOrientation:interfaceOrientation
								forDuration:duration];
}

#pragma mark -
- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPostion {

	if (self.shouldUseGPUpreview) {
		[self.gpuvideoCamera rotateCamera];
	}
	else {
		[super configureSessionWithCameraPosition:cameraPostion];
	}

	self.cameraPosition = cameraPostion;
}


#pragma mark - Public
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
- (void)cycleGPUfilters {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Object(_gpumovieWriter), _Object(_gpuviewCaptured));

	if (_cycledFilterNameArray == nil) {
		_cycledFilterNameArray = [@[NSStringFromClass([GPUImageRGBFilter class]),
									NSStringFromClass([GPUImageGaussianBlurFilter class]),
									NSStringFromClass([GPUImageGrayscaleFilter class]),
									NSStringFromClass([GPUImageHazeFilter class]),
									NSStringFromClass([GPUImagePixellateFilter class]),
									NSStringFromClass([GPUImageAmatorkaFilter class]),
									NSStringFromClass([GPUImageErosionFilter class]),

									//MARK: Frame rate is terrible
									//NSStringFromClass([GPUImageKuwaharaFilter class]),
									
									] mutableCopy];
	}

	NSString *filterName = [self.cycledFilterNameArray lastObject];
	FXDLogObject(filterName);


	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	GPUImageFilter *nextFilter = [[NSClassFromString(filterName) alloc] init];
	[nextFilter forceProcessingAtSizeRespectingAspectRatio:screenBounds.size];

	self.gpufilterGroup.initialFilters = @[nextFilter];
	self.gpufilterGroup.terminalFilter = nextFilter;

	[self.gpufilterGroup addTarget:self.gpuviewCaptured];

	FXDLogObject([self.gpuvideoCamera targets]);
	FXDLogObject([self.gpufilterGroup targets]);
	FXDLogObject([self.gpufilterGroup.terminalFilter targets]);


	if (self.cycledFilterNameArray) {
		[self.cycledFilterNameArray removeLastObject];

		[self.cycledFilterNameArray insertObject:filterName atIndex:0];

		FXDLogObject(self.cycledFilterNameArray);
	}

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
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification {
	[super observedUIDeviceOrientationDidChange:notification];

	if (self.didStartCapturing) {
		return;
	}


	self.gpuvideoCamera.outputImageOrientation = (UIInterfaceOrientation)self.videoOrientation;
}


//MARK: - Delegate implementation
#pragma mark - GPUImageVideoCameraDelegate
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {	FXDLog_OVERRIDE;
}

#pragma mark - GPUImageMovieWriterDelegate
- (void)movieRecordingFailedWithError:(NSError*)error {	FXDLog_OVERRIDE;
	FXDLog_ERROR;
}

@end
