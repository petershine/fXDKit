//
//  FXDimportAdopted.h
//
//
//  Created by petershine on 1/13/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDimportAdopted_h
#define FXDKit_FXDimportAdopted_h


#ifndef USE_ReactiveCocoa
	#warning //TODO: Decide if ReactiveCocoa is used
	#define	USE_ReactiveCocoa	FALSE
#endif

#ifndef USE_AFNetworking
	#warning //TODO: Decide if AFNetworking is used
	#define USE_AFNetworking	FALSE
#endif

#ifndef USE_GPUImage
	#warning //TODO: Decide if GPUImage is used
	#define USE_GPUImage	FALSE
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


#if USE_AdvertisementFrameworks
	@import iAd;
	@import AdSupport;
#endif

#if USE_SocialFrameworks
	@import MessageUI;
	@import Accounts;
	@import Social;
#endif

#if USE_LocationFrameworks
	@import CoreLocation;
	@import MapKit;

	#import "FXDMapView.h"
	#import "FXDAnnotationView.h"
	#import "FXDsuperGeoManager.h"
#endif

#if USE_MultimediaFrameworks
	@import CoreMedia;
	@import CoreVideo;
	@import OpenGLES;

	@import AVFoundation;
	@import AssetsLibrary;

	@import MediaPlayer;
	@import MediaToolbox;

	#import "FXDMediaItem.h"


	#ifndef filetypeVideoDefault
		#define filetypeVideoDefault AVFileTypeQuickTimeMovie
	#endif

@interface CALayer (MultimediaFrameworks)
- (void)applyFadeInOutWithFadeInTime:(CFTimeInterval)fadeInTime withFadeOutTime:(CFTimeInterval)fadeOutTime withDuration:(CFTimeInterval)duration;
@end

@interface NSURL (MultimediaFrameworks)
+ (NSURL*)uniqueMovieFileURLwithPrefix:(NSString*)prefix;
@end

@interface UIDevice (MultimediaFrameworks)
- (CGAffineTransform)affineTransformForOrientation:(UIDeviceOrientation)deviceOrientation forPosition:(AVCaptureDevicePosition)cameraPosition;
@end

@interface AVCaptureDevice (MultimediaFrameworks)
+ (AVCaptureDevice*)videoCaptureDeviceFoPosition:(AVCaptureDevicePosition)cameraPosition withFlashMode:(AVCaptureFlashMode)flashMode;
- (void)applyDefaultConfigurationWithFlashMode:(AVCaptureFlashMode)flashMode;
- (void)addDefaultNotificationObserver:(id)observer;
@end

@interface ALAsset (MultimediaFrameworks)
- (id)valueForKey:(NSString *)key;
@end

#endif


#endif
