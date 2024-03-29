

#import "FXDmodulePlayback.h"


@implementation FXDdisplayPlayback
+ (Class)layerClass {
	return [AVPlayerLayer class];
}

+ (instancetype)assetDisplay {	FXDLog_DEFAULT
	UIDeviceOrientation deviceOrientation = (UIDeviceOrientation)[[UIDevice currentDevice] orientation];
	CGRect screenBounds = [UIScreen screenBoundsForOrientation:deviceOrientation];

	FXDdisplayPlayback *assetDisplay = [[[self class] alloc] initWithFrame:screenBounds];

	AVPlayerLayer *displayLayer = (AVPlayerLayer*)assetDisplay.layer;
	displayLayer.videoGravity = AVLayerVideoGravityResizeAspect;

	return assetDisplay;
}

#pragma mark -
- (AVPlayer*)mainPlayer {
	return ((AVPlayerLayer*)self.layer).player;
}

- (void)setMainPlayer:(AVPlayer*)mainMoviePlayer {
	((AVPlayerLayer*)self.layer).player = mainMoviePlayer;
}

#pragma mark -
- (CGRect)centeredDisplayFrameForForcedSize:(CGSize)forcedSize withPresentationSize:(CGSize)presentationSize {	FXDLog_DEFAULT
	FXDLog(@"%@ %@", _Size(forcedSize), _Size(presentationSize));

	if (CGSizeEqualToSize(presentationSize, CGSizeZero)) {
		presentationSize = self.mainPlayer.currentItem.presentationSize;

		if (CGSizeEqualToSize(presentationSize, CGSizeZero)) {
			presentationSize = forcedSize;
		}
	}


	CGFloat forcedAspect = MAX(forcedSize.width, forcedSize.height)/MIN(forcedSize.width, forcedSize.height);
	FXDLogVariable(forcedAspect);

	CGFloat presentationAspect = MAX(presentationSize.width, presentationSize.height)/MIN(presentationSize.width, presentationSize.height);
	FXDLogVariable(presentationAspect);

	CGFloat displayAspect = MAX(forcedAspect, presentationAspect);
	FXDLogVariable(displayAspect);


	CGRect displayFrame = CGRectMake(0, 0, forcedSize.width, forcedSize.height);

	AVPlayerLayer *displayLayer = (AVPlayerLayer*)self.layer;

	if (forcedSize.width < forcedSize.height) {
		displayFrame.size.width = forcedSize.width;

		if (presentationSize.width < presentationSize.height) {
			displayFrame.size.height = displayFrame.size.width*displayAspect;

			displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		}
		else {
			displayFrame.size.height = displayFrame.size.width/displayAspect;

			displayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
		}
	}
	else {
		displayFrame.size.height = forcedSize.height;

		if (presentationSize.width < presentationSize.height) {
			displayFrame.size.width = displayFrame.size.height/displayAspect;

			displayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
		}
		else {
			displayFrame.size.width = displayFrame.size.height*displayAspect;

			displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
		}
	}

	FXDLog(@"1.%@", _Rect(displayFrame));

	displayFrame.origin.x = (forcedSize.width -displayFrame.size.width)/2.0;
	displayFrame.origin.y = (forcedSize.height -displayFrame.size.height)/2.0;

	FXDLog(@"2.%@", _Rect(displayFrame));
	FXDLogObject(displayLayer.videoGravity);

	FXDLogBOOL(self.layer.needsDisplay);
	[self.layer displayIfNeeded];


	return displayFrame;
}
@end


@implementation FXDmodulePlayback

#pragma mark - Memory management
- (void)dealloc {
	[_mainDisplay setMainPlayer:nil];
	[_mainDisplay removeFromSuperview];

	[_moviePlayer.currentItem cancelPendingSeeks];
	[_moviePlayer cancelPendingPrerolls];
	[_moviePlayer pause];

	[_moviePlayer removeTimeObserver:_periodicObserver];
	_periodicObserver = nil;
}

#pragma mark - Initialization

#pragma mark - Property overriding
- (FXDdisplayPlayback*)mainDisplay {
	if (_mainDisplay == nil) {	FXDLog_DEFAULT
		_mainDisplay = [FXDdisplayPlayback assetDisplay];
	}
	return _mainDisplay;
}

#pragma mark - Method overriding

#pragma mark - Public
- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT

	__weak FXDmodulePlayback *weakSelf = self;

	AVURLAsset *movieAsset = [[AVURLAsset alloc] initWithURL:movieFileURL
													 options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)}];
	FXDLogObject(movieAsset);

	[movieAsset
	 loadValuesAsynchronouslyForKeys:@[@"duration"]
	 completionHandler:^{
		 FXDLog_BLOCK(movieAsset, @selector(loadValuesAsynchronouslyForKeys:completionHandler:));

		 NSError *error = nil;
		 AVKeyValueStatus valueStatus = [movieAsset
										 statusOfValueForKey:@"duration"
										 error:&error];FXDLog_ERROR;
		 FXDLogVariable(valueStatus);
		 if (valueStatus) {}
		 
		 FXDLogTime(movieAsset.duration);
		 
		 FXDLogBOOL(movieAsset.hasProtectedContent);
		 FXDLog(@"%@ %@ %@ %@", _BOOL(movieAsset.isPlayable), _BOOL(movieAsset.isExportable), _BOOL(movieAsset.isReadable), _BOOL(movieAsset.isComposable));

		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{

			  NSError *error = nil;
			  AVKeyValueStatus valueStatus = [movieAsset statusOfValueForKey:@"tracks" error:&error];
			  FXDLog_ERROR;
			  FXDLogVariable(valueStatus);

			  if (valueStatus != AVKeyValueStatusLoaded) {
				  if (callback) {
					  callback(_cmd, NO, nil);
				  }
				  return;
			  }


			  __strong FXDmodulePlayback *strongSelf = weakSelf;

			  if (strongSelf == nil) {
				  if (callback) {
					  callback(_cmd, NO, nil);
				  }
				  return;
			  }


			  AVPlayerItem *movieItem = [AVPlayerItem playerItemWithAsset:movieAsset];

			  strongSelf.moviePlayer = [AVPlayer playerWithPlayerItem:movieItem];
			  (strongSelf.mainDisplay).mainPlayer = strongSelf.moviePlayer;

			  [strongSelf startSeekingToTime:kCMTimeZero withCallback:nil];

			  if (callback) {
				  callback(_cmd, YES, nil);
			  }
		  }];
	 }];
}

