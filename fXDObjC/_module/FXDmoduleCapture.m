

#import "FXDmoduleCapture.h"


@implementation AVCaptureDevice (MultimediaFrameworks)
+ (AVCaptureDevice*)videoCaptureDeviceForPosition:(AVCaptureDevicePosition)cameraPosition withFlashMode:(AVCaptureFlashMode)flashMode withFocusMode:(AVCaptureFocusMode)focusMode {

	AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice
										   defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
										   mediaType:AVMediaTypeVideo
										   position:cameraPosition];

	FXDLog_DEFAULT
	[videoCaptureDevice
	 applyConfigurationWithFlashMode:flashMode
	 withFocusMode:focusMode];

	return videoCaptureDevice;
}

- (void)applyConfigurationWithFlashMode:(AVCaptureFlashMode)flashMode withFocusMode:(AVCaptureFocusMode)focusMode {

	if (self.focusMode == focusMode
		&& self.exposureMode == AVCaptureExposureModeContinuousAutoExposure
		&& self.whiteBalanceMode == AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance
		&& self.subjectAreaChangeMonitoringEnabled) {

		return;
	}


	NSError *error = nil;

	if ([self lockForConfiguration:&error]) {

		if ([self isFocusModeSupported:focusMode]
			&& self.focusMode != focusMode) {

			self.focusMode = focusMode;
		}

		if ([self isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]
			&& self.exposureMode != AVCaptureExposureModeContinuousAutoExposure) {

			self.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
		}

		if ([self isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]
			&& self.whiteBalanceMode != AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance) {

			self.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
		}

		if (self.subjectAreaChangeMonitoringEnabled == NO) {
			self.subjectAreaChangeMonitoringEnabled = YES;
		}

		[self unlockForConfiguration];
	}

	FXDLog_DEFAULT

	FXDLogVariable(flashMode);
	FXDLogVariable(focusMode);
	FXDLog(@"%@ %@ %@ %@",
		   _Variable(self.focusMode),
		   _Variable(self.exposureMode),
		   _Variable(self.whiteBalanceMode),
		   _BOOL(self.subjectAreaChangeMonitoringEnabled));
	
	FXDLog_ERROR;
}
@end


@implementation FXDmoduleCapture

#pragma mark - Memory management
- (void)dealloc {
	[_mainCaptureSession stopRunning];

	[_mainPreviewLayer removeFromSuperlayer];

	for (AVCaptureDeviceInput *deviceInput in _mainCaptureSession.inputs) {
		[_mainCaptureSession removeInput:deviceInput];
	}

	_mainCaptureSession = nil;
	_mainPreviewLayer = nil;

	[_mainRotationCoordinator removeObserver:self forKeyPath:NSStringFromSelector(@selector(videoRotationAngleForHorizonLevelCapture))];
	[_mainRotationCoordinator removeObserver:self forKeyPath:NSStringFromSelector(@selector(videoRotationAngleForHorizonLevelPreview))];
	_mainRotationCoordinator = nil;
}

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		_cameraPosition = AVCaptureDevicePositionBack;
		_flashMode = AVCaptureFlashModeAuto;
	}

	return self;
}

#pragma mark - Property overriding
- (AVCaptureSession*)mainCaptureSession {
	if (_mainCaptureSession) {
		return _mainCaptureSession;
	}


	FXDLog_DEFAULT
	_mainCaptureSession = [[AVCaptureSession alloc] init];

	NSString *captureSessionPreset = AVCaptureSessionPresetHigh;


	[_mainCaptureSession beginConfiguration];

	if ([_mainCaptureSession canSetSessionPreset:captureSessionPreset]) {
		_mainCaptureSession.sessionPreset = captureSessionPreset;
	}


	if ([_mainCaptureSession canAddInput:self.deviceInputAudio]) {
		[_mainCaptureSession addInput:self.deviceInputAudio];
	}


	dispatch_queue_t sampleCapturingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

	if ([_mainCaptureSession canAddOutput:self.dataOutputVideo]) {

		NSDictionary *outputSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
		(self.dataOutputVideo).videoSettings = outputSettings;

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

	[self configureSessionWithCameraPosition:AVCaptureDevicePositionBack];

	return _mainCaptureSession;
}

#pragma mark -
- (AVCaptureVideoPreviewLayer*)mainPreviewLayer {
	if (_mainPreviewLayer) {
		return _mainPreviewLayer;
	}


	_mainPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.mainCaptureSession];
	_mainPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;


	FXDLog_DEFAULT
	FXDLog(@"%@ %@", _Rect(_mainPreviewLayer.frame), _Rect(_mainPreviewLayer.bounds));

	return _mainPreviewLayer;
}

