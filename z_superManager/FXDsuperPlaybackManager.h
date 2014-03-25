//
//  FXDsuperPlaybackManager.h
//
//
//  Created by petershine on 2/3/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@import AssetsLibrary;


@interface AVPlayerItem (Added)
- (Float64)progressValue;
@end


@interface FXDviewVideoDisplay : FXDView
@property (strong, nonatomic) AVPlayer *mainPlayer;
@end


@interface FXDsuperPlaybackManager : FXDObject
// Properties
@property (nonatomic) BOOL didStartSeeking;

@property (nonatomic) Float64 progressValue;

@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (strong, nonatomic) id periodicObserver;

@property (strong, nonatomic) FXDviewVideoDisplay *videoDisplay;


#pragma mark - Initialization

#pragma mark - Public
- (void)preparePlaybackManagerWithFileURL:(NSURL*)fileURL withScene:(UIViewController*)scene withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)configurePlaybackObservers;

- (void)startSeekingToProgressValue:(Float64)progressValue withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (CMTime)seekedTimeUsingProgressValue:(Float64)progressValue;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
