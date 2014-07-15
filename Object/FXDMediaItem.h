
#import "FXDKit.h"

@import MediaPlayer;


@interface MPMediaItem (Essential)
- (NSDictionary*)propertiesDictionary;

- (UIImage*)artworkImageWithSize:(CGSize)size;

@end
