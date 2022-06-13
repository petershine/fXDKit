
#import <fXDObjC/FXDimportEssential.h>

#define userdefaultIntegerAppLaunchCount			@"AppLaunchCountIntegerKey"
#define userdefaultIntegerLastUpgradedAppVersion	@"LastUpgradedAppVersionIntegerKey"

#define dateformatDefault	@"yyyy-MM-dd HH:mm:ss:SSS"


@interface FXDmoduleGlobal : NSObject {
	NSInteger _appLaunchCount;

	NSString *_mainStoryboardName;
	UIStoryboard *_mainStoryboard;
}

@property (nonatomic, readonly) NSInteger appLaunchCount;

@property (strong, nonatomic) NSString * _Nullable mainStoryboardName;
@property (strong, nonatomic) UIStoryboard * _Nullable mainStoryboard;

@property (strong, nonatomic) NSString * _Nullable deviceLanguageCode;
@property (strong, nonatomic) NSString * _Nullable deviceCountryCode;
@property (strong, nonatomic) NSString * _Nullable deviceModelName;

@property (strong, nonatomic) NSNumber * _Nullable isDevice_iPhoneFour;
@property (strong, nonatomic) NSNumber * _Nullable isDevice_iPhoneSix;

@property (strong, nonatomic) NSDateFormatter * _Nullable dateformatterUTC;
@property (strong, nonatomic) NSDateFormatter * _Nullable dateformatterLocal;


@property (strong, nonatomic) id _Nullable initialScene;


- (void)prepareGlobalModuleWithCallback:(FXDcallbackFinish _Nullable )callback;

- (void)incrementAppLaunchCount;

- (void)configureUserDefaultsInfo;
- (void)configureGlobalAppearance;

- (void)startUsageAnalyticsWithLaunchOptions:(NSDictionary*_Nullable)launchOptions;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL shouldUpgradeForNewAppVersion;
- (BOOL)isLastVersionOlderThanVersionInteger:(NSInteger)versionInteger;
- (void)updateLastUpgradedAppVersionAfterLaunch;

- (void)shouldAlertAboutCurrentVersionForAppStoreID:(NSString*_Nullable)appStoreID withCallback:(FXDcallbackFinish _Nullable )finishCallback;

- (NSString*_Nullable)UTCdateStringForLocalDate:(NSDate*_Nullable)localDate;
- (NSDate*_Nullable)UTCdateForLocalDate:(NSDate*_Nullable)localDate;
- (NSString*_Nullable)localDateStringForUTCdate:(NSDate*_Nullable)UTCdate;
- (NSDate*_Nullable)localDateForUTCdate:(NSDate*_Nullable)UTCdate;

@end