- (AVCaptureDeviceRotationCoordinator*)mainRotationCoordinator {
	if (_mainRotationCoordinator) {
		return _mainRotationCoordinator;;
	}


	_mainRotationCoordinator = [[AVCaptureDeviceRotationCoordinator alloc]
								initWithDevice:self.deviceInputBack.device
								previewLayer:self.mainPreviewLayer];

	FXDLog_DEFAULT
	FXDLog(@"%@ %@", _mainRotationCoordinator.device, _mainRotationCoordinator.previewLayer);

	return _mainRotationCoordinator;
}

#pragma mark -
- (AVCaptureDeviceInput*)deviceInputBack {
	if (_deviceInputBack == nil) {

		AVCaptureDevice *backVideoCapture = [AVCaptureDevice
											 videoCaptureDeviceForPosition:AVCaptureDevicePositionBack
											 withFlashMode:self.flashMode
											 withFocusMode:AVCaptureFocusModeContinuousAutoFocus];

		NSError *error = nil;
		_deviceInputBack = [[AVCaptureDeviceInput alloc] initWithDevice:backVideoCapture error:&error];
		FXDLog_ERROR;
	}

	return _deviceInputBack;
}

- (AVCaptureDeviceInput*)deviceInputFront {
	if (_deviceInputFront == nil) {

		AVCaptureDevice *frontVideoCapture = [AVCaptureDevice
											  videoCaptureDeviceForPosition:AVCaptureDevicePositionFront
											  withFlashMode:self.flashMode
											  withFocusMode:AVCaptureFocusModeContinuousAutoFocus];

		NSError *error = nil;
		_deviceInputFront = [[AVCaptureDeviceInput alloc] initWithDevice:frontVideoCapture error:&error];
		FXDLog_ERROR;
	}

	return _deviceInputFront;
}

