
#import "FXDKit.h"


#define userdefaultIntegerAppLaunchCount			@"AppLaunchCountIntegerKey"
#define userdefaultIntegerLastUpgradedAppVersion	@"LastUpgradedAppVersionIntegerKey"

#define dateformatDefault	@"yyyy-MM-dd HH:mm:ss:SSS"


@class FXDmoduleCoredata;


@interface FXDmoduleGlobal : FXDsuperModule {
	NSInteger _appLaunchCount;
	BOOL _isDeviceOld;

	NSString *_mainStoryboardName;
	UIStoryboard *_mainStoryboard;

	NSArray *_oldDeviceArray;
}

@property (nonatomic, readonly) NSInteger appLaunchCount;
@property (nonatomic) BOOL isDeviceOld;

@property (strong, nonatomic) NSString *mainStoryboardName;
@property (strong, nonatomic) UIStoryboard *mainStoryboard;

@property (strong, nonatomic, readonly) NSArray *oldDeviceArray;

@property (strong, nonatomic) NSString *deviceLanguageCode;
@property (strong, nonatomic) NSString *deviceCountryCode;
@property (strong, nonatomic) NSString *deviceModelName;

@property (strong, nonatomic) NSDateFormatter *dateformatterUTC;
@property (strong, nonatomic) NSDateFormatter *dateformatterLocal;

@property (strong, nonatomic) id initialScene;
@property (strong, nonatomic) id homeScene;


- (void)prepareGlobalManagerAtLaunchWithFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)prepareGlobalManagerWithMainCoredata:(FXDmoduleCoredata*)mainCoredata withUbiquityContainerURL:(NSURL*)ubiquityContainerURL withCompleteProtection:(BOOL)withCompleteProtection withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)incrementAppLaunchCount;

- (void)configureUserDefaultsInfo;
- (void)configureGlobalAppearance;
- (void)startObservingEssentialNotifications;

- (void)startUsageAnalyticsWithLaunchOptions:(NSDictionary*)launchOptions;

- (BOOL)shouldUpgradeForNewAppVersion;
- (BOOL)isLastVersionOlderThanVersionInteger:(NSInteger)versionInteger;
- (void)updateLastUpgradedAppVersionAfterLaunch;


- (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
- (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;
- (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate;
- (NSDate*)localDateForUTCdate:(NSDate*)UTCdate;


#pragma mark - Observer
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

#pragma mark - Delegate

@end

