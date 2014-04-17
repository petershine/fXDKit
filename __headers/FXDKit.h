//
//  FXDKit.h
//
//
//  Created by petershine on 12/28/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDKit_h
#define FXDKit_FXDKit_h


#pragma mark - Types
typedef void (^FXDcallbackFinish)(SEL caller, BOOL finished, id responseObj);

typedef void (^FXDcallbackAlert)(id alertObj, NSInteger buttonIndex);

typedef NS_ENUM(NSInteger, FILE_KIND_TYPE) {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie
};


#pragma mark - Headers
#import "FXDnumericalValues.h"
#import "FXDlocalizedStrings.h"
#import "FXDimageNames.h"

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


@interface NSDate (Added)
+ (NSString*)shortUTCdateStringForLocalDate:(NSDate*)localDate;
+ (NSString*)shortLocalDateStringForUTCdate:(NSDate*)UTCdate;

- (NSInteger)yearValue;
- (NSInteger)monthValue;
- (NSInteger)dayValue;

- (NSString*)shortMonthString;
- (NSString*)weekdayString;

- (NSInteger)hourValue;
- (NSInteger)minuteValue;
- (NSInteger)secondValue;

- (BOOL)isYearMonthDaySameAsAnotherDate:(NSDate*)anotherDate;
@end


@interface NSOperationQueue (Added)
+ (instancetype)newSerialQueue;
@end


@interface UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue;
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(CGFloat)alpha;
+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha;
@end


@interface UIBarButtonItem (Added)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage;
@end


@interface UITextField (Added)
- (CATextLayer*)textLayer;
@end


@interface UIApplication (Added)
- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;
@end


@interface UIScreen (Added)
+ (CGRect)screenBoundsForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


#if USE_MultimediaFrameworks
@interface UIDevice (Added)
- (CGAffineTransform)affineTransformForOrientation;
- (CGAffineTransform)affineTransformForOrientationAndForPosition:(AVCaptureDevicePosition)cameraPosition;
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition;
@end
#endif


#endif
