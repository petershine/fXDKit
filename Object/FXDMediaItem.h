//
//  FXDMediaItem.h
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

@import MediaPlayer;


@interface FXDMediaItem : MPMediaItem
@end


@interface MPMediaItem (Essential)
- (NSDictionary*)propertiesDictionary;

- (UIImage*)artworkImageWithSize:(CGSize)size;

- (NSNumber*)propertyPersistentID;
- (NSString*)propertyTitle;
- (NSString*)propertyArtist;
- (NSString*)propertyAlbumTitle;
- (NSString*)propertyGenre;
- (NSNumber*)propertyPlaybackDuration;

@end
