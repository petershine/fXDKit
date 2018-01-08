

#ifndef FXDKit_FXDimportAdopted_h
#define FXDKit_FXDimportAdopted_h


#ifndef USE_ReactiveCocoa
	#define	USE_ReactiveCocoa	FALSE
#endif

#ifndef USE_AFNetworking
	#define USE_AFNetworking	FALSE
#endif

#ifndef USE_GPUImage
	#define USE_GPUImage	FALSE
#endif

#ifndef USE_LocationFrameworks
	#define USE_LocationFrameworks	FALSE
#endif

#ifndef USE_MultimediaFrameworks
	#define USE_MultimediaFrameworks	FALSE
#endif

#ifndef USE_SocialFrameworks
	#define USE_SocialFrameworks	FALSE
#endif


#if USE_ReactiveCocoa	//https://github.com/ReactiveCocoa/ReactiveCocoa
	#import <ReactiveCocoa.h>
	#import <RACEXTScope.h>
#endif

#if USE_AFNetworking	//https://github.com/AFNetworking/AFNetworking
	#import <AFNetworking.h>
	#import <UIKit+AFNetworking.h>
#endif

#if USE_GPUImage	//https://github.com/BradLarson/GPUImage
	#import <GPUImage.h>
#endif

#if USE_SocialFrameworks
	#import <FBSDKCoreKit/FBSDKCoreKit.h>
	#import <FBSDKLoginKit/FBSDKLoginKit.h>
	#import <FBSDKShareKit/FBSDKShareKit.h>
	#import <TwitterKit/TWTRTwitter.h>
#endif


#if USE_LocationFrameworks
	@import CoreLocation;
	@import MapKit;

	@interface CLLocation (LocationFrameworks)
	- (NSString*)formattedDistanceTextFromLocation:(CLLocation*)location;
	@end

	#import "FXDMapView.h"
	#import "FXDAnnotationView.h"
#endif


#if USE_MultimediaFrameworks
	@import CoreMedia;
	@import CoreVideo;
	@import OpenGLES;

	@import AVFoundation;
	@import AssetsLibrary;

	@import MediaPlayer;
	@import MediaToolbox;


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


#endif
