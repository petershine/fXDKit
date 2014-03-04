//
//  FXDImage.m
//
//
//  Created by petershine on 11/7/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDImage.h"


#pragma mark - Public implementation
@implementation FXDImage


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation UIImage (Added)
+ (UIImage*)bundledImageForName:(NSString*)imageName {
	UIImage *bundledImage = [UIImage imageNamed:imageName];
	
	//MARK: To load from .jpg, use specific scale value for retina
	if (bundledImage == nil) {
		NSString *scaledImageName = nil;
		
		if ([UIScreen mainScreen].scale >= 2.0) {
			scaledImageName = [imageName stringByAppendingString:@"@2x"];
		}
		else {
			scaledImageName = imageName;
		}
		
		scaledImageName = [scaledImageName stringByAppendingString:@".jpg"];
		
		bundledImage = [UIImage imageNamed:scaledImageName];
	}

	//MARK: If scale value added name is not working try normal name
	if (bundledImage == nil) {
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

+ (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle {
	//https://gist.github.com/ConnorD/585377

	CGFloat angleInRadians = angle * (M_PI / 180);
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);

	CGRect imgRect = CGRectMake(0, 0, width, height);
	CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
	CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmContext = CGBitmapContextCreate(NULL,
												   rotatedRect.size.width,
												   rotatedRect.size.height,
												   8,
												   0,
												   colorSpace,
												   (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
	CGContextSetAllowsAntialiasing(bmContext, YES);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
	CGColorSpaceRelease(colorSpace);
	CGContextTranslateCTM(bmContext,
						  +(rotatedRect.size.width/2),
						  +(rotatedRect.size.height/2));
	CGContextRotateCTM(bmContext, angleInRadians);
	CGContextDrawImage(bmContext, CGRectMake(-width/2, -height/2, width, height),
					   imgRef);

	CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
	CFRelease(bmContext);

	return rotatedImage;
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
	
	CGFloat aspectRatio = (CGFloat)modifiedSize.width / (CGFloat)modifiedSize.height;
	
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
	
	UIImage *resizedImage = [self resizedImageUsingSize:modifiedSize];
	
	return resizedImage;
}

- (UIImage*)largerImageUsingMinimumSize:(CGSize)minimumSize {
	
	CGSize modifiedSize = self.size;
	
	CGFloat aspectRatio = (CGFloat)modifiedSize.width / (CGFloat)modifiedSize.height;
	
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
	
	UIImage *resizedImage = [self resizedImageUsingSize:modifiedSize];
	
	return resizedImage;
}

- (UIImage*)resizedImageUsingSize:(CGSize)size {
	UIImage *resizedImage = [self resizedImageUsingSize:size forScale:[UIScreen mainScreen].scale];

	return resizedImage;
}

- (UIImage*)resizedImageUsingSize:(CGSize)size forScale:(CGFloat)scale {
	UIImage *resizedImage = nil;

	UIGraphicsBeginImageContextWithOptions(size,
										   NO,	//MARK: to allow transparency
										   scale);
	{
		[self drawInRect:CGRectMake(0, 0, size.width, size.height)];

		resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();

	return resizedImage;
}

- (UIImage*)thumbImageUsingThumbDimension:(CGFloat)thumbDimension {
	UIImage *thumbImage = nil;
	
	UIImageView *mainImageView = [[UIImageView alloc] initWithImage:self];
	
	BOOL widthGreaterThanHeight = (self.size.width > self.size.height);
	
	CGFloat sideFull = (widthGreaterThanHeight) ? self.size.height : self.size.width;
	
	CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);	

	UIGraphicsBeginImageContextWithOptions(CGSizeMake(thumbDimension, thumbDimension),
										   NO,	//MARK: to allow transparency
										   0.0);
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

- (UIImage*)maskedImageWithMaskImageName:(NSString*)maskImageName {
	UIImage *maskedImage = self;

	UIImage *maskImage = [UIImage bundledImageForName:maskImageName];
	FXDLog(@"maskImageName: %@, maskImage: %@", maskImageName, maskImage);

	if (maskImage) {
		CGImageRef maskRef = maskImage.CGImage;
		FXDLog(@"maskRef: %@", maskRef);

		CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
											CGImageGetHeight(maskRef),
											CGImageGetBitsPerComponent(maskRef),
											CGImageGetBitsPerPixel(maskRef),
											CGImageGetBytesPerRow(maskRef),
											CGImageGetDataProvider(maskRef), NULL, false);
		FXDLog(@"mask: %@", mask);

		CGImageRef masked = CGImageCreateWithMask([maskedImage CGImage], mask);
		CFRelease(mask);
		
		FXDLog(@"masked: %@", masked);

		maskedImage = [UIImage imageWithCGImage:masked];
		FXDLog(@"maskedImage: %@", maskedImage);

		CFRelease(masked);
	}

	return maskedImage;
}

- (CGSize)deviceScaledSize {
	FXDLog(@"self.size: %@", NSStringFromCGSize(self.size));

	CGSize scaledSize = CGSizeMake(self.size.width/self.scale, self.size.height /self.scale);
	FXDLog(@"scaledSize: %@", NSStringFromCGSize(scaledSize));

	return scaledSize;
}

@end
