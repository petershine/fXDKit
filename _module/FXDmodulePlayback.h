
@import AVFoundation;

#import "FXDKit.h"


#ifndef periodicintervalDivisor
	#define periodicintervalDivisor	3
#endif

#ifndef periodicintervalDefault
	#define periodicintervalDefault	CMTimeMultiplyByRatio(CMTimeMake(1, 3), 1, periodicintervalDivisor)
#endif


@interface FXDdisplayPlayback : FXDView

@property (strong, nonatomic) AVPlayer *mainPlayer;

+ (instancetype)assetDisplay;
- (CGRect)centeredDisplayFrameForForcedSize:(CGSize)forcedSize;

@end


@interface FXDmodulePlayback : FXDsuperModule {
	FXDdisplayPlayback *_mainPlaybackDisplay;
}

@property (nonatomic) CMTime playbackCurrentTime;
@property (nonatomic) CMTime lastSeekedTime;

@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) FXDdisplayPlayback *mainPlaybackDisplay;


- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withCallback:(FXDcallbackFinish)callback;


- (void)startSeekingToTrackProgress:(Float64)trackProgress withCallback:(FXDcallbackFinish)finishCallback;
- (void)startSeekingToTime:(CMTime)seekedTime withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)resumeMoviePlayerWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)pauseAndRemovePeriodicObserver;

@end
