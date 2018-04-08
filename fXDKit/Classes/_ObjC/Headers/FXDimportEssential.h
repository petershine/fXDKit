

#ifndef FXDKit_FXDimportEssential_h
#define FXDKit_FXDimportEssential_h


@import UIKit;
@import Foundation;

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

@import UserNotifications;
@import UserNotificationsUI;


typedef void (^FXDcallbackFinish)(SEL caller, BOOL didFinish, id responseObj);


#pragma mark - Categories
@interface NSNumberFormatter (Grouping)
+ (NSNumberFormatter*)formatterGroupingSize:(NSInteger)groupingSize separator:(NSString*)separator;
@end


//http://stackoverflow.com/a/23925044/259765
@interface NSDictionary (NullCleaning)
+ (NSDictionary *)cleanNullInJsonDic:(NSDictionary *)dic;
+ (NSArray *)cleanNullInJsonArray:(NSArray *)array;
@end


@interface NSError (Essential)
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *essentialParameters;
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
- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;
@end


@interface UIScreen (Essential)
+ (CGRect)screenBoundsForOrientation:(UIDeviceOrientation)deviceOrientation;
+ (CGRect)screenBoundsForLandscape:(BOOL)isForLanscape;

+ (CGFloat)maximumScreenDimension;
+ (CGFloat)minimumScreenDimension;

@end


@interface UIDevice (Essential)
#if TARGET_APP_EXTENSION
#else
+ (UIDeviceOrientation)validDeviceOrientation;
#endif
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


@interface UILabel (Essential)
- (void)applyShadowColor:(UIColor*)shadowColor;
- (void)attributeColor:(UIColor*)attributedColor forSubstring:(NSString*)substring;
- (void)attributeUnderlineAndColor:(UIColor*)attributedColor forSubstring:(NSString*)substring;
@end


#endif
