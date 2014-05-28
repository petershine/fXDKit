//
//  FXDsuperGPUManager.h
//
//
//  Created by petershine on 5/21/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import <GPUImage.h>


@interface FXDcameraGPU : GPUImageVideoCamera
@end

@interface FXDfiltergroupGPU : GPUImageFilterGroup
@end

@interface FXDimageviewGPU : GPUImageView
@end

@interface FXDwriterGPU : GPUImageMovieWriter
@property (nonatomic) CMTime startTime;
@property (strong, nonatomic) NSString *uniqueKey;
@end


@interface FXDsuperGPUManager : FXDsuperManager
@property (nonatomic) NSInteger lastFilterIndex;

@property (strong, nonatomic) NSMutableArray *cycledFilterNameArray;

@property (strong, nonatomic) FXDcameraGPU *gpuvideoCamera;
@property (strong, nonatomic) FXDfiltergroupGPU *gpufilterGroup;


#pragma mark - Public
- (void)prepareGPUManager;
- (void)resetGPUManager;

- (void)cycleGPUfiltersForward:(BOOL)isForward;
- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex;

- (FXDimageviewGPU*)newGPUImageviewWithGPUImageOutput:(GPUImageOutput*)gpuimageOutput;
- (FXDwriterGPU*)newGPUMovieWriterForFormatDescription:(CMFormatDescriptionRef)formatDescription withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput;


//MARK: - Observer implementation
- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
