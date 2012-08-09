//
//  FXDImage.h
//
//
//  Created by petershine on 11/7/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDImage : UIImage {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
}

// Properties


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
// Use snippets from this link: http://iphoneincubator.com/blog/windows-views/image-processing-tricks
@interface UIImage (Added)
+ (UIImage*)bundledImageForName:(NSString*)imagename;

- (UIImage*)croppedImageUsingCropRect:(CGRect)cropRect;

- (UIImage*)smallerImageUsingMaximumSize:(CGSize)maximumSize;

- (UIImage*)largerImageUsingMinimumSize:(CGSize)minimumSize;

- (UIImage*)scaledImageUsingModifiedSize:(CGSize)modifiedSize;

- (UIImage*)thumbImageUsingThumbDimension:(CGFloat)thumbDimension;

- (UIImage*)fixOrientation;


@end
