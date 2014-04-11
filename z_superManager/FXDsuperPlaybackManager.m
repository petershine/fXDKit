//
//  FXDsuperPlaybackManager.m
//
//
//  Created by petershine on 2/3/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperPlaybackManager.h"


@implementation FXDviewVideoDisplay
+ (Class)layerClass {
	return [AVPlayerLayer class];
}

#pragma mark -
- (AVPlayer*)mainPlayer {
	return [(AVPlayerLayer*)[self layer] player];
}

- (void)setMainPlayer:(AVPlayer*)mainMoviePlayer {
	[(AVPlayerLayer*)[self layer] setPlayer:mainMoviePlayer];
}
@end


#pragma mark - Public implementation
@implementation FXDsuperPlaybackManager


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[_mainPlaybackDisplay setMainPlayer:nil];
	[_mainPlaybackDisplay removeFromSuperview];

	[_videoPlayer pause];

	[_videoPlayer removeTimeObserver:_periodicObserver];
	_periodicObserver = nil;
}


#pragma mark - Initialization

#pragma mark - Property overriding
- (FXDviewVideoDisplay*)mainPlaybackDisplay {
	if (_mainPlaybackDisplay) {
		return _mainPlaybackDisplay;
	}


	FXDLog_DEFAULT;

	CGRect screenBounds = [[UIDevice currentDevice] screenBoundsForOrientation];

	_mainPlaybackDisplay = [[FXDviewVideoDisplay alloc] initWithFrame:screenBounds];
	_mainPlaybackDisplay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

	AVPlayerLayer *displayLayer = (AVPlayerLayer*)_mainPlaybackDisplay.layer;

	displayLayer.videoGravity = AVLayerVideoGravityResizeAspect;

	return _mainPlaybackDisplay;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withScene:(UIViewController*)scene withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	AVURLAsset *movieAsset = [AVURLAsset
							  URLAssetWithURL:movieFileURL
							  options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)}];

	NSString *tracksKey = @"tracks";


	__weak NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
	FXDLog_IsCurrentQueueMain;

	[movieAsset
	 loadValuesAsynchronouslyForKeys:@[tracksKey]
	 completionHandler:^{
		 FXDLog_BLOCK(movieAsset, @selector(loadValuesAsynchronouslyForKeys:completionHandler:));
		 FXDLogBOOL(movieAsset.isPlayable);

		 [currentQueue
		  addOperationWithBlock:^{
			  
			  NSError *error = nil;
			  AVKeyValueStatus valueStatus = [movieAsset statusOfValueForKey:tracksKey error:&error];
			  FXDLog_ERROR;
			  FXDLogVariable(valueStatus);

			  if (valueStatus != AVKeyValueStatusLoaded) {
				  if (finishCallback) {
					  finishCallback(_cmd, NO, nil);
				  }
				  return;
			  }


			  AVPlayerItem *videoItem = [AVPlayerItem playerItemWithAsset:movieAsset];

			  self.videoPlayer = [AVPlayer playerWithPlayerItem:videoItem];

			  [self.mainPlaybackDisplay setMainPlayer:self.videoPlayer];


			  [scene.view addSubview:self.mainPlaybackDisplay];
			  [scene.view sendSubviewToBack:self.mainPlaybackDisplay];


			  [self
			   startSeekingToProgressTime:kCMTimeZero
			   withFinishCallback:^(SEL caller, BOOL finished, id responseObj) {

				   [self configurePlaybackObservers];

				   if (finishCallback) {
					   finishCallback(_cmd, YES, nil);
				   }
			   }];
		  }];
	 }];
}

- (void)configurePlaybackObservers {	FXDLog_DEFAULT;
	
	__weak typeof(self) weakSelf = self;

	//MARK: Probably this would make processing slower, enlarge the interval
	FXDLogTime(periodicintervalDefault);

	weakSelf.periodicObserver =
	[weakSelf.videoPlayer
	 addPeriodicTimeObserverForInterval:periodicintervalDefault
	 queue:NULL
	 usingBlock:^(CMTime time) {

		 if (weakSelf.didStartSeeking || weakSelf.videoPlayer.rate <= 0.0) {
			 return;
		 }


		 weakSelf.playbackProgressTime = time;
	 }];
}


#pragma mark -
- (void)startSeekingToProgressTime:(CMTime)progressTime withFinishCallback:(FXDcallbackFinish)finishCallback {

	__weak typeof(self) weakSelf = self;

	if (weakSelf.didStartSeeking) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	weakSelf.didStartSeeking = YES;


	__weak NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
	FXDLog_IsCurrentQueueMain;

	[weakSelf.videoPlayer
	 seekToTime:progressTime
	 completionHandler:^(BOOL finished) {

		 weakSelf.didStartSeeking = NO;

		 [currentQueue
		  addOperationWithBlock:^{
			  if (finishCallback) {
				  finishCallback(_cmd, finished, nil);
			  }
		  }];
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
