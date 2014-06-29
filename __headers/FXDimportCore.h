//
//  FXDimportCore.h
//
//
//  Created by petershine on 3/22/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDimportCore_h
#define FXDKit_FXDimportCore_h

#import <objc/runtime.h>
#import <stdarg.h>
#import <sys/utsname.h>

#import <Availability.h>
#import <TargetConditionals.h>

@import UIKit;
@import Foundation;

@import SystemConfiguration;
@import MobileCoreServices;

@import CoreGraphics;
@import CoreImage;

@import QuartzCore;
@import ImageIO;

@import MessageUI;
@import Accounts;
@import Social;


#pragma mark - Callbacks
typedef void (^FXDcallbackFinish)(SEL caller, BOOL didFinish, id responseObj);
typedef void (^FXDcallbackAlert)(id alertObj, NSInteger buttonIndex);


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
+ (UIWindow*)mainWindow;

- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;
@end


@interface UIScreen (Added)
+ (CGRect)screenBoundsForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


@interface UIDevice (Added)
+ (UIDeviceOrientation)validDeviceOrientation;
+ (CGAffineTransform)forcedTransformForDeviceOrientation;
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


#pragma mark - Objects
#import "FXDString.h"
#import "FXDURL.h"
#import "FXDNumber.h"
#import "FXDDate.h"

#import "FXDImage.h"

#import "FXDCollectionViewLayout.h"

#import "FXDStoryboardSegue.h"
#import "FXDStoryboard.h"

#import "FXDFetchedResultsController.h"
#import "FXDManagedDocument.h"
#import "FXDManagedObject.h"
#import "FXDManagedObjectContext.h"

#import "FXDFileManager.h"

#import "FXDMetadataQuery.h"

#import "FXDOperationQueue.h"


#pragma mark - Views
#import "FXDView.h"
#import "FXDWindow.h"

#import "FXDButton.h"
#import "FXDTextView.h"
#import "FXDImageView.h"
#import "FXDTableViewCell.h"
#import "FXDCollectionViewCell.h"

#import "FXDAlertView.h"
#import "FXDActionSheet.h"

#import "FXDScrollView.h"

#import "FXDPopoverBackgroundView.h"


#pragma mark - ViewControllers
#import "FXDViewController.h"
#import "FXDNavigationController.h"


#pragma mark - Global controllers
#import "FXDResponder.h"

#endif
