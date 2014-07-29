
@import MediaPlayer;

#import "FXDKit.h"


@interface MPMediaItem (Essential)
- (NSDictionary*)propertiesDictionary;

- (UIImage*)artworkImageWithSize:(CGSize)size;

@end
