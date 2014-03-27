//
//  FXDsuperCaptureManager.m
//
//
//  Created by petershine on 3/6/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperCaptureManager.h"


@implementation AVCaptureDevice (Added)
+ (AVCaptureDevice*)videoCaptureDeviceFoPosition:(AVCaptureDevicePosition)cameraPosition withFlashMode:(AVCaptureFlashMode)flashMode {

	AVCaptureDevice *videoCaptureDevice = nil;

	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];

	for (AVCaptureDevice *device in devices) {

		if ([device position] != cameraPosition) {
			continue;
		}


		videoCaptureDevice = device;
		break;
	}

	[videoCaptureDevice applyDefaultConfigurationWithFlashMode:flashMode];

	return videoCaptureDevice;
}

- (void)applyDefaultConfigurationWithFlashMode:(AVCaptureFlashMode)flashMode {
	NSError *error = nil;

	if ([self lockForConfiguration:&error]) {

		if ([self isFlashModeSupported:flashMode]) {
			self.flashMode = flashMode;
		}

		if ([self isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
			self.focusMode = AVCaptureFocusModeContinuousAutoFocus;
		}

		if ([self isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
			self.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
		}

		if ([self isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
			self.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
		}

		self.subjectAreaChangeMonitoringEnabled = YES;

		[self unlockForConfiguration];
	}

	FXDLog_ERROR;
}
@end


#pragma mark - Public implementation
@implementation FXDsuperCaptureManager


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[_mainCaptureSession stopRunning];

	[_mainPreviewLayer removeFromSuperlayer];

	for (AVCaptureDeviceInput *deviceInput in _mainCaptureSession.inputs) {
		[_mainCaptureSession removeInput:deviceInput];
	}
}


#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		_cameraPosition = AVCaptureDevicePositionBack;
		_flashMode = AVCaptureFlashModeAuto;
		_videoOrientation = AVCaptureVideoOrientationPortrait;
	}

	return self;
}

#pragma mark -
+ (FXDsuperCaptureManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (AVCaptureSession*)mainCaptureSession {
	if (_mainCaptureSession) {
		return _mainCaptureSession;
	}


	FXDLog_DEFAULT;
	_mainCaptureSession = [AVCaptureSession new];

	NSString *captureSessionPreset = AVCaptureSessionPresetHigh;


	[_mainCaptureSession beginConfiguration];

	if ([_mainCaptureSession canSetSessionPreset:captureSessionPreset]) {
		[_mainCaptureSession setSessionPreset:captureSessionPreset];
	}


	//TODO: When taking a phone call, this error appear
	//ERROR: [0x2bdb000] AVAudioSessionPortImpl.mm:50: ValidateRequiredFields: Unknown selected data source for Port iPhone Microphone (type: MicrophoneBuiltIn)
	if ([_mainCaptureSession canAddInput:self.deviceInputAudio]) {
		[_mainCaptureSession addInput:self.deviceInputAudio];
	}

	//FXDLogObject([_mainCaptureSession inputs]);


	//TODO: Try using separate two queues like GPUImage did"
	dispatch_queue_t sampleCapturingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

	if ([_mainCaptureSession canAddOutput:self.dataOutputVideo]) {

		NSDictionary *outputSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
		[self.dataOutputVideo setVideoSettings:outputSettings];

		self.dataOutputVideo.alwaysDiscardsLateVideoFrames = NO;

		[self.dataOutputVideo
		 setSampleBufferDelegate:self
		 queue:sampleCapturingQueue];

		[_mainCaptureSession addOutput:self.dataOutputVideo];
	}

	if ([_mainCaptureSession canAddOutput:self.dataOutputAudio]) {

		// for audio, we want the channels and sample rate, but we can't get those from audioout.audiosettings on ios, so
        // we need to wait for the first sample

		[self.dataOutputAudio
		 setSampleBufferDelegate:self
		 queue:sampleCapturingQueue];

		[_mainCaptureSession addOutput:self.dataOutputAudio];
	}

	[_mainCaptureSession commitConfiguration];


	return _mainCaptureSession;
}

#pragma mark -
- (AVCaptureVideoPreviewLayer*)mainPreviewLayer {
	if (_mainPreviewLayer) {
		return _mainPreviewLayer;
	}


	_mainPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.mainCaptureSession];
	[_mainPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];


	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Rect(_mainPreviewLayer.frame), _Rect(_mainPreviewLayer.bounds));

	return _mainPreviewLayer;
}

