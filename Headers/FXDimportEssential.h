

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


#pragma mark - Callbacks
typedef void (^FXDcallbackFinish)(SEL caller, BOOL didFinish, id responseObj);
typedef void (^FXDcallbackAlert)(id alertObj, NSInteger buttonIndex);


#pragma mark - Categories

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
+ (CGAffineTransform)forcedTransformForDeviceOrientation;
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


#endif
