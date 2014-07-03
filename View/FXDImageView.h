
#import "FXDKit.h"


@interface FXDImageView : UIImageView
@end


@interface UIImageView (Essential)
- (void)modifyHeightForContainedImage;

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;

- (void)fadeInImage:(UIImage*)fadedImage;

@end
