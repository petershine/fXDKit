
@import AVFoundation;

#import "FXDKit.h"


#ifndef periodicintervalDivisor
	#define periodicintervalDivisor	3
#endif

#ifndef periodicintervalDefault
	#define periodicintervalDefault	CMTimeMultiplyByRatio(CMTimeMake(1, 3), 1, periodicintervalDivisor)
#endif


@interface FXDsubviewAssetDisplay : FXDView
@property (strong, nonatomic) AVPlayer *mainPlayer;
+ (instancetype)assetDisplay;

- (void)centerAlignForPresentationSize:(CGSize)presentationSize forDisplaySize:(CGSize)displaySize forDuration:(NSTimeInterval)duration;
@end


@interface FXDmodulePlayback : FXDsuperModule {
	FXDsubviewAssetDisplay *_mainPlaybackDisplay;
}

@property (nonatomic) CMTime playbackCurrentTime;
@property (nonatomic) CMTime lastSeekedTime;

@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) id playerItemObserver;

@property (strong, nonatomic) FXDsubviewAssetDisplay *mainPlaybackDisplay;


- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withCallback:(FXDcallbackFinish)callback;

- (void)configurePlaybackObservers;

- (void)startSeekingToProgressPercentage:(Float64)progressPercentage withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)startSeekingToTime:(CMTime)seekedTime withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)resumeMoviePlayerWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)pauseRemovingPeriodicObserver;

@end
