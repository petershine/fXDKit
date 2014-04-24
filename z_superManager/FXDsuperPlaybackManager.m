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

#pragma mark -
- (void)centerAlignForPresentationSize:(CGSize)presentationSize {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Object(self.superview), _Size(presentationSize));

	if (CGSizeEqualToSize(presentationSize, CGSizeZero)) {
		presentationSize = [self mainPlayer].currentItem.presentationSize;
	}

	if (self.superview == nil
		|| (CGSizeEqualToSize(presentationSize, CGSizeZero))) {
		return;
	}


	CGRect displayFrame = self.superview.bounds;
	CGFloat aspectRatio = MAX(self.superview.bounds.size.width, self.superview.bounds.size.height)/MIN(self.superview.bounds.size.width, self.superview.bounds.size.height);

	FXDLog(@"1.%@ %@", _Rect(displayFrame), _Variable(aspectRatio));

	if (presentationSize.width < presentationSize.height) {
		displayFrame.size.height = self.superview.bounds.size.height;

		displayFrame.size.width = displayFrame.size.height/aspectRatio;
	}
	else {
		displayFrame.size.width = self.superview.bounds.size.width;

		displayFrame.size.height = displayFrame.size.width/aspectRatio;
	}

	FXDLog(@"2.%@", _Rect(displayFrame));


	displayFrame.origin.x = (self.superview.bounds.size.width -displayFrame.size.width)/2.0;
	displayFrame.origin.y = (self.superview.bounds.size.height -displayFrame.size.height)/2.0;
	FXDLog(@"3.%@", _Rect(displayFrame));

	
	self.frame = displayFrame;
}
@end


#pragma mark - Public implementation
@implementation FXDsuperPlaybackManager


#pragma mark - Memory management
- (void)dealloc {
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

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	_mainPlaybackDisplay = [[FXDviewVideoDisplay alloc] initWithFrame:screenBounds];

	//TEST:
	//_mainPlaybackDisplay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

	AVPlayerLayer *displayLayer = (AVPlayerLayer*)_mainPlaybackDisplay.layer;

	//TEST:
	//displayLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

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
	FXDLog_IsMainThread;

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
		 FXDLog_BLOCK([NSNotificationCenter defaultCenter], @selector(addObserverForName:object:queue:usingBlock:));

#if ForDEVELOPER
		 CMTime currentTime = [weakSelf.moviePlayer.currentItem currentTime];
		 CMTime duration = weakSelf.moviePlayer.currentItem.duration;
		 FXDLog(@"%@ %@ %@", _Time(currentTime), _Time(duration), _Time(weakSelf.playbackProgressTime));
#endif
		 weakSelf.playbackProgressTime = [weakSelf.moviePlayer.currentItem currentTime];
	 }];


	@weakify(self);
	[RACObserve(self, moviePlayer.currentItem.presentationSize)
	 subscribeNext:^(id presentationSize) {	@strongify(self);
		 FXDLog_REACT(self.moviePlayer.currentItem.presentationSize, presentationSize);

		 [self.mainPlaybackDisplay centerAlignForPresentationSize:[presentationSize CGSizeValue]];
	 }];
}

#pragma mark -
- (void)startSeekingToProgressPercentage:(Float64)progressPercentage withFinishCallback:(FXDcallbackFinish)finishCallback {

	CMTime seekedTime = kCMTimeZero;

	//MARK: Be careful about validity of time
	if (CMTimeCompare(self.moviePlayer.currentItem.duration, kCMTimeIndefinite) != NSOrderedSame
		&& progressPercentage > 0.0) {
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
