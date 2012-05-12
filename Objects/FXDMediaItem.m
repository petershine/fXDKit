//
//  FXDMediaItem.m
//
//
//  Created by Peter SHINe on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDMediaItem.h"


#pragma mark - Private interface
@interface FXDMediaItem (Private)
@end


#pragma mark - Public implementation
@implementation FXDMediaItem

#pragma mark Static objects

#pragma mark Synthesizing
// Properties

// Controllers


#pragma mark - Memory management
- (void)dealloc {	
	// Instance variables
	
	// Properties
	
    // Controllers
	
	[super dealloc];
}


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
		
        // Controllers
	}
	
	return self;
}

#pragma mark - Accessor overriding
// Properties

// Controllers


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation MPMediaItem (Added)
- (NSDictionary*)propertiesDictionary {
	NSMutableDictionary *propertiesDictionary = nil;
	
	NSArray *mediaProperties = [NSArray arrayWithObjects:
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
								MPMediaItemPropertyUserGrouping,
								
								nil];
	
	for (NSString *property in mediaProperties) {
		id value = [self valueForProperty:property];
		
		if (value) {
			if (propertiesDictionary == nil) {
				propertiesDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
				[propertiesDictionary autorelease];
			}
			
			[propertiesDictionary setObject:value forKey:property];
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

- (NSString*)propertyTitle {
	NSString *text = [self valueForProperty:MPMediaItemPropertyTitle];
	
	return text;
}

- (NSString*)propertyArtist {
	NSString *text = [self valueForProperty:MPMediaItemPropertyArtist];
	
	return text;
}

- (NSString*)propertyAlbum {
	NSString *text = [self valueForProperty:MPMediaItemPropertyAlbumTitle];
	
	return text;
}

- (NSString*)propertyGenre {
	NSString *text = [self valueForProperty:MPMediaItemPropertyGenre];
	
	return text;
}

@end