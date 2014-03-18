//
//  FXDKit.h
//
//
//  Created by petershine on 12/28/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDKit_h
#define FXDKit_FXDKit_h

#import <objc/runtime.h>
#import <stdarg.h>
#import <sys/utsname.h>

#import <Availability.h>
#import <TargetConditionals.h>

@import Foundation;
@import UIKit;

@import SystemConfiguration;
@import MobileCoreServices;

@import CoreData;
@import QuartzCore;
@import ImageIO;


#pragma mark - Headers
#import "FXDenumTypes.h"
#import "FXDnumericalValues.h"
#import "FXDlocalizedStrings.h"
#import "FXDimageNames.h"

#import "FXDmacroEssential.h"

#import "FXDconfigAnalytics.h"
#import "FXDconfigDeveloper.h"


#pragma mark - Adopted
#import "FXDconfigAdopted.h"


#pragma mark - Objects
#import "FXDObject.h"

#import "FXDString.h"
#import "FXDURL.h"
#import "FXDNumber.h"

#import "FXDImage.h"

#import "FXDCollectionViewLayout.h"

#import "FXDStoryboardSegue.h"
#import "FXDStoryboard.h"

#import "FXDManagedDocument.h"

#import "FXDManagedObject.h"
#import "FXDFetchedResultsController.h"
#import "FXDManagedObjectContext.h"

#import "FXDFileManager.h"

#import "FXDMetadataQuery.h"


#pragma mark - Views
#import "FXDView.h"

#import "FXDButton.h"
#import "FXDTextView.h"
#import "FXDImageView.h"
#import "FXDTableViewCell.h"
#import "FXDCollectionViewCell.h"
#import "FXDLabel.h"

#import "FXDAlertView.h"
#import "FXDActionSheet.h"

#import "FXDScrollView.h"
#import "FXDCollectionView.h"

#import "FXDWindow.h"

#import "FXDPopoverBackgroundView.h"


#pragma mark - ViewControllers
#import "FXDViewController.h"
#import "FXDNavigationController.h"
#import "FXDPopoverController.h"
#import "FXDPageViewController.h"


#pragma mark - Global controllers
#import "FXDResponder.h"


#endif


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


@interface UIColor (Added)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue;
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(CGFloat)alpha;
+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha;	// Use 0xFF0000 type
@end


@interface UIBarButtonItem (Added)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage;
@end


@interface UIApplication (Added)
- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;
@end


#if USE_MultimediaFrameworks
@interface UIDevice (Added)
- (CGAffineTransform)affineTransformForOrientation;
- (CGAffineTransform)affineTransformForOrientationAndForPosition:(AVCaptureDevicePosition)cameraPosition;
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition;

- (CGRect)screenFrameForOrientation;
- (CGRect)screenFrameForOrientation:(UIDeviceOrientation)deviceOrientation;
@end

#endif

