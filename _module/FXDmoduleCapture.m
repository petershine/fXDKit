//
//  FXDmoduleCapture.m
//
//
//  Created by petershine on 3/6/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDmoduleCapture.h"



@implementation FXDmoduleCapture


#pragma mark - Memory management
- (void)dealloc {	
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

#pragma mark - Property overriding
- (AVCaptureSession*)mainCaptureSession {
	if (_mainCaptureSession) {
		return _mainCaptureSession;
	}


	FXDLog_DEFAULT;
	_mainCaptureSession = [[AVCaptureSession alloc] init];

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
- (AVCaptureVideoPreviewLayer*)mainPreviewLayer {
	if (_mainPreviewLayer) {
		return _mainPreviewLayer;
	}


	_mainPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.mainCaptureSession];
	_mainPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;


	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Rect(_mainPreviewLayer.frame), _Rect(_mainPreviewLayer.bounds));

	return _mainPreviewLayer;
}

#pragma mark -
- (AVCaptureDeviceInput*)deviceInputBack {
	if (_deviceInputBack == nil) {

		AVCaptureDevice *backVideoCapture = [AVCaptureDevice
											 videoCaptureDeviceFoPosition:AVCaptureDevicePositionBack
											 withFlashMode:self.flashMode];

		[self addObserverToCaptureDevice:&backVideoCapture];


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

		[self addObserverToCaptureDevice:&frontVideoCapture];
		

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
		_deviceInputAudio = [[AVCaptureDeviceInput alloc] initWithDevice:audioCapture error:&error];
		FXDLog_ERROR;
	}

	return _deviceInputAudio;
}

#pragma mark -
- (AVCaptureVideoDataOutput*)dataOutputVideo {
	if (_dataOutputVideo == nil) {
		_dataOutputVideo = [[AVCaptureVideoDataOutput alloc] init];
	}

	return _dataOutputVideo;
}

- (AVCaptureAudioDataOutput*)dataOutputAudio {
	if (_dataOutputAudio == nil) {
		_dataOutputAudio = [[AVCaptureAudioDataOutput alloc] init];
	}

	return _dataOutputAudio;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareCaptureManager {	FXDLog_DEFAULT;
	self.mainPreviewLayer.connection.automaticallyAdjustsVideoMirroring = self.shouldUseMirroring;

	[self.mainCaptureSession startRunning];


	[self observedUIDeviceOrientationDidChange:nil];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedUIDeviceOrientationDidChange:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:nil];
}

#pragma mark -
- (void)switchCameraPosition {
	AVCaptureDevicePosition cameraPosition = (self.cameraPosition == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;

	[self configureSessionWithCameraPosition:cameraPosition];
}

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

- (void)addObserverToCaptureDevice:(AVCaptureDevice**)captureDevice {	FXDLog_DEFAULT;

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedAVCaptureDeviceWasConnected:)
	 name:AVCaptureDeviceWasConnectedNotification
	 object:*captureDevice];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedAVCaptureDeviceWasDisconnected:)
	 name:AVCaptureDeviceWasDisconnectedNotification
	 object:*captureDevice];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedAVCaptureDeviceSubjectAreaDidChange:)
	 name:AVCaptureDeviceSubjectAreaDidChangeNotification
	 object:*captureDevice];
}

#pragma mark -
- (CIImage*)coreImageForCVImageBuffer:(CVImageBufferRef)imageBuffer withScale:(NSNumber*)scale withCameraPosition:(AVCaptureDevicePosition)cameraPosition withVideoOrientation:(AVCaptureVideoOrientation)videoOrientation shouldUseMirroring:(BOOL)shouldUseMirroring {

	//MARK: Other method	http://www.fantageek.com/598/convert-cmsamplebufferref-to-uiimage/

	CIImage *originalImage = [CIImage imageWithCVPixelBuffer:imageBuffer];

	if (scale) {
		CIFilter *scaleFilter = [CIFilter filterWithName:filternameScale];
		[scaleFilter setValue:originalImage forKey:kCIInputImageKey];

		[scaleFilter setValue:scale forKey:kCIInputScaleKey];

		originalImage = [scaleFilter valueForKey:kCIOutputImageKey];
	}


	if (UIDeviceOrientationIsLandscape(videoOrientation)
		&& cameraPosition == AVCaptureDevicePositionBack) {
		return originalImage;
	}


	CIFilter *transformFilter = [CIFilter filterWithName:filternameTransform];
	[transformFilter setValue:originalImage forKey:kCIInputImageKey];

	CGAffineTransform affineTransform = CGAffineTransformIdentity;


	if (cameraPosition != AVCaptureDevicePositionBack
		&& shouldUseMirroring) {
		affineTransform = CGAffineTransformScale(affineTransform, 1.0, -1.0);
		affineTransform = CGAffineTransformTranslate(affineTransform, 0.0, [originalImage extent].size.height);
	}


	if (UIDeviceOrientationIsLandscape(videoOrientation)) {
		if (cameraPosition != AVCaptureDevicePositionBack
			&& shouldUseMirroring == NO) {

			affineTransform = CGAffineTransformRotate(affineTransform, radianAngleForDegree(180.0));
		}
	}
	else {
		affineTransform = CGAffineTransformRotate(affineTransform, radianAngleForDegree(270.0));

		if (cameraPosition != AVCaptureDevicePositionBack
			&& shouldUseMirroring) {

			affineTransform = CGAffineTransformRotate(affineTransform, radianAngleForDegree(180.0));
		}
	}


	[transformFilter
	 setValue:[NSValue valueWithCGAffineTransform:affineTransform]
	 forKey:kCIInputTransformKey];

	return [transformFilter valueForKey:kCIOutputImageKey];
}


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification {
	if (self.didStartCapturing) {
		return;
	}


	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

	if (UIDeviceOrientationIsValidInterfaceOrientation(deviceOrientation) == NO) {
		deviceOrientation = (UIDeviceOrientation)self.videoOrientation;
	}


#if ForDEVELOPER
	if ((AVCaptureVideoOrientation)deviceOrientation != self.videoOrientation) {	FXDLog_DEFAULT;
		FXDLog(@"%@ %@", _Variable(deviceOrientation), _Variable(self.videoOrientation));
	}
#endif

	self.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;

	[self.mainPreviewLayer.connection setVideoOrientation:self.videoOrientation];
}

#pragma mark -
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


@end