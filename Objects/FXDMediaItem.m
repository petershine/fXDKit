//
//  FXDMediaItem.m
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDMediaItem.h"


#pragma mark - Public implementation
@implementation FXDMediaItem


#pragma mark - Memory management


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}

#pragma mark - Accessor overriding



#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation MPMediaItem (Added)
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

#pragma mark -
- (UIImage*)artworkImageWithSize:(CGSize)size {
	UIImage *artworkImage = nil;
	
	MPMediaItemArtwork *artwork = [self valueForProperty:MPMediaItemPropertyArtwork];
	
	if (artwork) {
		artworkImage = [artwork imageWithSize:size];
	}
	
	return artworkImage;
}

#pragma mark -
- (NSNumber*)propertyPersistentID {
	return [self valueForProperty:MPMediaItemPropertyPersistentID];
}

- (NSString*)propertyTitle {
	return [self valueForProperty:MPMediaItemPropertyTitle];
}

- (NSString*)propertyArtist {
	return [self valueForProperty:MPMediaItemPropertyArtist];
}

- (NSString*)propertyAlbumTitle {
	return [self valueForProperty:MPMediaItemPropertyAlbumTitle];
}

- (NSString*)propertyGenre {
	return [self valueForProperty:MPMediaItemPropertyGenre];
}

- (NSNumber*)propertyPlaybackDuration {
	return [self valueForProperty:MPMediaItemPropertyPlaybackDuration];
}

@end