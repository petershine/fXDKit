


@import MediaPlayer;


@interface MPMusicPlayerController (Added)
@end


@interface MPMediaLibrary (Added)
- (MPMediaItem*)mediaItemForPersistentID:(NSNumber*)persistentID;
- (MPMediaItem*)mediaItemForTitle:(NSString*)title forArtist:(NSString*)artist forAlbumTitle:(NSString*)albumTitle;
@end


#import "FXDsuperModule.h"
@interface FXDmoduleMusic : FXDsuperModule {
	MPMusicPlayerController *_musicPlayer;
}

@property (weak, nonatomic, readonly) MPMusicPlayerController *musicPlayer;

@property (nonatomic) MPMusicPlaybackState playbackState;
@property (weak, nonatomic) MPMediaItem *nowPlayingItem;


- (void)startObservingPlayerNotifications;
- (void)startObservingLibraryNotifications;


- (void)observedMPMusicPlayerControllerPlaybackStateDidChange:(NSNotification*)notification;
- (void)observedMPMusicPlayerControllerNowPlayingItemDidChange:(NSNotification*)notification;

- (void)observedMPMediaLibraryDidChange:(NSNotification*)notification;

@end