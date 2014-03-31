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
	[_mainVideoDisplay setMainPlayer:nil];
	[_mainVideoDisplay removeFromSuperview];

	[_videoPlayer pause];

	[_videoPlayer removeTimeObserver:_periodicObserver];
	_periodicObserver = nil;
}


#pragma mark - Initialization

#pragma mark - Property overriding
- (FXDviewVideoDisplay*)mainVideoDisplay {
	if (_mainVideoDisplay) {
		return _mainVideoDisplay;
	}


	FXDLog_DEFAULT;

	CGRect screenBounds = [[UIDevice currentDevice] screenBoundsForOrientation];

	_mainVideoDisplay = [[FXDviewVideoDisplay alloc] initWithFrame:screenBounds];
	_mainVideoDisplay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

	AVPlayerLayer *displayLayer = (AVPlayerLayer*)[_mainVideoDisplay layer];
	FXDLogObject([displayLayer class]);

	displayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

	return _mainVideoDisplay;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)preparePlaybackManagerWithFileURL:(NSURL*)fileURL withScene:(UIViewController*)scene withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
	NSString *tracksKey = @"tracks";

	[asset
	 loadValuesAsynchronouslyForKeys:@[tracksKey]
	 completionHandler:^{
		 FXDLog_BLOCK(asset, @selector(loadValuesAsynchronouslyForKeys:completionHandler:));
		 FXDLogBOOL(asset.isPlayable);

		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  
			  NSError *error = nil;
			  AVKeyValueStatus valueStatus = [asset statusOfValueForKey:tracksKey error:&error];
			  FXDLog_ERROR;
			  FXDLogVariable(valueStatus);

			  if (valueStatus != AVKeyValueStatusLoaded) {
				  if (finishCallback) {
					  finishCallback(_cmd, NO, nil);
				  }
				  return;
			  }


			  AVPlayerItem *videoItem = [AVPlayerItem playerItemWithAsset:asset];

			  self.videoPlayer = [AVPlayer playerWithPlayerItem:videoItem];

			  [self.mainVideoDisplay setMainPlayer:self.videoPlayer];


			  [scene.view addSubview:self.mainVideoDisplay];
			  [scene.view sendSubviewToBack:self.mainVideoDisplay];


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
	__weak FXDsuperPlaybackManager *weakSelf = self;

	CMTime periodInterval = CMTimeMake(1.0, doubleOneBillion);
	FXDLogStruct(periodInterval);

	weakSelf.periodicObserver =
	[weakSelf.videoPlayer
	 addPeriodicTimeObserverForInterval:periodInterval
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

	__weak FXDsuperPlaybackManager *weakSelf = self;

	if (weakSelf.didStartSeeking) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	weakSelf.didStartSeeking = YES;

	[weakSelf.videoPlayer
	 seekToTime:progressTime
	 completionHandler:^(BOOL finished) {

		 weakSelf.didStartSeeking = NO;

		 if (finishCallback) {
			 finishCallback(_cmd, finished, nil);
		 }
	 }];
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
