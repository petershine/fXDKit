

#import "FXDimportCore.h"

@import UIKit;
@import Foundation;


@interface UIImage (Essential)

+ (UIImage*)bundledImageForName:(NSString*)imagename;

+ (void)CGImageRotatedByAngle:(CGImageRef)originalImageRef rotatedImageRef:(CGImageRef*)rotatedImageRef byAngle:(CGFloat)angle;

// Use snippets from this link: http://iphoneincubator.com/blog/windows-views/image-processing-tricks
- (UIImage*)croppedImageUsingCropRect:(CGRect)cropRect;

- (UIImage*)smallerImageUsingMaximumSize:(CGSize)maximumSize;

- (UIImage*)largerImageUsingMinimumSize:(CGSize)minimumSize;

- (UIImage*)resizedImageUsingSize:(CGSize)size;
- (UIImage*)resizedImageUsingSize:(CGSize)size forScale:(CGFloat)scale;
- (UIImage*)resizedImageFromContextForSize:(CGSize)size;

- (UIImage*)thumbnailForSize:(CGSize)size;
- (UIImage*)thumbImageUsingThumbDimension:(CGFloat)thumbDimension;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage *fixOrientation;

- (UIImage*)maskedImageWithMaskImageName:(NSString*)maskImageName;

@property (NS_NONATOMIC_IOSONLY, readonly) CGSize deviceScaledSize;

@end
