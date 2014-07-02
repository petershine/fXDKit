//
//  FXDmoduleCapture.h
//
//
//  Created by petershine on 3/6/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#define filternameScale		@"CILanczosScaleTransform"
#define filternameTransform		@"CIAffineTransform"


@import AVFoundation;


@interface FXDmoduleCapture : FXDsuperModule <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate> {
	AVCaptureSession *_mainCaptureSession;
	AVCaptureVideoPreviewLayer *_mainPreviewLayer;
}

@property (nonatomic) BOOL didStartCapturing;

@property (nonatomic) BOOL shouldUseMirroring;


@property (nonatomic) AVCaptureDevicePosition cameraPosition;
@property (nonatomic) AVCaptureFlashMode flashMode;
@property (nonatomic) AVCaptureVideoOrientation videoOrientation;


@property (strong, nonatomic) AVCaptureSession *mainCaptureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *mainPreviewLayer;

@property (strong, nonatomic) AVCaptureDeviceInput *deviceInputBack;
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInputFront;
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInputAudio;

@property (strong, nonatomic) AVCaptureVideoDataOutput *dataOutputVideo;
@property (strong, nonatomic) AVCaptureAudioDataOutput *dataOutputAudio;


#pragma mark - Initialization

#pragma mark - Public
- (void)prepareCaptureManager;

- (void)switchCameraPosition;
- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPostion;
- (void)addObserverToCaptureDevice:(AVCaptureDevice**)captureDevice;

- (CIImage*)coreImageForCVImageBuffer:(CVImageBufferRef)imageBuffer withScale:(NSNumber*)scale withCameraPosition:(AVCaptureDevicePosition)cameraPosition withVideoOrientation:(AVCaptureVideoOrientation)videoOrientation shouldUseMirroring:(BOOL)shouldUseMirroring;


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification;

- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
