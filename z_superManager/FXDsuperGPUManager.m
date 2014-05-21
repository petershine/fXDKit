//
//  FXDsuperGPUManager.m
//
//
//  Created by petershine on 5/21/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperGPUManager.h"


@implementation FXDcameraGPU
@end

@implementation FXDfiltergroupGPU
@end

@implementation FXDwriterGPU
@end

@implementation FXDimageviewGPU
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
		_shouldUseGPUpreview = [GlobalAppManager.shouldUseGPUpreview boolValue];
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

	if (self.shouldUseGPUpreview) {
		[scene.view addSubview:self.gpuviewCaptured];
		[scene.view sendSubviewToBack:self.gpuviewCaptured];

		[self.gpufilterGroup addTarget:self.gpuviewCaptured];
	}
	else {
		[scene.view.layer insertSublayer:self.mainPreviewLayer atIndex:0];

		self.mainPreviewLayer.frame = self.mainPreviewLayer.superlayer.bounds;
	}


	//MARK: To re-apply new orientation
	[self observedUIDeviceOrientationDidChange:nil];

	[self.gpuvideoCamera.inputCamera applyDefaultConfigurationWithFlashMode:self.flashMode];
	[self.gpuvideoCamera.inputCamera addDefaultNotificationObserver:self];

	[self.gpuvideoCamera addTarget:self.gpufilterGroup];

	FXDLogObject([self.gpuvideoCamera targets]);


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

	if (self.shouldUseGPUpreview == NO) {
		[super configurePreviewDisplayForBounds:bounds
						forInterfaceOrientation:interfaceOrientation
									forDuration:duration];
		return;
	}


	//MARK: Animation not working
	self.gpuviewCaptured.frame = bounds;
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


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification {
	[super observedUIDeviceOrientationDidChange:notification];

	if (self.didStartCapturing) {
		return;
	}


	self.gpuvideoCamera.outputImageOrientation = (UIInterfaceOrientation)self.videoOrientation;
}

#pragma mark -
- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification {

}

- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification {

}

- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification {
#warning //TODO: Implement focused activities
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
