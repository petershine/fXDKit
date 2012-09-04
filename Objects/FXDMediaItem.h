//
//  FXDMediaItem.h
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"

#import <MediaPlayer/MediaPlayer.h>


@interface FXDMediaItem : MPMediaItem {
    // Primitives
	
	// Instance variables
	
    // Properties : For accessor overriding
}

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface MPMediaItem (Added)
- (NSDictionary*)propertiesDictionary;

- (UIImage*)artworkImageWithSize:(CGSize)size;

- (NSNumber*)propertyPersistentID;
- (NSString*)propertyTitle;
- (NSString*)propertyArtist;
- (NSString*)propertyAlbumTitle;
- (NSString*)propertyGenre;
- (NSNumber*)propertyPlaybackDuration;

@end