#pragma mark -
- (void)startSeekingToPlaybackProgress:(Float64)playbackProgress withCallback:(FXDcallbackFinish)finishCallback {

	if (playbackProgress < 0.0 || isnan(playbackProgress)) {
		playbackProgress = 0.0;
	}


	__weak FXDmodulePlayback *weakSelf = self;

	CMTime seekedTime = kCMTimeZero;

	//MARK: Be careful about validity of time
	if (CMTimeCompare(weakSelf.moviePlayer.currentItem.duration, kCMTimeIndefinite) != NSOrderedSame
		&& playbackProgress > 0.0) {
		seekedTime = CMTimeMultiplyByFloat64(weakSelf.moviePlayer.currentItem.duration, playbackProgress);
	}

	[weakSelf
	 startSeekingToTime:seekedTime
	 withCallback:^(SEL caller, BOOL didFinish, id responseObj) {

		 weakSelf.playbackProgress = playbackProgress;

		 if (finishCallback) {
			 finishCallback(_cmd, didFinish, responseObj);
		 }
	 }];
}

- (void)startSeekingToTime:(CMTime)seekedTime withCallback:(FXDcallbackFinish)finishCallback {

	if (CMTIME_IS_VALID(seekedTime) == NO) {	FXDLog_DEFAULT
		FXDLogBOOL(CMTIME_IS_VALID(seekedTime));

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	//MARK: Make sure loading is completed for correct preview updating
	if (self.moviePlayer.status != AVPlayerStatusReadyToPlay
		&& self.moviePlayer.currentItem.status != AVPlayerItemStatusReadyToPlay) {	FXDLog_DEFAULT
		FXDLog(@"%@ %@", _Variable(self.moviePlayer.status), _Variable(self.moviePlayer.currentItem.status));

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	[self.moviePlayer.currentItem cancelPendingSeeks];

	__weak FXDmodulePlayback *weakSelf = self;

	[weakSelf.moviePlayer.currentItem
	 seekToTime:seekedTime
	 toleranceBefore:kCMTimeZero
	 toleranceAfter:kCMTimeZero
	 completionHandler:^(BOOL didFinish) {

		 weakSelf.playbackCurrentTime = [weakSelf.moviePlayer.currentItem currentTime];

		 if (finishCallback) {
			 finishCallback(_cmd, didFinish, weakSelf.moviePlayer.currentItem);
		 }
	 }];
}

#pragma mark -
- (void)resumeMoviePlayerWithCallback:(FXDcallbackFinish)callback {	FXDLog_DEFAULT

	__weak FXDmodulePlayback *weakSelf = self;

	FXDcallbackFinish ResumingMoviePlayer = ^(SEL caller, BOOL didFinish, id responseObj){
		FXDLogTime(periodicintervalDefault);

		weakSelf.playbackCurrentTime = [weakSelf.moviePlayer.currentItem currentTime];

		if (weakSelf.periodicObserver == nil) {
			weakSelf.periodicObserver =
			[weakSelf.moviePlayer
			 addPeriodicTimeObserverForInterval:periodicintervalDefault
			 queue:NULL
			 usingBlock:^(CMTime time) {

				 weakSelf.playbackCurrentTime = [weakSelf.moviePlayer.currentItem currentTime];
			 }];
		}

		[weakSelf.moviePlayer play];

		if (callback) {
			callback(caller, didFinish, responseObj);
		}
	};


	CMTime currentTime = [weakSelf.moviePlayer.currentItem currentTime];
	CMTime duration = weakSelf.moviePlayer.currentItem.duration;
	FXDLog(@"%@ %@", _Time(currentTime), _Time(duration));

	if (CMTimeCompare(currentTime, duration) == NSOrderedAscending) {
		ResumingMoviePlayer(_cmd, YES, nil);
		return;
	}


	[weakSelf
	 startSeekingToTime:kCMTimeZero
	 withCallback:^(SEL caller, BOOL didFinish, id responseObj) {
		 ResumingMoviePlayer(_cmd, didFinish, responseObj);
	 }];
}

- (void)pauseAndRemovePeriodicObserver {	//FXDLog_DEFAULT
	[self.moviePlayer pause];
	self.moviePlayer.volume = 1.0;
	
	__weak FXDmodulePlayback *weakSelf = self;

	if (weakSelf.periodicObserver) {
		[weakSelf.moviePlayer removeTimeObserver:weakSelf.periodicObserver];
		weakSelf.periodicObserver = nil;
	}
}

@end
