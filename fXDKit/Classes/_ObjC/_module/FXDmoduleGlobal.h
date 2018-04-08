

#define userdefaultIntegerAppLaunchCount			@"AppLaunchCountIntegerKey"
#define userdefaultIntegerLastUpgradedAppVersion	@"LastUpgradedAppVersionIntegerKey"

#define dateformatDefault	@"yyyy-MM-dd HH:mm:ss:SSS"


@class FXDmoduleCoredata;


#import "FXDsuperModule.h"
@interface FXDmoduleGlobal : FXDsuperModule {
	NSInteger _appLaunchCount;

	NSString *_mainStoryboardName;
	UIStoryboard *_mainStoryboard;
}

@property (nonatomic, readonly) NSInteger appLaunchCount;

@property (strong, nonatomic) NSString *mainStoryboardName;
@property (strong, nonatomic) UIStoryboard *mainStoryboard;

@property (strong, nonatomic) NSString *deviceLanguageCode;
@property (strong, nonatomic) NSString *deviceCountryCode;
@property (strong, nonatomic) NSString *deviceModelName;

@property (strong, nonatomic) NSNumber *isDevice_iPhoneFour;
@property (strong, nonatomic) NSNumber *isDevice_iPhoneSix;

@property (strong, nonatomic) NSDateFormatter *dateformatterUTC;
@property (strong, nonatomic) NSDateFormatter *dateformatterLocal;


@property (strong, nonatomic) id initialScene;


- (void)prepareGlobalModuleWithCallback:(FXDcallbackFinish)finishCallback;

- (void)incrementAppLaunchCount;

- (void)configureUserDefaultsInfo;
- (void)configureGlobalAppearance;

- (void)startUsageAnalyticsWithLaunchOptions:(NSDictionary*)launchOptions;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL shouldUpgradeForNewAppVersion;
- (BOOL)isLastVersionOlderThanVersionInteger:(NSInteger)versionInteger;
- (void)updateLastUpgradedAppVersionAfterLaunch;

- (void)shouldAlertAboutCurrentVersionForAppStoreID:(NSString*)appStoreID withCallback:(FXDcallbackFinish)finishCallback;

- (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
- (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;
- (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate;
- (NSDate*)localDateForUTCdate:(NSDate*)UTCdate;

@end

