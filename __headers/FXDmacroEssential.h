//
//  FXDmacroEssential.h
//
//
//  Created by petershine on 7/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDmacroEssential_h
#define FXDKit_FXDmacroEssential_h


#ifndef application_AppStoreID
	#define application_AppStoreID	@"000000000"
#endif

#ifndef application_BundleIdentifier
	#define application_BundleIdentifier	[[NSBundle mainBundle] bundleIdentifier]
#endif

#ifndef application_BundleName
	#define application_BundleName	[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#endif

#ifndef application_DisplayName
	#define application_DisplayName	[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#endif

#ifndef application_ContactEmail
	#define application_ContactEmail	@"app@company.com"
#endif


#define iosVersion6	6.0
#define iosVersion7	7.0

#define SYSTEM_VERSION_lowerThan(versionNumber)	([[[UIDevice currentDevice] systemVersion] floatValue] < versionNumber)


#define SCREEN_SIZE_35inch	(MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) <= height35inch)

#define DEVICE_IDIOM_iPad	(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)


#define IMPLEMENTATION_sharedInstance	static dispatch_once_t once;\
										static id _sharedInstance = nil;\
										dispatch_once(&once,^{\
											_sharedInstance = [[self class] new];\
										});\
										return _sharedInstance


#ifndef pathcomponentDocuments
	#define pathcomponentDocuments @"Documents/"
#endif

#ifndef pathcomponentCaches
	#define pathcomponentCaches	@"Caches/"
#endif

#define appSearhPath_Document	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define appSearhPath_Caches		[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define appDirectory_Document	[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
#define appDirectory_Caches		[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]



#define userdefaultIntegerAppLaunchCount			@"AppLaunchCountIntegerKey"
#define userdefaultIntegerLastUpgradedAppVersion	@"LastUpgradedAppVersionIntegerKey"

#define dateformatDefault	@"yyyy-MM-dd HH:mm:ss:SSS"



#define NSIndexPathMake(section, row)	[NSIndexPath indexPathForRow:row inSection:section]
#define NSIndexPathString(section, row)	[NSIndexPathMake(section, row) stringValue]


#endif