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

@interface FXDwriterGPU : GPUImageMovieWriter
@property (nonatomic) BOOL didStartFinishing;
@property (nonatomic) CMTime startTime;
@end

@interface FXDimageviewGPU : GPUImageView
@end


@interface FXDsuperGPUManager : FXDsuperManager <GPUImageVideoCameraDelegate, GPUImageMovieWriterDelegate>
@property (nonatomic) NSInteger lastFilterIndex;

@property (strong, nonatomic) NSMutableArray *cycledFilterNameArray;

@property (strong, nonatomic) FXDcameraGPU *gpuvideoCamera;
@property (strong, nonatomic) FXDfiltergroupGPU *gpufilterGroup;
@property (strong, nonatomic) FXDwriterGPU *gpumovieWriter;

@property (strong, nonatomic) FXDimageviewGPU *gpuviewCaptured;


#pragma mark - Public
- (void)prepareGPUManagerWithFlashMode:(AVCaptureFlashMode)flashMode;
- (void)resetGPUManager;

- (void)prepareMovieWriterWithFormatDescription:(CMFormatDescriptionRef)formatDescription withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput;

- (void)cycleGPUfiltersForward:(BOOL)isForward;
- (void)applyGPUfilterAtFilterIndex:(NSInteger)filterIndex;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
