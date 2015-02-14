
#import "FXDimportCore.h"


@interface UIImageView (Essential)
- (void)modifyHeightForContainedImage;

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;

- (UIColor*) getPixelColorAtLocation:(CGPoint)point;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef)inImage;

@end
