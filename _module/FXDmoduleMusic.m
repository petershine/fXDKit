

#import "FXDmoduleMusic.h"

@implementation MPMusicPlayerController (ForLowerVersion)
+ (instancetype)deviceMusicPlayer {
	MPMusicPlayerController *musicPlayer = nil;

	if (SYSTEM_VERSION_sameOrHigher(iosVersion8)) {
		musicPlayer = [MPMusicPlayerController systemMusicPlayer];
	}
	else {
		musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	}

	return musicPlayer;
}
@end


@implementation FXDmoduleMusic

#pragma mark - Memory management
- (void)dealloc {
	MPMusicPlayerController *musicPlayer = [MPMusicPlayerController deviceMusicPlayer];
	[musicPlayer endGeneratingPlaybackNotifications];
}


#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)startObservingMusicPlayerNotifications {	FXDLog_DEFAULT;
	MPMusicPlayerController *musicPlayer = [MPMusicPlayerController deviceMusicPlayer];

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedMPMusicPlayerControllerPlaybackStateDidChange:)
	 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
	 object:musicPlayer];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedMPMusicPlayerControllerNowPlayingItemDidChange:)
	 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
	 object:musicPlayer];

	[musicPlayer beginGeneratingPlaybackNotifications];
}

#pragma mark - Observer
- (void)observedMPMusicPlayerControllerPlaybackStateDidChange:(NSNotification*)notification {

	MPMusicPlayerController *musicPlayer = [MPMusicPlayerController deviceMusicPlayer];
	self.playbackState = musicPlayer.playbackState;
}

- (void)observedMPMusicPlayerControllerNowPlayingItemDidChange:(NSNotification*)notification {

	MPMusicPlayerController *musicPlayer = [MPMusicPlayerController deviceMusicPlayer];
	self.nowPlayingItem = musicPlayer.nowPlayingItem;
}

#pragma mark - Delegate

@end
