//
//  FXDsuperPlaybackManager.h
//
//
//  Created by petershine on 2/3/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef periodicintervalDefault
	#define periodicintervalDefault	CMTimeMake(1.0, doubleOneBillion)
#endif


@import AssetsLibrary;


@interface FXDviewVideoDisplay : FXDView
@property (strong, nonatomic) AVPlayer *mainPlayer;
@end


@interface FXDsuperPlaybackManager : FXDsuperManager
@property (nonatomic) BOOL didStartSeeking;

@property (nonatomic) CMTime playbackProgressTime;

@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) FXDviewVideoDisplay *mainPlaybackDisplay;


#pragma mark - Public
- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withScene:(UIViewController*)scene withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)configurePlaybackObservers;

- (void)startSeekingToProgressTime:(CMTime)progressTime withFinishCallback:(FXDcallbackFinish)finishCallback;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
