//
//  FXDsuperCaptureManager.m
//
//
//  Created by petershine on 3/6/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperCaptureManager.h"

@implementation UIDevice (Added)
- (CGAffineTransform)affineTransformForOrientation {	//FXDLog_DEFAULT;

	CGAffineTransform affineTransform =
	[self
	 affineTransformForOrientation:self.orientation
	 forPosition:AVCaptureDevicePositionBack];

	return affineTransform;
}

- (CGAffineTransform)affineTransformForOrientationAndForPosition:(AVCaptureDevicePosition)cameraPosition {

	CGAffineTransform affineTransform =
	[self
	 affineTransformForOrientation:self.orientation
	 forPosition:cameraPosition];

	return affineTransform;
}

- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition {

	CGAffineTransform affineTransform = CGAffineTransformIdentity;

	switch (deviceOrientation) {
		case UIDeviceOrientationLandscapeLeft:
			affineTransform = CGAffineTransformMakeRotation( 0 / 180 );

			if (cameraPosition == AVCaptureDevicePositionFront) {
				affineTransform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 180 );
			}
			break;

		case UIDeviceOrientationLandscapeRight:
			affineTransform = CGAffineTransformMakeRotation( ( -180 * M_PI ) / 180 );

			if (cameraPosition == AVCaptureDevicePositionFront) {
				affineTransform = CGAffineTransformMakeRotation( 0 / 180 );
			}
			break;

		case UIDeviceOrientationPortraitUpsideDown:
			affineTransform = CGAffineTransformMakeRotation( ( -90 * M_PI ) / 180 );
			break;

		case UIDeviceOrientationUnknown:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
		case UIDeviceOrientationPortrait:
		default: {
			affineTransform =  CGAffineTransformMakeRotation( ( 90 * M_PI ) / 180 );
			break;
		}
	}

	//FXDLog(@"affineTransform: %@", NSStringFromCGAffineTransform(affineTransform));
	return affineTransform;
}

#pragma mark -
- (CGRect)screenFrameForOrientation {	//FXDLog_DEFAULT;

	CGRect screenFrame = [self screenFrameForOrientation:self.orientation];

	return screenFrame;
}

- (CGRect)screenFrameForOrientation:(UIDeviceOrientation)deviceOrientation {

	CGRect screenFrame = [UIScreen mainScreen].bounds;

	CGFloat screenWidth = screenFrame.size.width;
	CGFloat screenHeight = screenFrame.size.height;

	if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
		screenFrame.size.width = screenHeight;
		screenFrame.size.height = screenWidth;
	}

	//FXDLog(@"screenFrame: %@", NSStringFromCGRect(screenFrame));

	return screenFrame;
}

@end

#pragma mark -
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


@implementation AVPlayerItem (Added)
- (Float64)progressValue {
	return (CMTimeGetSeconds([self currentTime])/CMTimeGetSeconds(self.duration));
}
@end


#pragma mark - Public implementation
@implementation FXDsuperCaptureManager


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[_captureSession stopRunning];

	[_capturePreviewLayer removeFromSuperlayer];

	for (AVCaptureDeviceInput *deviceInput in _captureSession.inputs) {
		[_captureSession removeInput:deviceInput];
	}
}


#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
        //TODO:
	}

	return self;
}

#pragma mark -
+ (FXDsuperCaptureManager*)sharedInstance {
	IMPLEMENTATION_sharedInstance;
}


#pragma mark - Property overriding
- (AVCaptureSession*)captureSession {
	if (_captureSession) {
		return _captureSession;
	}


	FXDLog_DEFAULT;
	_captureSession = [AVCaptureSession new];

	NSString *captureSessionPreset = AVCaptureSessionPresetHigh;


	[_captureSession beginConfiguration];

	if ([_captureSession canSetSessionPreset:captureSessionPreset]) {
		[_captureSession setSessionPreset:captureSessionPreset];
	}


	[self configureSessionWithCameraPosition:self.cameraPosition];


	//TODO: When taking a phone call, this error appear
	//ERROR: [0x2bdb000] AVAudioSessionPortImpl.mm:50: ValidateRequiredFields: Unknown selected data source for Port iPhone Microphone (type: MicrophoneBuiltIn)
	if ([_captureSession canAddInput:self.captureInputAudio]) {
		[_captureSession addInput:self.captureInputAudio];
	}

	//FXDLog(@"_captureSession inputs: %@", [_captureSession inputs]);


	//TODO: Try using separate two queues like GPUImage did"
	dispatch_queue_t sampleCapturingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
	FXDLog(@"sampleCapturingQueue: %@", sampleCapturingQueue);

	if ([_captureSession canAddOutput:self.capturedVideoOutput]) {

		[self.capturedVideoOutput
		 setSampleBufferDelegate:self
		 queue:sampleCapturingQueue];

		[_captureSession addOutput:self.capturedVideoOutput];
	}

	if ([_captureSession canAddOutput:self.capturedAudioOutput]) {

		[self.capturedAudioOutput
		 setSampleBufferDelegate:self
		 queue:sampleCapturingQueue];

		[_captureSession addOutput:self.capturedAudioOutput];
	}

	[_captureSession commitConfiguration];


	return _captureSession;
}

