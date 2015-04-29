
@import UIKit;
@import Foundation;


@interface UIImageView (Essential)
- (void)modifyHeightForContainedImage;

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;

- (UIColor*) getPixelColorAtLocation:(CGPoint)point;
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef)inImage;

@end


#if USE_AFNetworking
@interface UIImageView (Asynchronous)
- (void)asynchronousUpdateWithImageURL:(NSURL*)imageURL placeholderImage:(UIImage*)placeholderImage withCallback:(FXDcallbackFinish)finishCallback;
@end
#endif