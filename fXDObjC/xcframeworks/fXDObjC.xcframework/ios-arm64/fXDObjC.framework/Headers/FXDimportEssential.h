

#ifndef FXDKit_FXDimportEssential_h
#define FXDKit_FXDimportEssential_h


#import <objc/runtime.h>
#import <stdarg.h>
#import <sys/utsname.h>

#import <Availability.h>
#import <TargetConditionals.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreServices/CoreServices.h>

#import <CoreData/CoreData.h>

#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>

#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>


#import <fXDObjC/FXDconfigDeveloper.h>

#import <fXDObjC/FXDmacroValue.h>
#import <fXDObjC/FXDmacroFunction.h>

#import <fXDObjC/FXDNumber.h>
#import <fXDObjC/FXDString.h>
#import <fXDObjC/FXDURL.h>


typedef void (^FXDcallbackFinish)(SEL caller, BOOL didFinish, id responseObj);


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
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation;
@end


@interface UILabel (Essential)
- (void)applyShadowColor:(UIColor*)shadowColor;
- (void)attributeColor:(UIColor*)attributedColor forSubstring:(NSString*)substring;
- (void)attributeUnderlineAndColor:(UIColor*)attributedColor forSubstring:(NSString*)substring;
@end


#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CLLocation (LocationFrameworks)
- (NSString*)formattedDistanceTextFromLocation:(CLLocation*)location;
@end


#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <OpenGLES/OpenGLESAvailability.h>	// OpenGLES is deprecated. Consider migrating to Metal instead.
#import <Metal/Metal.h>

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import <MediaPlayer/MediaPlayer.h>
#import <MediaToolbox/MediaToolbox.h>

@interface CALayer (MultimediaFrameworks)
- (void)applyFadeInOutWithFadeInTime:(CFTimeInterval)fadeInTime withFadeOutTime:(CFTimeInterval)fadeOutTime withDuration:(CFTimeInterval)duration;
@end

@interface NSURL (MultimediaFrameworks)
+ (NSURL*)uniqueMovieFileURLwithPrefix:(NSString*)prefix atDirectory:(NSString*)directory;
@end

@interface UIDevice (MultimediaFrameworks)
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition;
@end

@interface AVAudioSession (MultimediaFrameworks)
- (void)enableAudioPlaybackCategory;
- (void)disableAudioPlaybackCategory;
@end


#endif
