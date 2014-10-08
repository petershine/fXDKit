

#import "FXDmoduleMusic.h"


@implementation MPMusicPlayerController (Added)
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


@implementation MPMediaLibrary (Added)
- (MPMediaItem*)mediaItemForPersistentID:(NSNumber*)persistentID {
	//FXDLogObject(persistentID);

	MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate
										   predicateWithValue:persistentID
										   forProperty:MPMediaEntityPropertyPersistentID];

	MPMediaQuery *mediaQuery = [[MPMediaQuery alloc]
								initWithFilterPredicates:[NSSet setWithObject:predicate]];

	if (mediaQuery.items.count > 1) {
		MPMediaLibrary *mediaLibrary = [MPMediaLibrary defaultMediaLibrary];
		FXDLogObject(mediaLibrary.lastModifiedDate);

		FXDLogObject(predicate);
		FXDLogObject(mediaQuery.items);
	}

	return mediaQuery.items.firstObject;
}

- (MPMediaItem*)mediaItemForTitle:(NSString*)title forArtist:(NSString*)artist forAlbumTitle:(NSString*)albumTitle {
	MPMediaQuery *songQuery = [[MPMediaQuery alloc] init];

	if (title.length > 0) {
		MPMediaPropertyPredicate *titlePredicate = [MPMediaPropertyPredicate
													predicateWithValue:title
													forProperty:MPMediaItemPropertyTitle];
		[songQuery addFilterPredicate:titlePredicate];
	}

	if (artist.length > 0) {
		MPMediaPropertyPredicate *artistPredicate = [MPMediaPropertyPredicate
													 predicateWithValue:artist
													 forProperty:MPMediaItemPropertyArtist];
		[songQuery addFilterPredicate:artistPredicate];
	}

	if (albumTitle.length > 0) {
		MPMediaPropertyPredicate *albumTitlePredicate = [MPMediaPropertyPredicate
														 predicateWithValue:albumTitle
														 forProperty:MPMediaItemPropertyAlbumTitle];
		[songQuery addFilterPredicate:albumTitlePredicate];
	}


	MPMediaItem *mediaItem = songQuery.items.firstObject;

	return mediaItem;
}
@end


@implementation FXDmoduleMusic

#pragma mark - Memory management
- (void)dealloc {
	MPMusicPlayerController *musicPlayer = [MPMusicPlayerController deviceMusicPlayer];
	[musicPlayer endGeneratingPlaybackNotifications];

	MPMediaLibrary *mediaLibrary = [MPMediaLibrary defaultMediaLibrary];
	[mediaLibrary endGeneratingLibraryChangeNotifications];
}


#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		MPMusicPlayerController *musicPlayer = [MPMusicPlayerController deviceMusicPlayer];

		self.playbackState = musicPlayer.playbackState;
		self.nowPlayingItem = musicPlayer.nowPlayingItem;
	}

	return self;
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public
- (void)startObservingPlayerNotifications {	FXDLog_DEFAULT;
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

- (void)startObservingLibraryNotifications {	FXDLog_DEFAULT;
	MPMediaLibrary *mediaLibrary = [MPMediaLibrary defaultMediaLibrary];

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedMPMediaLibraryDidChange:)
	 name:MPMediaLibraryDidChangeNotification
	 object:mediaLibrary];

	[mediaLibrary beginGeneratingLibraryChangeNotifications];
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

#pragma mark -
- (void)observedMPMediaLibraryDidChange:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLogObject(notification);

	MPMediaLibrary *mediaLibrary = [MPMediaLibrary defaultMediaLibrary];
	FXDLogObject(mediaLibrary.lastModifiedDate);


	MPMediaQuery *mediaQuery = [MPMediaQuery playlistsQuery];

	//FXDLogObject(mediaQuery.items);
	FXDLogVariable(mediaQuery.collections.count);
	FXDLogVariable(mediaQuery.groupingType);

	for (MPMediaPlaylist *playlist in mediaQuery.collections) {

		if ([MPMediaPlaylist canFilterByProperty:MPMediaPlaylistPropertyName]) {
			FXDLog(@"%@\t%@", _Variable(playlist.items.count), _Object([playlist valueForProperty:MPMediaPlaylistPropertyName]));
		}
	}
}

#pragma mark - Delegate

@end
