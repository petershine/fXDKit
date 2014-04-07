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

	FXDLog_DEFAULT;
	[videoCaptureDevice applyDefaultConfigurationWithFlashMode:flashMode];

	return videoCaptureDevice;
}

- (void)applyDefaultConfigurationWithFlashMode:(AVCaptureFlashMode)flashMode {
	NSError *error = nil;

	if ([self lockForConfiguration:&error]) {

		if ([self isFlashModeSupported:flashMode]) {
			self.flashMode = flashMode;
		}

		if ([self isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
			self.focusMode = AVCaptureFocusModeAutoFocus;
		}

		if ([self isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
			self.exposureMode = AVCaptureExposureModeAutoExpose;
		}

		if ([self isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
			self.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
		}

		self.subjectAreaChangeMonitoringEnabled = YES;

		[self unlockForConfiguration];
	}

	FXDLog_DEFAULT;
	FXDLog(@"%@ %@ %@ %@ %@", _Variable(self.flashMode), _Variable(self.focusMode), _Variable(self.exposureMode), _Variable(self.whiteBalanceMode), _BOOL(self.subjectAreaChangeMonitoringEnabled));

	FXDLog_ERROR;
}

- (void)addDefaultNotificationObserver:(id)observer {	FXDLog_DEFAULT;
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:observer
	 selector:@selector(observedAVCaptureDeviceWasConnected:)
	 name:AVCaptureDeviceWasConnectedNotification
	 object:nil];

	[notificationCenter
	 addObserver:observer
	 selector:@selector(observedAVCaptureDeviceWasDisconnected:)
	 name:AVCaptureDeviceWasDisconnectedNotification
	 object:nil];

	[notificationCenter
	 addObserver:observer
	 selector:@selector(observedAVCaptureDeviceSubjectAreaDidChange:)
	 name:AVCaptureDeviceSubjectAreaDidChangeNotification
	 object:nil];
}
@end


#pragma mark - Public implementation
@implementation FXDsuperCaptureManager


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[_mainCaptureSession stopRunning];

	[_capturePreviewLayer removeFromSuperlayer];

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


	if ([_mainCaptureSession canAddInput:self.deviceInputAudio]) {
		[_mainCaptureSession addInput:self.deviceInputAudio];
	}


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
- (AVCaptureVideoPreviewLayer*)capturePreviewLayer {
	if (_capturePreviewLayer) {
		return _capturePreviewLayer;
	}


	_capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.mainCaptureSession];

	_capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;


	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Rect(_capturePreviewLayer.frame), _Rect(_capturePreviewLayer.bounds));

	return _capturePreviewLayer;
}

#pragma mark -
- (AVCaptureDeviceInput*)deviceInputBack {
	if (_deviceInputBack == nil) {

		AVCaptureDevice *backVideoCapture = [AVCaptureDevice
											 videoCaptureDeviceFoPosition:AVCaptureDevicePositionBack
											 withFlashMode:self.flashMode];
		[backVideoCapture addDefaultNotificationObserver:self];

		NSError *error = nil;
		_deviceInputBack = [[AVCaptureDeviceInput alloc] initWithDevice:backVideoCapture error:&error];
		FXDLog_ERROR;
	}

	return _deviceInputBack;
}

- (AVCaptureDeviceInput*)deviceInputFront {
	if (_deviceInputFront == nil) {

		AVCaptureDevice *frontVideoCapture = [AVCaptureDevice
											  videoCaptureDeviceFoPosition:AVCaptureDevicePositionFront
											  withFlashMode:self.flashMode];
		[frontVideoCapture addDefaultNotificationObserver:self];

		NSError *error = nil;
		_deviceInputFront = [[AVCaptureDeviceInput alloc] initWithDevice:frontVideoCapture error:&error];
		FXDLog_ERROR;
	}

	return _deviceInputFront;
}

- (AVCaptureDeviceInput*)deviceInputAudio {
	if (_deviceInputAudio == nil) {

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
	if (_dataOutputVideo == nil) {
		_dataOutputVideo = [AVCaptureVideoDataOutput new];
	}

	return _dataOutputVideo;
}

- (AVCaptureAudioDataOutput*)dataOutputAudio {
	if (_dataOutputAudio == nil) {
		_dataOutputAudio = [AVCaptureAudioDataOutput new];
	}

	return _dataOutputAudio;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareCaptureManagerWithScene:(UIViewController*)scene {	FXDLog_DEFAULT;
	[self observedUIDeviceOrientationDidChange:nil];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedUIDeviceOrientationDidChange:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:nil];


	self.capturePreviewLayer.connection.automaticallyAdjustsVideoMirroring = self.shouldUseMirroring;

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
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification {
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
	FXDLogVariable(self.videoOrientation);

	[self.capturePreviewLayer.connection setVideoOrientation:self.videoOrientation];
}

#pragma mark -
- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification {
	FXDLog_DEFAULT;
}

- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification {
	FXDLog_DEFAULT;
}

- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLogObject(notification);
}


//MARK: - Delegate implementation


@end