#pragma mark -
- (AVCaptureDeviceInput*)deviceInputBack {
	if (_deviceInputBack == nil) {	//FXDLog_DEFAULT;

		AVCaptureDevice *backVideoCapture = [AVCaptureDevice
											 videoCaptureDeviceFoPosition:AVCaptureDevicePositionBack
											 withFlashMode:self.flashMode];

		NSError *error = nil;
		_deviceInputBack = [[AVCaptureDeviceInput alloc]
							 initWithDevice:backVideoCapture
							 error:&error];FXDLog_ERROR;
	}

	return _deviceInputBack;
}

- (AVCaptureDeviceInput*)deviceInputFront {
	if (_deviceInputFront == nil) {	//FXDLog_DEFAULT;

		AVCaptureDevice *frontVideoCapture = [AVCaptureDevice
											  videoCaptureDeviceFoPosition:AVCaptureDevicePositionFront
											  withFlashMode:self.flashMode];

		NSError *error = nil;
		_deviceInputFront = [[AVCaptureDeviceInput alloc]
							  initWithDevice:frontVideoCapture
							  error:&error];FXDLog_ERROR;
	}

	return _deviceInputFront;
}

- (AVCaptureDeviceInput*)deviceInputAudio {
	if (_deviceInputAudio == nil) {	//FXDLog_DEFAULT;

		NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];

		AVCaptureDevice *audioCapture = [devices firstObject];

		NSError *error = nil;
		_deviceInputAudio = [[AVCaptureDeviceInput alloc]
							  initWithDevice:audioCapture
							  error:&error];FXDLog_ERROR;
	}

	return _deviceInputAudio;
}

#pragma mark -
- (AVCaptureVideoDataOutput*)dataOutputVideo {
	if (_dataOutputVideo == nil) {	//FXDLog_DEFAULT;
		_dataOutputVideo = [AVCaptureVideoDataOutput new];
	}

	return _dataOutputVideo;
}

- (AVCaptureAudioDataOutput*)dataOutputAudio {
	if (_dataOutputAudio == nil) {	//FXDLog_DEFAULT;
		_dataOutputAudio = [AVCaptureAudioDataOutput new];
	}

	return _dataOutputAudio;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareCaptureManagerWithScene:(UIViewController*)scene {	FXDLog_DEFAULT;
	[self observedUIDeviceOrientationDidChangeNotification:nil];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedUIDeviceOrientationDidChangeNotification:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:nil];


	self.mainPreviewLayer.connection.automaticallyAdjustsVideoMirroring = self.shouldUseMirroring;

	[self.mainCaptureSession startRunning];
}

#pragma mark -
- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPosition {	FXDLog_DEFAULT;

	self.cameraPosition = cameraPosition;

	BOOL shouldRemoveBeforeAdd = self.mainCaptureSession.isRunning;
	FXDLogBOOL(shouldRemoveBeforeAdd);


	[self.mainCaptureSession beginConfiguration];

	if (shouldRemoveBeforeAdd) {
		FXDLog(@"1.%@", _Object(self.mainCaptureSession.inputs));

		for (AVCaptureDeviceInput *deviceInput in self.mainCaptureSession.inputs) {
			if (deviceInput != self.deviceInputAudio) {
				[self.mainCaptureSession removeInput:deviceInput];
			}
		}

		FXDLog(@"2.%@", _Object(self.mainCaptureSession.inputs));
	}

	if (self.cameraPosition == AVCaptureDevicePositionBack) {
		FXDLogBOOL([self.mainCaptureSession canAddInput:self.deviceInputBack]);

		if ([self.mainCaptureSession canAddInput:self.deviceInputBack]) {
			[self.mainCaptureSession addInput:self.deviceInputBack];
		}
	}
	else {
		FXDLogBOOL([self.mainCaptureSession canAddInput:self.deviceInputFront]);

		if ([self.mainCaptureSession canAddInput:self.deviceInputFront]) {
			[self.mainCaptureSession addInput:self.deviceInputFront];
		}
	}

	[self.mainCaptureSession commitConfiguration];

	FXDLog(@"3.%@", _Object(self.mainCaptureSession.inputs));
}


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification {
	if (self.didStartCapturing) {
		return;
	}


	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

	if (UIDeviceOrientationIsValidInterfaceOrientation(deviceOrientation) == NO) {
		//MARK: Use same orientation as last time
		deviceOrientation = (UIDeviceOrientation)self.videoOrientation;
	}


	FXDLog_DEFAULT;
	self.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
	FXDLogVar(self.videoOrientation);

	[self.mainPreviewLayer.connection setVideoOrientation:self.videoOrientation];
}


//MARK: - Delegate implementation
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//TEST:
/*
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

}
 */

@end
