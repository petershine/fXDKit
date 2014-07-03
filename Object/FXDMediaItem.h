
#import "FXDKit.h"


@import MediaPlayer;


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
