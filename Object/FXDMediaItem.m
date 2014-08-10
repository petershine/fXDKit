

#import "FXDMediaItem.h"


@implementation MPMediaItem (Essential)
- (NSDictionary*)propertiesDictionary {
	NSMutableDictionary *propertiesDictionary = nil;
	
	NSArray *mediaProperties = @[
		MPMediaItemPropertyPersistentID,
		MPMediaItemPropertyMediaType,
		MPMediaItemPropertyTitle,
		MPMediaItemPropertyAlbumTitle,
		MPMediaItemPropertyAlbumPersistentID,
		
		MPMediaItemPropertyArtist,
		MPMediaItemPropertyArtistPersistentID,
		
		MPMediaItemPropertyAlbumArtist,
		MPMediaItemPropertyAlbumArtistPersistentID,
		
		MPMediaItemPropertyGenre,
		MPMediaItemPropertyGenrePersistentID,
		
		MPMediaItemPropertyComposer,
		MPMediaItemPropertyComposerPersistentID,
		
		MPMediaItemPropertyPlaybackDuration,
		MPMediaItemPropertyAlbumTrackNumber,
		MPMediaItemPropertyAlbumTrackCount,
		MPMediaItemPropertyDiscNumber,
		MPMediaItemPropertyDiscCount,
		MPMediaItemPropertyArtwork,
		MPMediaItemPropertyLyrics,
		MPMediaItemPropertyIsCompilation,
		MPMediaItemPropertyReleaseDate,
		
		MPMediaItemPropertyBeatsPerMinute,
		MPMediaItemPropertyComments,
		MPMediaItemPropertyAssetURL,
		
		MPMediaItemPropertyPodcastTitle,
		MPMediaItemPropertyPodcastPersistentID,
		
		MPMediaItemPropertyPlayCount,
		MPMediaItemPropertySkipCount,
		MPMediaItemPropertyRating,
		MPMediaItemPropertyLastPlayedDate,
		MPMediaItemPropertyUserGrouping
	];
	
	for (NSString *property in mediaProperties) {
		id value = [self valueForProperty:property];
		
		if (value) {
			if (propertiesDictionary == nil) {
				propertiesDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
			}
			
			propertiesDictionary[property] = value;
		}
	}
	
	return (NSDictionary*)propertiesDictionary;
}

@end