//
//  FXDImage.m
//
//
//  Created by petershine on 11/7/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDImage.h"


#pragma mark - Private interface
@interface FXDImage (Private)
@end


#pragma mark - Public implementation
@implementation FXDImage

#pragma mark Synthesizing
// Properties


#pragma mark - Memory management


#pragma mark - Initialization
- (id)init {
	self = [super init];
	
	if (self) {
		// Primitives
		
		// Instance variables
		
		// Properties
	}
	
	return self;
}

#pragma mark - Accessor overriding


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIImage (Added)
+ (UIImage*)bundledImageForName:(NSString*)imageName {
	UIImage *bundledImage = [UIImage imageNamed:imageName];
	
	// To load from jpg, use specific scale value for retina
	if (bundledImage == nil) {
		if ([UIScreen mainScreen].scale >= 2.0) {
			imageName = [imageName stringByAppendingString:@"@2x"];
		}
		
		imageName = [imageName stringByAppendingString:@".jpg"];
		
		bundledImage = [UIImage imageNamed:imageName];
	}
	
#if ForDEVELOPER
	if (bundledImage == nil) {
		FXDLog(@"imageName: %@ bundledImage: %@", imageName, bundledImage);
	}
#endif
	
	return bundledImage;
}

#pragma mark -
- (UIImage*)croppedImageUsingCropRect:(CGRect)cropRect {	FXDLog_DEFAULT;
	FXDLog(@"self.size: %@", NSStringFromCGSize(self.size));
	FXDLog(@"cropRect: %@", NSStringFromCGRect(cropRect));
	
	UIImage *croppedImage = nil;
	
	if (cropRect.size.width == 0.0 && cropRect.size.height == 0.0) {
		croppedImage = [UIImage imageWithCGImage:self.CGImage];
	}
	else {
		CGImageRef croppedImageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
		
		croppedImage = [UIImage imageWithCGImage:croppedImageRef];
		
		if (croppedImageRef) {
			CFRelease(croppedImageRef);
		}
	}
	
	FXDLog(@"croppedImage.size: %@", NSStringFromCGSize(croppedImage.size));
	
	return croppedImage;
}

- (UIImage*)smallerImageUsingMaximumSize:(CGSize)maximumSize {
	
	CGSize modifiedSize = self.size;
	
	CGFloat aspectRatio = (float)modifiedSize.width / (float)modifiedSize.height;
	
	if (aspectRatio > 1.0) {
		if (modifiedSize.width > maximumSize.width) {				
			modifiedSize.width = maximumSize.width;
		}
		
		modifiedSize.height = modifiedSize.width / aspectRatio;
	}
	else {
		if (modifiedSize.height > maximumSize.height) {	// Retina size
			modifiedSize.height = maximumSize.height;
		}
		
		modifiedSize.width = modifiedSize.height * aspectRatio;
	}
	
	UIImage *scaledImage = [self scaledImageUsingModifiedSize:modifiedSize];
	
	return scaledImage;
}

- (UIImage*)largerImageUsingMinimumSize:(CGSize)minimumSize {
	
	CGSize modifiedSize = self.size;
	
	CGFloat aspectRatio = (float)modifiedSize.width / (float)modifiedSize.height;
	
	if (aspectRatio > 1.0) {
		if (modifiedSize.height < minimumSize.height) {	// Retina size
			modifiedSize.height = minimumSize.height;
		}
		
		modifiedSize.width = modifiedSize.height * aspectRatio;
	}
	else {
		if (modifiedSize.width < minimumSize.width) {				
			modifiedSize.width = minimumSize.width;
		}
		
		modifiedSize.height = modifiedSize.width / aspectRatio;
	}
	
	UIImage *scaledImage = [self scaledImageUsingModifiedSize:modifiedSize];
	
	return scaledImage;
}

- (UIImage*)scaledImageUsingModifiedSize:(CGSize)modifiedSize {
	UIImage *scaledImage = nil;

	UIGraphicsBeginImageContext(modifiedSize);
	{
		[self drawInRect:CGRectMake(0, 0, modifiedSize.width, modifiedSize.height)];
		
		UIImage *modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
		
		scaledImage = [[UIImage alloc] initWithCGImage:modifiedImage.CGImage];
	}
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

- (UIImage*)thumbImageUsingThumbDimension:(CGFloat)thumbDimension {
	UIImage *thumbImage = nil;
	
	UIImageView *mainImageView = [[UIImageView alloc] initWithImage:self];
	
	BOOL widthGreaterThanHeight = (self.size.width > self.size.height);
	
	CGFloat sideFull = (widthGreaterThanHeight) ? self.size.height : self.size.width;
	
	CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);	
	
	UIGraphicsBeginImageContext(CGSizeMake(thumbDimension, thumbDimension));
	{
		CGContextRef currentContext = UIGraphicsGetCurrentContext();
		CGContextClipToRect( currentContext, clippedRect);
		CGFloat scaleFactor = thumbDimension/sideFull;
		
		CGFloat translatedDistance = (self.size.width -sideFull) /2.0 *scaleFactor;
		
		if (widthGreaterThanHeight) {
			CGContextTranslateCTM(currentContext, -translatedDistance, 0);
		}
		else {
			CGContextTranslateCTM(currentContext, 0, -translatedDistance);
		}
		
		CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
		[mainImageView.layer renderInContext:currentContext];
		
		thumbImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();
	
	return thumbImage;
}

- (UIImage*)fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
	
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
	
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
			
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
		
		default:
			break;
    }
	
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
			
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
			
		default:
			break;
    }
	
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
			
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
	
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
