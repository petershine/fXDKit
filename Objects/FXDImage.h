//
//  FXDImage.h
//
//
//  Created by petershine on 11/7/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDImage : UIImage

// Properties

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category

@interface UIImage (Added)

+ (UIImage*)bundledImageForName:(NSString*)imagename;

// Use snippets from this link: http://iphoneincubator.com/blog/windows-views/image-processing-tricks
- (UIImage*)croppedImageUsingCropRect:(CGRect)cropRect;

- (UIImage*)smallerImageUsingMaximumSize:(CGSize)maximumSize;

- (UIImage*)largerImageUsingMinimumSize:(CGSize)minimumSize;

- (UIImage*)scaledImageUsingModifiedSize:(CGSize)modifiedSize;

- (UIImage*)thumbImageUsingThumbDimension:(CGFloat)thumbDimension;

- (UIImage*)fixOrientation;

- (UIImage*)maskedImageWithMaskImageName:(NSString*)maskImageName;

- (CGSize)deviceScaledSize;

@end
