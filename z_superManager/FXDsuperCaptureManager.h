//
//  FXDsuperCaptureManager.h
//
//
//  Created by petershine on 3/6/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@interface UIDevice (Added)
- (CGAffineTransform)affineTransformForOrientation;
- (CGAffineTransform)affineTransformForOrientationAndForPosition:(AVCaptureDevicePosition)cameraPosition;
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition;

- (CGRect)screenFrameForOrientation;
- (CGRect)screenFrameForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


@interface AVCaptureDevice (Added)
+ (AVCaptureDevice*)videoCaptureDeviceFoPosition:(AVCaptureDevicePosition)cameraPosition withFlashMode:(AVCaptureFlashMode)flashMode;
- (void)applyDefaultConfigurationWithFlashMode:(AVCaptureFlashMode)flashMode;
@end


@interface FXDsuperCaptureManager : FXDObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate> {
	AVCaptureSession *_captureSession;
}

// Properties
@property (nonatomic) AVCaptureDevicePosition cameraPosition;
@property (nonatomic) AVCaptureFlashMode captureFlashMode;
@property (nonatomic) AVCaptureVideoOrientation capturedVideoOrientation;

@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *capturePreviewLayer;

@property (strong, nonatomic) AVCaptureDeviceInput *captureInputBack;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInputFront;
@property (strong, nonatomic) AVCaptureDeviceInput *captureInputAudio;

@property (strong, nonatomic) AVCaptureVideoDataOutput *capturedVideoOutput;
@property (strong, nonatomic) AVCaptureAudioDataOutput *capturedAudioOutput;


#pragma mark - Initialization
+ (FXDsuperCaptureManager*)sharedInstance;


#pragma mark - Public
- (void)prepareCaptureManager;

- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPostion;


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
