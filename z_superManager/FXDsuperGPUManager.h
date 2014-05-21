//
//  FXDsuperGPUManager.h
//
//
//  Created by petershine on 5/21/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

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


#import "FXDsuperCaptureManager.h"

@interface FXDsuperGPUManager : FXDsuperCaptureManager <GPUImageVideoCameraDelegate, GPUImageMovieWriterDelegate> {
	BOOL _shouldUseGPUpreview;
}

@property (nonatomic) BOOL shouldUseGPUpreview;

@property (strong, nonatomic) NSMutableArray *cycledFilterNameArray;

@property (strong, nonatomic) FXDcameraGPU *gpuvideoCamera;
@property (strong, nonatomic) FXDfiltergroupGPU *gpufilterGroup;
@property (strong, nonatomic) FXDwriterGPU *gpumovieWriter;

@property (strong, nonatomic) FXDimageviewGPU *gpuviewCaptured;


#pragma mark - Public
- (void)prepareMovieWriterWithFormatDescription:(CMFormatDescriptionRef)formatDescription withFileURL:(NSURL*)fileURL withGPUImageOutput:(GPUImageOutput*)gpuimageOutput;

- (void)cycleGPUfilters;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
