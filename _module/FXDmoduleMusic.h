

#import "FXDKit.h"

@import MediaPlayer;


@interface MPMusicPlayerController (Added)
+ (instancetype)deviceMusicPlayer;
@end


@interface MPMediaLibrary (Added)
@end


@interface FXDmoduleMusic : FXDsuperModule

@property (nonatomic) MPMusicPlaybackState playbackState;
@property (nonatomic) MPMediaItem *nowPlayingItem;


- (void)startObservingPlayerNotifications;
- (void)startObservingLibraryNotifications;


- (void)observedMPMusicPlayerControllerPlaybackStateDidChange:(NSNotification*)notification;
- (void)observedMPMusicPlayerControllerNowPlayingItemDidChange:(NSNotification*)notification;

- (void)observedMPMediaLibraryDidChange:(NSNotification*)notification;

@end
