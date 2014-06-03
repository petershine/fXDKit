//
//  FXDmacroEssential.h
//
//
//  Created by petershine on 7/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDmacroEssential_h
#define FXDKit_FXDmacroEssential_h


#ifndef GlobalAppManager
	#warning //TODO: Must define app's own GlobalAppManager
	#define GlobalAppManager	[FXDsuperGlobalManager sharedInstance]
#endif

#ifndef application_AppStoreID
	#if	!DEBUG
		#warning //TODO: Define application_AppStoreID
	#endif

	#define application_AppStoreID	@"000000000"
#endif

#ifndef application_ContactEmail
	#if	!DEBUG
		#warning //TODO: Define application_ContactEmail
	#endif

	#define application_ContactEmail	@"app@company.com"
#endif


#ifndef application_BundleIdentifier
	#define application_BundleIdentifier	[[NSBundle mainBundle] bundleIdentifier]
#endif

#ifndef application_BundleName
	#define application_BundleName	[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#endif

#ifndef application_BundleVersion
	#define application_BundleVersion	[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#endif

#ifndef application_DisplayName
	#define application_DisplayName	[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#endif


#define iosVersion6	6.0
#define iosVersion7	7.0
#define iosVersion8	8.0

#define SYSTEM_VERSION_lowerThan(versionNumber)	([[[UIDevice currentDevice] systemVersion] floatValue] < versionNumber)

#define SCREEN_SIZE_35inch	(MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) <= height35inch)

#define DEVICE_IDIOM_iPad	(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)


#define IMPLEMENTATION_sharedInstance	static dispatch_once_t once;\
										static id _sharedInstance = nil;\
										dispatch_once(&once,^{\
											FXDLog_SEPARATE;\
											_sharedInstance = [[[self class] alloc] init];\
											FXDLogObject(_sharedInstance);\
										});\
										return _sharedInstance


#ifndef pathcomponentDocuments
	#define pathcomponentDocuments @"Documents/"
#endif

#ifndef pathcomponentCaches
	#define pathcomponentCaches	@"Caches/"
#endif

#define appSearhPath_Document	(NSString*)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define appSearhPath_Caches		(NSString*)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define appDirectory_Document	(NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
#define appDirectory_Caches		(NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]



#define NSIndexPathMake(section, row)	[NSIndexPath indexPathForRow:row inSection:section]
#define NSIndexPathString(section, row)	[NSIndexPathMake(section, row) stringValue]


#define ValueOfTime(timeStruct)		[NSValue valueWithCMTime:timeStruct]
#define ValueOfTimeRange(timeRange)	[NSValue valueWithCMTimeRange:timeRange]

#define CMTimeForMediaSeconds(mediaSeconds)	CMTimeMakeWithSeconds(mediaSeconds, doubleOneMillion)


#define degreeAngleForRadian(radian)	(radian*180.0/M_PI)
#define radianAngleForDegree(degree)	(degree*M_PI/180.0)


#define heightDynamicStatusBar	[[UIApplication sharedApplication] statusBarFrame].size.height


#endif