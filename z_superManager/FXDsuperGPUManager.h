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
+ (instancetype)imageviewWithGPUImageOutput:(GPUImageOutput*)gpuimageOutput;
@end

@interface FXDwriterGPU : GPUImageMovieWriter
@property (nonatomic) CMTime startTime;
@property (strong, nonatomic) NSString *uniqueKey;

+ (instancetype)movieWriterWithFormatDescription:(CMFormatDescriptionRef)formatDescription withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput;
@end


#import "FXDsuperManager.h"

@interface FXDsuperGPUManager : FXDsuperManager
@property (nonatomic) NSInteger lastFilterIndex;

@property (strong, nonatomic) NSMutableArray *cycledFilterNameArray;

@property (strong, nonatomic) FXDcameraGPU *gpuvideoCamera;
@property (strong, nonatomic) FXDfiltergroupGPU *gpufilterGroup;


#pragma mark - Public
- (void)prepareGPUManager;
- (void)resetGPUManager;

- (void)cycleGPUfiltersForward:(BOOL)isForward withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex;


//MARK: - Observer implementation
- (void)observedAVCaptureDeviceWasConnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceWasDisconnected:(NSNotification*)notification;
- (void)observedAVCaptureDeviceSubjectAreaDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
