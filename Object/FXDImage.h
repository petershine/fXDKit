//
//  FXDImage.h
//
//
//  Created by petershine on 11/7/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDImage : UIImage
@end


#pragma mark - Category
@interface UIImage (Essential)

+ (UIImage*)bundledImageForName:(NSString*)imagename;

+ (void)CGImageRotatedByAngle:(CGImageRef)originalImageRef rotatedImageRef:(CGImageRef*)rotatedImageRef byAngle:(CGFloat)angle;

// Use snippets from this link: http://iphoneincubator.com/blog/windows-views/image-processing-tricks
- (UIImage*)croppedImageUsingCropRect:(CGRect)cropRect;

- (UIImage*)smallerImageUsingMaximumSize:(CGSize)maximumSize;

- (UIImage*)largerImageUsingMinimumSize:(CGSize)minimumSize;

- (UIImage*)resizedImageUsingSize:(CGSize)size;
- (UIImage*)resizedImageUsingSize:(CGSize)size forScale:(CGFloat)scale;

- (UIImage*)thumbImageUsingThumbDimension:(CGFloat)thumbDimension;

- (UIImage*)fixOrientation;

- (UIImage*)maskedImageWithMaskImageName:(NSString*)maskImageName;

- (CGSize)deviceScaledSize;

@end
