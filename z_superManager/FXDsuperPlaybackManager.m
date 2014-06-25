//
//  FXDsuperPlaybackManager.m
//
//
//  Created by petershine on 2/3/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#import "FXDsuperPlaybackManager.h"


@implementation FXDviewAssetDisplay
+ (Class)layerClass {
	return [AVPlayerLayer class];
}

+ (instancetype)assetDisplay {	FXDLog_DEFAULT;

	CGRect screenBounds = [UIScreen screenBoundsForOrientation:[UIDevice currentDevice].orientation];

	FXDviewAssetDisplay *assetDisplay = [[[self class] alloc] initWithFrame:screenBounds];

	AVPlayerLayer *displayLayer = (AVPlayerLayer*)assetDisplay.layer;
	displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

	return assetDisplay;
}

#pragma mark -
- (AVPlayer*)mainPlayer {
	return [(AVPlayerLayer*)[self layer] player];
}

- (void)setMainPlayer:(AVPlayer*)mainMoviePlayer {
	[(AVPlayerLayer*)[self layer] setPlayer:mainMoviePlayer];
}

#pragma mark -
- (void)centerAlignForPresentationSize:(CGSize)presentationSize  forDisplaySize:(CGSize)displaySize forDuration:(NSTimeInterval)duration {

	if (CGSizeEqualToSize(presentationSize, CGSizeZero)) {
		presentationSize = [self mainPlayer].currentItem.presentationSize;
	}

	if (self.superview == nil
		|| (CGSizeEqualToSize(presentationSize, CGSizeZero))) {
		return;
	}


	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Object(self.superview), _Size(presentationSize));

	if (CGSizeEqualToSize(displaySize, CGSizeZero)) {
		displaySize = self.superview.bounds.size;
	}


	CGRect displayFrame = CGRectMake(0, 0, displaySize.width, displaySize.height);
	CGFloat aspectRatio = MAX(displaySize.width, displaySize.height)/MIN(displaySize.width, displaySize.height);

	FXDLog(@"1.%@ %@", _Rect(displayFrame), _Variable(aspectRatio));

	if (presentationSize.width < presentationSize.height) {
		displayFrame.size.height = displaySize.height;

		displayFrame.size.width = displayFrame.size.height/aspectRatio;
	}
	else {
		displayFrame.size.width = displaySize.width;

		displayFrame.size.height = displayFrame.size.width/aspectRatio;
	}

	FXDLog(@"2.%@", _Rect(displayFrame));


	displayFrame.origin.x = (displaySize.width -displayFrame.size.width)/2.0;
	displayFrame.origin.y = (displaySize.height -displayFrame.size.height)/2.0;
	FXDLog(@"3.%@", _Rect(displayFrame));


	[UIView
	 animateWithDuration:duration
	 animations:^{
		 self.frame = displayFrame;
	 }];
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
- (FXDviewAssetDisplay*)mainPlaybackDisplay {
	if (_mainPlaybackDisplay) {
		return _mainPlaybackDisplay;
	}


	FXDLog_DEFAULT;

	_mainPlaybackDisplay = [FXDviewAssetDisplay assetDisplay];

	return _mainPlaybackDisplay;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)preparePlaybackManagerWithMovieFileURL:(NSURL*)movieFileURL withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	AVURLAsset *movieAsset = [AVURLAsset
							  URLAssetWithURL:movieFileURL
							  options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @(YES)}];

	NSString *tracksKey = @"tracks";


	[movieAsset
	 loadValuesAsynchronouslyForKeys:@[tracksKey]
	 completionHandler:^{
		 FXDLog_BLOCK(movieAsset, @selector(loadValuesAsynchronouslyForKeys:completionHandler:));
		 FXDLogBOOL(movieAsset.isPlayable);

		 [[NSOperationQueue mainQueue]
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
			  

			  __weak FXDsuperPlaybackManager *weakSelf = self;

			  [weakSelf configurePlaybackObservers];

			  [weakSelf startSeekingToTime:kCMTimeZero withFinishCallback:nil];

			  if (finishCallback) {
				  finishCallback(_cmd, YES, nil);
			  }
		  }];
	 }];
}

