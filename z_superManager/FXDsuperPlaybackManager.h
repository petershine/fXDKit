//
//  FXDsuperPlaybackManager.h
//
//
//  Created by petershine on 2/3/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef periodicintervalDefault
	#warning //MARK: Make sure it's not bad for performance
	#define periodicintervalDefault	CMTimeMake(1.0, doubleOneBillion)
#endif


@import AssetsLibrary;


@interface FXDviewVideoDisplay : FXDView
@property (strong, nonatomic) AVPlayer *mainPlayer;
@end


@interface FXDsuperPlaybackManager : FXDsuperManager
@property (nonatomic) CMTime lastSeekedTime;
@property (nonatomic) CMTime playbackProgressTime;

@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) FXDviewVideoDisplay *mainPlaybackDisplay;


#pragma mark - Public
- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withScene:(UIViewController*)scene withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)configurePlaybackObservers;
- (void)startSeekingToTime:(CMTime)seekedTime withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)resumeMoviePlayerWithFinishCallback:(FXDcallbackFinish)finishCallback;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
