//
//  FXDKit.h
//
//
//  Created by petershine on 12/28/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDKit_h
#define FXDKit_FXDKit_h


#pragma mark - Headers
#import "FXDdefinedTypes.h"
#import "FXDnumericalValues.h"
#import "FXDlocalizedStrings.h"

#import "FXDmacroEssential.h"

#import "FXDconfigAnalytics.h"
#import "FXDconfigDeveloper.h"


#import "FXDimportCore.h"
#import "FXDimportAdopted.h"


#pragma mark - Categories
@interface NSIndexPath (Added)
- (NSString*)stringValue;
@end


@interface NSError (Added)
- (NSDictionary*)essentialParameters;
@end


@interface NSOperationQueue (Added)
+ (instancetype)newSerialQueue;
@end


#if USE_MultimediaFrameworks
@interface CALayer (Added)
- (void)applyFadeInOutWithFadeInTime:(CFTimeInterval)fadeInTime withFadeOutTime:(CFTimeInterval)fadeOutTime withDuration:(CFTimeInterval)duration;
@end
#endif

@interface CATextLayer (Added)
+ (instancetype)newTextLayerFromTextControl:(id)textControl forRenderingScale:(CGFloat)renderingScale;
@end


@interface UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue;
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(CGFloat)alpha;
+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha;
@end


@interface UIBarButtonItem (Added)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage;
@end


@interface UIApplication (Added)
- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;
@end


@interface UIScreen (Added)
+ (CGRect)screenBoundsForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


@interface UIDevice (Added)
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation;

#if USE_MultimediaFrameworks
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition;
#endif
@end


#endif
