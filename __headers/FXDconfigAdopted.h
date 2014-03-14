//
//  FXDconfigAdopted.h
//
//
//  Created by petershine on 1/13/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDconfigAdopted_h
#define FXDKit_FXDconfigAdopted_h


#ifndef USE_ExtraFrameworks
	#define USE_ExtraFrameworks	0
#endif

#if USE_ExtraFrameworks
	@import MessageUI;
	@import Accounts;
	@import Social;

	@import MapKit;
	@import MediaPlayer;

	@import AssetsLibrary;
	@import AVFoundation;

	@import AdSupport;

	#import "FXDMediaItem.h"

	#import "FXDAnnotation.h"
	#import "FXDAnnotationView.h"
	#import "FXDMapView.h"

#endif


#ifndef USE_ReactiveCocoa
	#define	USE_ReactiveCocoa	1
#endif

#ifndef USE_AFNetworking
	#define USE_AFNetworking	1
#endif

#ifndef USE_UAAppReviewManager
	#define	USE_UAAppReviewManager	0
#endif


#if USE_ReactiveCocoa	//https://github.com/ReactiveCocoa/ReactiveCocoa
	#import <ReactiveCocoa.h>
	#import <RACEXTScope.h>
#endif

#if USE_AFNetworking	//https://github.com/AFNetworking/AFNetworking
	#import <AFNetworking.h>
	#import <UIKit+AFNetworking.h>
#endif

#if USE_UAAppReviewManager	//https://github.com/UrbanApps/UAAppReviewManager
	#import <UAAppReviewManager.h>
#endif


#endif
