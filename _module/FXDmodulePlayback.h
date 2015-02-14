

#import "FXDimportCore.h"


#ifndef periodicintervalDivisor
	#define periodicintervalDivisor	3
#endif

#ifndef periodicintervalDefault
	#define periodicintervalDefault	CMTimeMultiplyByRatio(CMTimeMake(1, 3), 1, periodicintervalDivisor)
#endif


@import AVFoundation;

@interface FXDdisplayPlayback : FXDView
@property (strong, nonatomic) AVPlayer *mainPlayer;

+ (instancetype)assetDisplay;
- (CGRect)centeredDisplayFrameForForcedSize:(CGSize)forcedSize withPresentationSize:(CGSize)presentationSize;

@end


@interface FXDmodulePlayback : FXDsuperModule {
	FXDdisplayPlayback *_mainDisplay;
}

@property (nonatomic) CMTime playbackCurrentTime;
@property (nonatomic) Float64 playbackProgress;

@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) FXDdisplayPlayback *mainDisplay;


- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withCallback:(FXDcallbackFinish)callback;


- (void)startSeekingToPlaybackProgress:(Float64)playbackProgress withCallback:(FXDcallbackFinish)finishCallback;
- (void)startSeekingToTime:(CMTime)seekedTime withCallback:(FXDcallbackFinish)finishCallback;

- (void)resumeMoviePlayerWithCallback:(FXDcallbackFinish)finishCallback;
- (void)pauseAndRemovePeriodicObserver;

@end
