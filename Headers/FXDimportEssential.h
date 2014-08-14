

#ifndef FXDKit_FXDimportEssential_h
#define FXDKit_FXDimportEssential_h

#import <objc/runtime.h>
#import <stdarg.h>
#import <sys/utsname.h>

#import <Availability.h>
#import <TargetConditionals.h>


@import SystemConfiguration;
@import MobileCoreServices;

@import CoreData;

@import CoreGraphics;
@import CoreImage;

@import QuartzCore;
@import ImageIO;

@import MessageUI;
@import Accounts;
@import Social;

#import "FXDKit.h"


@interface NSError (Essential)
- (NSDictionary*)essentialParameters;
@end


@interface NSFetchedResultsController (Essential)
- (NSManagedObject*)resultObjForAttributeKey:(NSString*)attributeKey andForAttributeValue:(id)attributeValue;
- (NSManagedObject*)resultObjForPredicate:(NSPredicate*)predicate;
@end


@interface CATextLayer (Essential)
+ (instancetype)newTextLayerFromTextControl:(id)textControl forRenderingScale:(CGFloat)renderingScale;
@end


@interface UIColor (Essential)
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue;
+ (UIColor*)colorUsingIntegersForRed:(NSInteger)red forGreen:(NSInteger)green forBlue:(NSInteger)blue forAlpha:(CGFloat)alpha;
+ (UIColor*)colorUsingHEX:(NSInteger)rgbValue forAlpha:(CGFloat)alpha;
@end


@interface UIStoryboard (Essential)
+ (UIStoryboard*)storyboardWithDefaultName;
@end


@interface UIBarButtonItem (Essential)
- (void)customizeWithNormalImage:(UIImage*)normalImage andWithHighlightedImage:(UIImage*)highlightedImage;
@end


@interface UIApplication (Essential)
+ (UIWindow*)mainWindow;

- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;
@end


@interface UIScreen (Essential)
+ (CGRect)screenBoundsForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


@interface UIDevice (Essential)
+ (UIDeviceOrientation)validDeviceOrientation;
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


#endif
