

#ifndef FXDKit_FXDimportAdopted_h
#define FXDKit_FXDimportAdopted_h


#if USE_ReactiveCocoa	//https://github.com/ReactiveCocoa/ReactiveCocoa
	#import <ReactiveCocoa.h>
	#import <RACEXTScope.h>
#endif

#if USE_AFNetworking	//https://github.com/AFNetworking/AFNetworking
	#import <AFNetworking.h>
	#import <UIImageView+AFNetworking.h>
#endif

#if USE_GPUImage	//https://github.com/BradLarson/GPUImage
	#import <GPUImage.h>
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
#endif


#import "FXDKit.h"


#endif
