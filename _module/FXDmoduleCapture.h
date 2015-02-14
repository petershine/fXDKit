

#define filternameScale		@"CILanczosScaleTransform"
#define filternameTransform		@"CIAffineTransform"


@import AVFoundation;

@interface AVCaptureDevice (MultimediaFrameworks)
+ (AVCaptureDevice*)videoCaptureDeviceForPosition:(AVCaptureDevicePosition)cameraPosition withFlashMode:(AVCaptureFlashMode)flashMode withFocusMode:(AVCaptureFocusMode)focusMode;
- (void)applyConfigurationWithFlashMode:(AVCaptureFlashMode)flashMode withFocusMode:(AVCaptureFocusMode)focusMode;
@end


#import "FXDsuperModule.h"
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


- (void)prepareCaptureManager;

- (void)switchCameraPosition;
- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPostion;

- (CIImage*)coreImageForCVImageBuffer:(CVImageBufferRef)imageBuffer withScale:(NSNumber*)scale withCameraPosition:(AVCaptureDevicePosition)cameraPosition withVideoOrientation:(AVCaptureVideoOrientation)videoOrientation shouldUseMirroring:(BOOL)shouldUseMirroring;

@end
