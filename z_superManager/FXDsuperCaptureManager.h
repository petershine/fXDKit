//
//  FXDsuperCaptureManager.h
//
//
//  Created by petershine on 3/6/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@interface FXDsuperCaptureManager : FXDObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate> {
	AVCaptureSession *_mainCaptureSession;
	AVCaptureVideoPreviewLayer *_mainPreviewLayer;
}

// Properties
@property (nonatomic) BOOL didStartCapturing;
@property (nonatomic) BOOL shouldAppendSampleBuffer;

@property (nonatomic) BOOL shouldUseMirroredFront;

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
+ (FXDsuperCaptureManager*)sharedInstance;


#pragma mark - Public
- (void)prepareCaptureManager;

- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPostion;


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification;

//MARK: - Delegate implementation

@end