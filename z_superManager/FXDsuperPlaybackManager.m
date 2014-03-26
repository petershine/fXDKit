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

	CGRect screenFrame = [[UIDevice currentDevice] screenFrameForOrientation];

	_mainVideoDisplay = [[FXDviewVideoDisplay alloc] initWithFrame:screenFrame];
	_mainVideoDisplay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	_mainVideoDisplay.contentMode = UIViewContentModeScaleAspectFit;

	_mainVideoDisplay.layer.contentsGravity = @"resizeAspect";

	return _mainVideoDisplay;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)preparePlaybackManagerWithFileURL:(NSURL*)fileURL withScene:(UIViewController*)scene withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {	FXDLog_DEFAULT;

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
			  FXDLogVar(valueStatus);

			  if (valueStatus != AVKeyValueStatusLoaded) {
				  if (didFinishBlock) {
					  didFinishBlock(NO, nil);
				  }
				  return;
			  }


			  AVPlayerItem *videoItem = [AVPlayerItem playerItemWithAsset:asset];

			  self.videoPlayer = [AVPlayer playerWithPlayerItem:videoItem];

			  [self.mainVideoDisplay setMainPlayer:self.videoPlayer];


			  [scene.view addSubview:self.mainVideoDisplay];
			  [scene.view sendSubviewToBack:self.mainVideoDisplay];


			  [self
			   startSeekingToProgressValue:0.0
			   withDidFinishBlock:^(BOOL finished, id responseObj) {

				   [self configurePlaybackObservers];

				   if (didFinishBlock) {
					   didFinishBlock(YES, nil);
				   }
			   }];
		  }];
	 }];
}

- (void)configurePlaybackObservers {	FXDLog_DEFAULT;
	__weak FXDsuperPlaybackManager *weakSelf = self;

	CMTime periodInterval = CMTimeMake(1.0, doubleOneBillion);
	FXDLog(@"periodInterval: %@ %f", CMTimeValue(periodInterval), CMTimeGetSeconds(periodInterval));

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
- (void)startSeekingToProgressValue:(Float64)progressValue withDidFinishBlock:(FXDblockDidFinish)didFinishBlock {

	__weak FXDsuperPlaybackManager *weakSelf = self;

	if (weakSelf.didStartSeeking) {
		if (didFinishBlock) {
			didFinishBlock(NO, nil);
		}
		return;
	}


	weakSelf.didStartSeeking = YES;

	CMTime seekedTime = [weakSelf seekedTimeUsingProgressValue:progressValue];

	[weakSelf.videoPlayer
	 seekToTime:seekedTime
	 completionHandler:^(BOOL finished) {

		 weakSelf.didStartSeeking = NO;

		 if (didFinishBlock) {
			 didFinishBlock(finished, nil);
		 }
	 }];
}

- (CMTime)seekedTimeUsingProgressValue:(Float64)progressValue {

	CMTime recordingDuration = self.videoPlayer.currentItem.duration;

	Float64 progressSeconds = CMTimeGetSeconds(recordingDuration)*progressValue;

	CMTime seekedTime = CMTimeForMediaSeconds(progressSeconds);

	return seekedTime;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
