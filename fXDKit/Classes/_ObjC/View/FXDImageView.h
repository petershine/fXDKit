
#import "FXDimportEssential.h"


@interface UIImageView (Essential)
- (void)modifyHeightForContainedImage;

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;

- (UIColor*) getPixelColorAtLocation:(CGPoint)point;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef)inImage;

@end


@interface UIImageView (Asynchronous)
- (void)asynchronousUpdateWithImageURL:(NSURL*)imageURL placeholderImage:(UIImage*)placeholderImage withCallback:(FXDcallbackFinish)finishCallback;
@end
