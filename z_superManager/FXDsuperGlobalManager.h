//
//  FXDsuperGlobalManager.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#define userdefaultIntegerAppLaunchCount	@"AppLaunchCountIntegerKey"

#define dateformatDefault	@"yyyy-MM-dd HH:mm:ss:SSS"


@class FXDsuperCoreDataManager;


@interface FXDsuperGlobalManager : FXDObject {
	NSInteger _appLaunchCount;

	NSString *_mainStoryboardName;
	FXDStoryboard *_mainStoryboard;
}

@property (nonatomic, readonly) NSInteger appLaunchCount;

@property (strong, nonatomic) FXDStoryboard *mainStoryboard;
@property (strong, nonatomic) NSString *mainStoryboardName;

// Properties
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
- (void)prepareGlobalManagerWithCoreDataManager:(FXDsuperCoreDataManager*)coreDataManager withUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection withDidFinishBlock:(FXDblockDidFinish)didFinishBlock;

- (void)incrementAppLaunchCount;

- (void)configureUserDefaultsInfo;
- (void)configureGlobalAppearance;
- (void)startObservingEssentialNotifications;
#warning "//TODO: Consider adding separate analytics manager"
- (void)startUsageAnalyticsWithLaunchOptions:(NSDictionary*)launchOptions;

- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;

- (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
- (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;
- (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate;
- (NSDate*)localDateForUTCdate:(NSDate*)UTCdate;


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
@interface FXDsuperGlobalManager (MailComposing) <MFMailComposeViewControllerDelegate>

- (void)presentEmailController:(MFMailComposeViewController*)emailController forPresentingController:(UIViewController*)presentingController usingImage:(UIImage*)image usingMessage:(NSString*)message;
- (MFMailComposeViewController*)preparedMailComposeInterface;
- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message;

@end