#pragma mark -
- (AVCaptureVideoPreviewLayer*)capturePreviewLayer {
	if (_capturePreviewLayer == nil) {	FXDLog_DEFAULT;
		_capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];

		[_capturePreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
	}

	return _capturePreviewLayer;
}

#pragma mark -
- (AVCaptureDeviceInput*)captureInputBack {
	if (_captureInputBack == nil) {	//FXDLog_DEFAULT;

		AVCaptureDevice *backVideoCapture = [AVCaptureDevice
											 videoCaptureDeviceFoPosition:AVCaptureDevicePositionBack
											 withFlashMode:self.captureFlashMode];

		NSError *error = nil;
		_captureInputBack = [[AVCaptureDeviceInput alloc]
							 initWithDevice:backVideoCapture
							 error:&error];FXDLog_ERROR;
	}

	return _captureInputBack;
}

- (AVCaptureDeviceInput*)captureInputFront {
	if (_captureInputFront == nil) {	//FXDLog_DEFAULT;

		AVCaptureDevice *frontVideoCapture = [AVCaptureDevice
											  videoCaptureDeviceFoPosition:AVCaptureDevicePositionFront
											  withFlashMode:self.captureFlashMode];

		NSError *error = nil;
		_captureInputFront = [[AVCaptureDeviceInput alloc]
							  initWithDevice:frontVideoCapture
							  error:&error];FXDLog_ERROR;
	}

	return _captureInputFront;
}

- (AVCaptureDeviceInput*)captureInputAudio {
	if (_captureInputAudio == nil) {	//FXDLog_DEFAULT;

		NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
		FXDLog(@"audio devices: %@", devices);

		AVCaptureDevice *audioCapture = [devices firstObject];

		NSError *error = nil;
		_captureInputAudio = [[AVCaptureDeviceInput alloc]
							  initWithDevice:audioCapture
							  error:&error];FXDLog_ERROR;
	}

	return _captureInputAudio;
}

#pragma mark -
- (AVCaptureVideoDataOutput*)capturedVideoOutput {
	if (_capturedVideoOutput == nil) {	//FXDLog_DEFAULT;

		_capturedVideoOutput = [AVCaptureVideoDataOutput new];

		NSDictionary *outputSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
		[_capturedVideoOutput setVideoSettings:outputSettings];

		_capturedVideoOutput.alwaysDiscardsLateVideoFrames = NO;
	}

	return _capturedVideoOutput;
}

- (AVCaptureAudioDataOutput*)capturedAudioOutput {
	if (_capturedAudioOutput == nil) {	//FXDLog_DEFAULT;

		_capturedAudioOutput = [AVCaptureAudioDataOutput new];

        // for audio, we want the channels and sample rate, but we can't get those from audioout.audiosettings on ios, so
        // we need to wait for the first sample
	}

	return _capturedAudioOutput;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareCaptureManager {	FXDLog_DEFAULT;
	self.cameraPosition = AVCaptureDevicePositionBack;
	self.captureFlashMode = AVCaptureFlashModeAuto;
	self.capturedVideoOrientation = AVCaptureVideoOrientationPortrait;

	self.capturePreviewLayer.connection.automaticallyAdjustsVideoMirroring = NO;
	self.capturePreviewLayer.connection.videoMirrored = NO;


	[self observedUIDeviceOrientationDidChangeNotification:nil];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedUIDeviceOrientationDidChangeNotification:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:nil];


	[self.captureSession startRunning];
}

#pragma mark -
- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPosition {	FXDLog_DEFAULT;

	self.cameraPosition = cameraPosition;

	BOOL shouldRemoveBeforeAdd = _captureSession.isRunning;
	FXDLog(@"shouldRemoveBeforeAdd: %d", shouldRemoveBeforeAdd);


	[_captureSession beginConfiguration];

	if (shouldRemoveBeforeAdd) {
		FXDLog(@"1._captureSession.inputs: %@", _captureSession.inputs);

		for (AVCaptureDeviceInput *deviceInput in _captureSession.inputs) {
			if (deviceInput != self.captureInputAudio) {
				[_captureSession removeInput:deviceInput];
			}
		}

		FXDLog(@"2._captureSession.inputs: %@", _captureSession.inputs);
	}

	if (self.cameraPosition == AVCaptureDevicePositionBack) {
		FXDLog(@"canAddInput:self.captureInputBack: %d", [_captureSession canAddInput:self.captureInputBack]);

		if ([_captureSession canAddInput:self.captureInputBack]) {
			[_captureSession addInput:self.captureInputBack];
		}
	}
	else {
		FXDLog(@"canAddInput:self.captureInputFront: %d", [_captureSession canAddInput:self.captureInputFront]);

		if ([_captureSession canAddInput:self.captureInputFront]) {
			[_captureSession addInput:self.captureInputFront];
		}
	}

	[_captureSession commitConfiguration];

	FXDLog(@"3._captureSession.inputs: %@", _captureSession.inputs);
}


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification {

	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

	if (UIDeviceOrientationIsValidInterfaceOrientation(deviceOrientation) == NO) {
		return;
	}


	FXDLog_DEFAULT;
	FXDLog(@"deviceOrientation: %ld", deviceOrientation);

	[self.capturePreviewLayer.connection setVideoOrientation:(AVCaptureVideoOrientation)deviceOrientation];

	self.capturedVideoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
}


//MARK: - Delegate implementation
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

@end
