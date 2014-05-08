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
	#define	USE_ReactiveCocoa	TRUE
#endif

#ifndef USE_AFNetworking
	#define USE_AFNetworking	TRUE
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
	#import "FXDsuperGeoManager.h"
#endif

#if USE_MultimediaFrameworks
	@import CoreMedia;
	@import CoreVideo;
	@import CoreGraphics;
	@import OpenGLES;

	@import AVFoundation;

	@import MediaPlayer;
	@import MediaToolbox;

	#import "FXDMediaItem.h"
#endif


#endif
