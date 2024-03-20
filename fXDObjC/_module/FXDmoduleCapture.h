
#import <fXDObjC/FXDimportEssential.h>

#define filternameScale		@"CILanczosScaleTransform"
#define filternameTransform		@"CIAffineTransform"


@interface AVCaptureDevice (MultimediaFrameworks)
+ (AVCaptureDevice*_Nullable)videoCaptureDeviceForPosition:(AVCaptureDevicePosition)cameraPosition withFlashMode:(AVCaptureFlashMode)flashMode withFocusMode:(AVCaptureFocusMode)focusMode;
- (void)applyConfigurationWithFlashMode:(AVCaptureFlashMode)flashMode withFocusMode:(AVCaptureFocusMode)focusMode;
@end


@interface FXDmoduleCapture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate> {
	AVCaptureSession *_mainCaptureSession;
	AVCaptureVideoPreviewLayer *_mainPreviewLayer;
	AVCaptureDeviceRotationCoordinator *_mainRotationCoordinator;
}

@property (nonatomic) BOOL didStartCapturing;

@property (nonatomic) BOOL shouldUseMirroring;


@property (nonatomic) AVCaptureDevicePosition cameraPosition;
@property (nonatomic) AVCaptureFlashMode flashMode;


@property (strong, nonatomic) AVCaptureSession * _Nullable mainCaptureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * _Nullable mainPreviewLayer;
@property (strong, nonatomic) AVCaptureDeviceRotationCoordinator * _Nullable mainRotationCoordinator;

@property (strong, nonatomic) AVCaptureDeviceInput * _Nullable deviceInputBack;
@property (strong, nonatomic) AVCaptureDeviceInput * _Nullable deviceInputFront;
@property (strong, nonatomic) AVCaptureDeviceInput * _Nullable deviceInputAudio;

@property (strong, nonatomic) AVCaptureVideoDataOutput * _Nullable dataOutputVideo;
@property (strong, nonatomic) AVCaptureAudioDataOutput * _Nullable dataOutputAudio;


- (void)prepareAndStartCaptureManager:(nullable UIView *)containerView;
- (void)startCaptureManager:(nullable UIView *)containerView;

- (void)switchCameraPosition;
- (void)configureSessionWithCameraPosition:(AVCaptureDevicePosition)cameraPostion;

- (CIImage*_Nullable)coreImageForCVImageBuffer:(CVImageBufferRef _Nullable )imageBuffer withScale:(NSNumber*_Nullable)scale withCameraPosition:(AVCaptureDevicePosition)cameraPosition withVideoRotationAngle:(CGFloat)rotationAngle shouldUseMirroring:(BOOL)shouldUseMirroring;

@end
