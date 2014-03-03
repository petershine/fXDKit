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


@import Accelerate;
//#import <float.h>

@implementation UIImage (ImageEffects)


- (UIImage *)applyLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyExtraLightEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyDarkEffect
{
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    int componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    }
    else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }

    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;

    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);

        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
				0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);

    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);

    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }

    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }

    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
}

@end
