

#import "FXDmoduleMusic.h"


@implementation MPMusicPlayerController (Added)
@end


@implementation MPMediaLibrary (Added)
- (MPMediaItem*)mediaItemForPersistentID:(NSNumber*)persistentID {
	//FXDLogObject(persistentID);

	MPMediaQuery *mediaQuery  = [[MPMediaQuery alloc] init];

	MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate
										   predicateWithValue:persistentID
										   forProperty:MPMediaEntityPropertyPersistentID];

	[mediaQuery addFilterPredicate:predicate];


	MPMediaItem *mediaItem = mediaQuery.items.firstObject;

	if (mediaItem == nil) {
		/*
		 MPMediaLibrary *mediaLibrary = [MPMediaLibrary defaultMediaLibrary];
		 FXDLogObject(mediaLibrary.lastModifiedDate);
		 FXDLogObject(predicate);
		 FXDLogObject(mediaQuery.items);
		 */
	}

	return mediaItem;
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
	
	if (mediaItem == nil) {
		//FXDLogObject(songQuery.filterPredicates);
	}

	return mediaItem;
}
@end


@implementation FXDmoduleMusic

#pragma mark - Memory management
- (void)dealloc {
	[self.musicPlayer endGeneratingPlaybackNotifications];

	MPMediaLibrary *mediaLibrary = [MPMediaLibrary defaultMediaLibrary];
	[mediaLibrary endGeneratingLibraryChangeNotifications];
}


#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {
		self.playbackState = self.musicPlayer.playbackState;
		self.nowPlayingItem = self.musicPlayer.nowPlayingItem;
	}

	return self;
}


#pragma mark - Property overriding
- (MPMusicPlayerController*)musicPlayer {
	__strong MPMusicPlayerController *strongMusicPlayer = _musicPlayer;

	if (strongMusicPlayer == nil) {
		_musicPlayer = [MPMusicPlayerController systemMusicPlayer];
	}

	return _musicPlayer;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)startObservingPlayerNotifications {	FXDLog_DEFAULT
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedMPMusicPlayerControllerPlaybackStateDidChange:)
	 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
	 object:self.musicPlayer];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedMPMusicPlayerControllerNowPlayingItemDidChange:)
	 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
	 object:self.musicPlayer];

	[self.musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)startObservingLibraryNotifications {	FXDLog_DEFAULT
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
	self.playbackState = self.musicPlayer.playbackState;
}

- (void)observedMPMusicPlayerControllerNowPlayingItemDidChange:(NSNotification*)notification {
	self.nowPlayingItem = self.musicPlayer.nowPlayingItem;
}

#pragma mark -
- (void)observedMPMediaLibraryDidChange:(NSNotification*)notification {	FXDLog_DEFAULT
	FXDLogObject(notification);

#if DEBUG
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
#endif
}

#pragma mark - Delegate

@end
