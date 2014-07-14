

#import "FXDKit.h"

@import MediaPlayer;


@interface MPMusicPlayerController (ForLowerVersion)
+ (instancetype)deviceMusicPlayer;
@end


@interface FXDmoduleMusic : FXDsuperModule

@property (nonatomic) MPMusicPlaybackState playbackState;
@property (nonatomic) MPMediaItem *nowPlayingItem;


- (void)startObservingMusicPlayerNotifications;

- (void)observedMPMusicPlayerControllerPlaybackStateDidChange:(NSNotification*)notification;
- (void)observedMPMusicPlayerControllerNowPlayingItemDidChange:(NSNotification*)notification;

@end