#pragma mark -
- (void)configurePlaybackObservers {	FXDLog_DEFAULT;
	
	__weak FXDsuperPlaybackManager *weakSelf = self;

	weakSelf.playerItemObserver =
	[[NSNotificationCenter defaultCenter]
	 addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
	 object:nil
	 queue:nil
	 usingBlock:^(NSNotification *note) {
		 FXDLogObject(note);
		 FXDLogTime(weakSelf.moviePlayer.currentItem.duration);

		 weakSelf.playbackCurrentTime = [weakSelf.moviePlayer.currentItem currentTime];
	 }];
}

#pragma mark -
- (void)startSeekingToProgressPercentage:(Float64)progressPercentage withFinishCallback:(FXDcallbackFinish)finishCallback {

	__weak FXDsuperPlaybackManager *weakSelf = self;

	CMTime seekedTime = kCMTimeZero;

	//MARK: Be careful about validity of time
	if (CMTimeCompare(weakSelf.moviePlayer.currentItem.duration, kCMTimeIndefinite) != NSOrderedSame
		&& progressPercentage > 0.0) {
		seekedTime = CMTimeMultiplyByFloat64(self.moviePlayer.currentItem.duration, progressPercentage);
	}

	if (progressPercentage == 0.0) {
		FXDLog(@"%@ %@ %@", _Variable(progressPercentage), _Time(seekedTime), _Time(weakSelf.moviePlayer.currentItem.duration));
	}

	[weakSelf startSeekingToTime:seekedTime withFinishCallback:finishCallback];
}

- (void)startSeekingToTime:(CMTime)seekedTime withFinishCallback:(FXDcallbackFinish)finishCallback {

	__weak FXDsuperPlaybackManager *weakSelf = self;

	if (CMTIME_IS_VALID(seekedTime) == NO) {
		FXDLog_DEFAULT;
		FXDLogBOOL(CMTIME_IS_VALID(seekedTime));

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	if (weakSelf.moviePlayer.status != AVPlayerStatusReadyToPlay
		&& weakSelf.moviePlayer.currentItem.status != AVPlayerItemStatusReadyToPlay) {
		FXDLog_DEFAULT;
		FXDLog(@"%@ %@", _Variable(weakSelf.moviePlayer.status), _Variable(weakSelf.moviePlayer.currentItem.status));

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	CMTime currentTime = [weakSelf.moviePlayer.currentItem currentTime];
	//FXDLog(@"%@ %@ %@", _Time(seekedTime), _Time(currentTime), _Variable(CMTimeCompare(currentTime, seekedTime)));

	if (CMTimeCompare(currentTime, seekedTime) == NSOrderedSame) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}

	if (CMTimeCompare(weakSelf.lastSeekedTime, seekedTime) == NSOrderedSame) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	weakSelf.lastSeekedTime = seekedTime;

	[weakSelf.moviePlayer.currentItem cancelPendingSeeks];

	[weakSelf.moviePlayer.currentItem
	 seekToTime:seekedTime
	 completionHandler:^(BOOL didFinish) {
		 if (didFinish) {
			 weakSelf.playbackCurrentTime = [weakSelf.moviePlayer.currentItem currentTime];
		 }

		 if (finishCallback) {
			 finishCallback(_cmd, didFinish, nil);
		 }
	 }];
}

#pragma mark -
- (void)resumeMoviePlayerWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	__weak FXDsuperPlaybackManager *weakSelf = self;

	FXDcallbackFinish ResumingMoviePlayer = ^(SEL caller, BOOL didFinish, id responseObj){
		FXDLogTime(periodicintervalDefault);

		weakSelf.playbackCurrentTime = [weakSelf.moviePlayer.currentItem currentTime];

		if (weakSelf.periodicObserver == nil) {
			weakSelf.periodicObserver =
			[weakSelf.moviePlayer
			 addPeriodicTimeObserverForInterval:periodicintervalDefault
			 queue:NULL
			 usingBlock:^(CMTime currentTime) {

				 weakSelf.playbackCurrentTime = [weakSelf.moviePlayer.currentItem currentTime];
			 }];
		}

		[weakSelf.moviePlayer play];

		if (finishCallback) {
			finishCallback(caller, didFinish, responseObj);
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
	 withFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
		 ResumingMoviePlayer(_cmd, didFinish, responseObj);
	 }];
}

- (void)pauseRemovingPeriodicObserver {	//FXDLog_DEFAULT;
	
	__weak FXDsuperPlaybackManager *weakSelf = self;

	[weakSelf.moviePlayer pause];

	if (weakSelf.periodicObserver) {
		[weakSelf.moviePlayer removeTimeObserver:weakSelf.periodicObserver];
		weakSelf.periodicObserver = nil;
	}
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