- (AVCaptureDeviceInput*)deviceInputAudio {
	if (_deviceInputAudio == nil) {

		AVCaptureDevice *audioCapture = [AVCaptureDevice
										 defaultDeviceWithDeviceType:AVCaptureDeviceTypeMicrophone
										 mediaType:AVMediaTypeAudio
										 position:AVCaptureDevicePositionUnspecified];

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
- (void)prepareAndStartCaptureManager:(nullable UIView *)containerView {
	//This app has crashed because it attempted to access privacy-sensitive data without a usage description.  
	//The app's Info.plist must contain an NSMicrophoneUsageDescription key with a string value explaining to the user how the app uses this data.
	//The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.

	AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	if (authorizationStatus == AVAuthorizationStatusAuthorized) {
		[self startCaptureManager:containerView];
		return;
	}


	[AVCaptureDevice
	 requestAccessForMediaType:AVMediaTypeVideo
	 completionHandler:^(BOOL granted) {
		if (granted) {
			[self startCaptureManager:containerView];
			return;
		}


		FXDLog_DEFAULT
		FXDLogBOOL(granted);
	}];
}

- (void)startCaptureManager:(nullable UIView *)containerView {	FXDLog_DEFAULT
	dispatch_async(dispatch_get_main_queue(), ^{
		if (containerView != nil) {
			self.mainPreviewLayer.frame = containerView.bounds;
			[containerView.layer addSublayer:self.mainPreviewLayer];
		}

		self.mainPreviewLayer.connection.automaticallyAdjustsVideoMirroring = self.shouldUseMirroring;

		AVCaptureDeviceRotationCoordinator *instantiatedCoordinator = self.mainRotationCoordinator;
		[instantiatedCoordinator addObserver:self forKeyPath:NSStringFromSelector(@selector(videoRotationAngleForHorizonLevelCapture)) options:NSKeyValueObservingOptionNew context:nil];
		[instantiatedCoordinator addObserver:self forKeyPath:NSStringFromSelector(@selector(videoRotationAngleForHorizonLevelPreview)) options:NSKeyValueObservingOptionNew context:nil];


		AVCaptureSession *instantiatedSession = self.mainCaptureSession;
		const char *captureManagerName = [NSStringFromClass([self class]) UTF8String];
		dispatch_queue_t backgroundQueue = dispatch_queue_create(captureManagerName, 0);
		dispatch_async(backgroundQueue, ^{
			//-[AVCaptureSession startRunning] should be called from background thread. Calling it on the main thread can lead to UI unresponsiveness
			[instantiatedSession startRunning];
		});
	});
}

#pragma mark -
- (void)switchCameraPosition {	FXDLog_DEFAULT
	AVCaptureDevicePosition cameraPosition = (self.cameraPosition == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;
	FXDLogVariable(cameraPosition);

	[self configureSessionWithCameraPosition:cameraPosition];
}

- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPosition {	FXDLog_DEFAULT

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

#pragma mark -
- (CIImage*_Nullable)coreImageForCVImageBuffer:(CVImageBufferRef _Nullable )imageBuffer withScale:(NSNumber*_Nullable)scale withCameraPosition:(AVCaptureDevicePosition)cameraPosition withVideoRotationAngle:(CGFloat)rotationAngle shouldUseMirroring:(BOOL)shouldUseMirroring {

	//MARK: Other method	http://www.fantageek.com/598/convert-cmsamplebufferref-to-uiimage/

	CIImage *originalImage = [CIImage imageWithCVPixelBuffer:imageBuffer];

	if (scale != nil) {
		CIFilter *scaleFilter = [CIFilter filterWithName:filternameScale];
		[scaleFilter setValue:originalImage forKey:kCIInputImageKey];

		[scaleFilter setValue:scale forKey:kCIInputScaleKey];

		originalImage = [scaleFilter valueForKey:kCIOutputImageKey];
	}


	if (rotationAngle == 90.0
		&& cameraPosition == AVCaptureDevicePositionBack) {
		return originalImage;
	}


	CIFilter *transformFilter = [CIFilter filterWithName:filternameTransform];
	[transformFilter setValue:originalImage forKey:kCIInputImageKey];

	CGAffineTransform affineTransform = CGAffineTransformIdentity;


	if (cameraPosition != AVCaptureDevicePositionBack
		&& shouldUseMirroring) {
		affineTransform = CGAffineTransformScale(affineTransform, 1.0, -1.0);
		affineTransform = CGAffineTransformTranslate(affineTransform, 0.0, originalImage.extent.size.height);
	}


	if (rotationAngle == 90.0) {
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

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	FXDLog_DEFAULT
	FXDLog(@"keyPath: %@, object: %@, change: %@, context: %@", keyPath, object, change, context);

	if ([keyPath isEqualToString:NSStringFromSelector(@selector(videoRotationAngleForHorizonLevelPreview))]) {
		AVCaptureDeviceRotationCoordinator *coordinator = object;
		AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer*)coordinator.previewLayer;
		previewLayer.connection.videoRotationAngle = coordinator.videoRotationAngleForHorizonLevelPreview;

		dispatch_async(dispatch_get_main_queue(), ^{
			previewLayer.frame = previewLayer.superlayer.bounds;
		});
	}
}


@end
