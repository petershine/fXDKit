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
	FXDAssert_IsMainThread;

	[_mainPlaybackDisplay setMainPlayer:nil];
	[_mainPlaybackDisplay removeFromSuperview];

	[_moviePlayer pause];

	[_moviePlayer removeTimeObserver:_periodicObserver];
	_periodicObserver = nil;

	[[NSNotificationCenter defaultCenter] removeObserver:_playerItemObserver];
	 _playerItemObserver = nil;
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


			  AVPlayerItem *movieItem = [AVPlayerItem playerItemWithAsset:movieAsset];

			  self.moviePlayer = [AVPlayer playerWithPlayerItem:movieItem];

			  [self.mainPlaybackDisplay setMainPlayer:self.moviePlayer];

			  [scene.view addSubview:self.mainPlaybackDisplay];
			  [scene.view sendSubviewToBack:self.mainPlaybackDisplay];

			  [self.mainPlaybackDisplay setFrame:self.mainPlaybackDisplay.superview.bounds];


			  __weak typeof(self) weakSelf = self;

			  [weakSelf
			   startSeekingToProgressPercentage:0.0
			   withFinishCallback:^(SEL caller, BOOL finished, id responseObj) {
				   FXDLog_BLOCK(weakSelf, caller);

				   [weakSelf configurePlaybackObservers];

				   if (finishCallback) {
					   finishCallback(_cmd, YES, nil);
				   }
			   }];
		  }];
	 }];
}

#pragma mark -
- (void)configurePlaybackObservers {	FXDLog_DEFAULT;
	
	__weak typeof(self) weakSelf = self;

	FXDLogTime(periodicintervalDefault);

	weakSelf.periodicObserver =
	[weakSelf.moviePlayer
	 addPeriodicTimeObserverForInterval:periodicintervalDefault
	 queue:NULL
	 usingBlock:^(CMTime time) {

		 if (weakSelf.moviePlayer.rate <= 0.0) {
			 return;
		 }


		 weakSelf.playbackProgressTime = time;
	 }];

	weakSelf.playerItemObserver =
	[[NSNotificationCenter defaultCenter]
	 addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
	 object:nil
	 queue:nil
	 usingBlock:^(NSNotification *note) {
		 FXDLog_BLOCK(weakSelf, _cmd);

#if ForDEVELOPER
		 CMTime currentTime = [weakSelf.moviePlayer.currentItem currentTime];
		 CMTime duration = weakSelf.moviePlayer.currentItem.duration;
		 FXDLog(@"%@ %@ %@", _Time(currentTime), _Time(duration), _Time(weakSelf.playbackProgressTime));
#endif

		 weakSelf.playbackProgressTime = [weakSelf.moviePlayer.currentItem currentTime];
	 }];
}

#pragma mark -
- (void)startSeekingToProgressPercentage:(Float64)progressPercentage withFinishCallback:(FXDcallbackFinish)finishCallback {

	CMTime seekedTime = kCMTimeZero;

	if (progressPercentage > 0.0) {
		//MARK: Be careful not to divide it by zero
		seekedTime = CMTimeMultiplyByFloat64(self.moviePlayer.currentItem.duration, progressPercentage);
	}

	if (progressPercentage == 0.0) {
		FXDLog(@"%@ %@ %@", _Variable(progressPercentage), _Time(seekedTime), _Time(self.moviePlayer.currentItem.duration));
	}

	[self startSeekingToTime:seekedTime withFinishCallback:finishCallback];
}

- (void)startSeekingToTime:(CMTime)seekedTime withFinishCallback:(FXDcallbackFinish)finishCallback {

	if (self.moviePlayer.status != AVPlayerStatusReadyToPlay
		&& self.moviePlayer.currentItem.status != AVPlayerItemStatusReadyToPlay) {
		FXDLog_DEFAULT;
		FXDLog(@"%@ %@", _Variable(self.moviePlayer.status), _Variable(self.moviePlayer.currentItem.status));

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	CMTime currentTime = [self.moviePlayer.currentItem currentTime];
	//FXDLog(@"%@ %@ %@", _Time(seekedTime), _Time(currentTime), _Variable(CMTimeCompare(currentTime, seekedTime)));

	if (CMTimeCompare(currentTime, seekedTime) == NSOrderedSame) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}

	if (CMTimeCompare(self.lastSeekedTime, seekedTime) == NSOrderedSame) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	self.lastSeekedTime = seekedTime;

	[self.moviePlayer
	 seekToTime:seekedTime
	 completionHandler:^(BOOL finished) {
		 //FXDLog(@"%@", _Time([weakSelf.moviePlayer.currentItem currentTime]));

		 if (finishCallback) {
			 finishCallback(_cmd, finished, nil);
		 }
	 }];
}

#pragma mark -
- (void)resumeMoviePlayerWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	__weak typeof(self) weakSelf = self;

	CMTime currentTime = [weakSelf.moviePlayer.currentItem currentTime];
	CMTime duration = weakSelf.moviePlayer.currentItem.duration;
	FXDLog(@"%@ %@", _Time(currentTime), _Time(duration));

	if (CMTimeCompare(currentTime, duration) == NSOrderedAscending) {
		[weakSelf.moviePlayer play];

		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
		return;
	}


	[weakSelf
	 startSeekingToTime:kCMTimeZero
	 withFinishCallback:^(SEL caller, BOOL finished, id responseObj) {
		 [weakSelf.moviePlayer play];

		 if (finishCallback) {
			 finishCallback(_cmd, finished, responseObj);
		 }
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
