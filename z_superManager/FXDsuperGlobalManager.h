//
//  FXDsuperGlobalManager.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//


@class FXDsuperMainCoredata;


@interface FXDsuperGlobalManager : FXDObject {
	NSInteger _appLaunchCount;
	BOOL _isDeviceOld;

	NSString *_mainStoryboardName;
	FXDStoryboard *_mainStoryboard;

	NSArray *_oldDeviceArray;
}

@property (nonatomic, readonly) NSInteger appLaunchCount;
@property (assign, nonatomic) BOOL isDeviceOld;

@property (strong, nonatomic) FXDStoryboard *mainStoryboard;
@property (strong, nonatomic) NSString *mainStoryboardName;

// Properties
@property (strong, nonatomic, readonly) NSArray *oldDeviceArray;

@property (strong, nonatomic) NSString *deviceLanguageCode;
@property (strong, nonatomic) NSString *deviceCountryCode;
@property (strong, nonatomic) NSString *deviceModelName;

@property (strong, nonatomic) NSDateFormatter *dateformatterUTC;
@property (strong, nonatomic) NSDateFormatter *dateformatterLocal;

@property (strong, nonatomic) id rootController;
@property (strong, nonatomic) id homeController;


#pragma mark - Public
+ (FXDsuperGlobalManager*)sharedInstance;

- (void)prepareGlobalManagerAtLaunchWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;
- (void)prepareGlobalManagerWithMainCoredata:(FXDsuperMainCoredata*)mainCoredata withUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)incrementAppLaunchCount;

- (void)configureUserDefaultsInfo;
- (void)configureGlobalAppearance;
- (void)startObservingEssentialNotifications;

- (void)startUsageAnalyticsWithLaunchOptions:(NSDictionary*)launchOptions;

- (BOOL)shouldUpgradeForNewAppVersion;
- (BOOL)isLastVersionOlderThanVersionInteger:(NSInteger)versionInteger;
- (void)updateLastUpgradedAppVersionAfterLaunch;

- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;


- (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
- (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;
- (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate;
- (NSDate*)localDateForUTCdate:(NSDate*)UTCdate;


- (CGAffineTransform)affineTransformForDeviceOrientation;
- (CGAffineTransform)affineTransformForDeviceOrientationForCameraDirection:(UIImagePickerControllerCameraDevice)cameraDirection;
- (CGAffineTransform)affineTransformForDeviceOrientation:(UIDeviceOrientation)deviceOrientation forCameraDirection:(UIImagePickerControllerCameraDevice)cameraDirection;


- (CGRect)screenFrameForDeviceOrientation;
- (AVCaptureVideoOrientation)videoOrientationForDeviceOrientation;


//MARK: - Observer implementation
- (void)observedUIApplicationWillChangeStatusBarFrame:(NSNotification*)notification;
- (void)observedUIApplicationDidChangeStatusBarFrame:(NSNotification*)notification;

- (void)observedUIApplicationWillResignActive:(NSNotification*)notification;
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationWillEnterForeground:(NSNotification*)notification;
- (void)observedUIApplicationDidBecomeActive:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;
- (void)observedUIApplicationSignificantTimeChange:(NSNotification*)notification;

- (void)observedNSUserDefaultsDidChange:(NSNotification*)notification;

- (void)observedUIDeviceBatteryStateDidChange:(NSNotification*)notification;
- (void)observedUIDeviceBatteryLevelDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#pragma mark - Category
#if USE_ExtraFrameworks
@interface FXDsuperGlobalManager (MailComposing) <MFMailComposeViewControllerDelegate>

- (void)presentEmailController:(MFMailComposeViewController*)emailController forPresentingController:(UIViewController*)presentingController usingImage:(UIImage*)image usingMessage:(NSString*)message;
- (MFMailComposeViewController*)preparedMailComposeInterface;
- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message;
@end
#endif
