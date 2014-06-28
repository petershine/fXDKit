//
//  FXDsuperPlaybackManager.h
//
//
//  Created by petershine on 2/3/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

//MARK: Make sure it's not bad for performance
#ifndef periodicintervalDivisor
	#define periodicintervalDivisor	3
#endif

#ifndef periodicintervalDefault
	#define periodicintervalDefault	CMTimeMultiplyByRatio(CMTimeMake(1, 3), 1, periodicintervalDivisor)
#endif


@import AVFoundation;


@interface FXDviewAssetDisplay : FXDView
@property (strong, nonatomic) AVPlayer *mainPlayer;
+ (instancetype)assetDisplay;

- (void)centerAlignForPresentationSize:(CGSize)presentationSize forDisplaySize:(CGSize)displaySize forDuration:(NSTimeInterval)duration;
@end


@interface FXDsuperPlaybackManager : FXDsuperManager
@property (nonatomic) CMTime playbackCurrentTime;
@property (nonatomic) CMTime lastSeekedTime;

@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) id playerItemObserver;

@property (strong, nonatomic) FXDviewAssetDisplay *mainPlaybackDisplay;


#pragma mark - Public
- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)configurePlaybackObservers;

- (void)startSeekingToProgressPercentage:(Float64)progressPercentage withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)startSeekingToTime:(CMTime)seekedTime withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)resumeMoviePlayerWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)pauseRemovingPeriodicObserver;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
