//
//  FXDconfigAdopted.h
//
//
//  Created by petershine on 1/13/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDconfigAdopted_h
#define FXDKit_FXDconfigAdopted_h


#ifndef USE_ReactiveCocoa
	#define	USE_ReactiveCocoa	1
#endif

#ifndef USE_AFNetworking
	#define USE_AFNetworking	1
#endif

#if USE_ReactiveCocoa	//https://github.com/ReactiveCocoa/ReactiveCocoa
	#import <ReactiveCocoa.h>
	#import <RACEXTScope.h>
#endif

#if USE_AFNetworking	//https://github.com/AFNetworking/AFNetworking
	#import <AFNetworking.h>
	#import <UIKit+AFNetworking.h>
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

	#import "FXDAnnotation.h"
	#import "FXDAnnotationView.h"
	#import "FXDMapView.h"
#endif

#if USE_MultimediaFrameworks
	@import CoreMedia;
	@import CoreVideo;
	@import CoreGraphics;
	@import OpenGLES;

	@import AssetsLibrary;
	@import AVFoundation;

	@import MediaPlayer;
	@import MediaToolbox;

	#import "FXDMediaItem.h"
#endif


#if USE_UAAppReviewManager	//https://github.com/UrbanApps/UAAppReviewManager
	#import <UAAppReviewManager.h>
#endif


#endif
