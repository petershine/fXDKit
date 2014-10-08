
@import MediaPlayer;

#import "FXDKit.h"


@interface MPMusicPlayerController (Added)
+ (instancetype)deviceMusicPlayer;
@end


@interface MPMediaLibrary (Added)
- (MPMediaItem*)mediaItemForPersistentID:(NSNumber*)persistentID;
- (MPMediaItem*)mediaItemForTitle:(NSString*)title forArtist:(NSString*)artist forAlbumTitle:(NSString*)albumTitle;
@end


@interface FXDmoduleMusic : FXDsuperModule

@property (nonatomic) MPMusicPlaybackState playbackState;
@property (weak, nonatomic) MPMediaItem *nowPlayingItem;


- (void)startObservingPlayerNotifications;
- (void)startObservingLibraryNotifications;


- (void)observedMPMusicPlayerControllerPlaybackStateDidChange:(NSNotification*)notification;
- (void)observedMPMusicPlayerControllerNowPlayingItemDidChange:(NSNotification*)notification;

- (void)observedMPMediaLibraryDidChange:(NSNotification*)notification;

@end
