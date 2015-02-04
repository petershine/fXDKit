
#import "FXDKit.h"


#define userdefaultIntegerAppLaunchCount			@"AppLaunchCountIntegerKey"
#define userdefaultIntegerLastUpgradedAppVersion	@"LastUpgradedAppVersionIntegerKey"

#define dateformatDefault	@"yyyy-MM-dd HH:mm:ss:SSS"


@class FXDmoduleCoredata;


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

#warning //TODO: Evaluate necessity of properties
@property (strong, nonatomic) id initialScene;
@property (strong, nonatomic) id homeScene;


- (void)prepareGlobalModuleWithCallback:(FXDcallbackFinish)callback;

- (void)incrementAppLaunchCount;

- (void)configureUserDefaultsInfo;
- (void)configureGlobalAppearance;

- (void)startUsageAnalyticsWithLaunchOptions:(NSDictionary*)launchOptions;

- (BOOL)shouldUpgradeForNewAppVersion;
- (BOOL)isLastVersionOlderThanVersionInteger:(NSInteger)versionInteger;
- (void)updateLastUpgradedAppVersionAfterLaunch;


- (NSString*)UTCdateStringForLocalDate:(NSDate*)localDate;
- (NSDate*)UTCdateForLocalDate:(NSDate*)localDate;
- (NSString*)localDateStringForUTCdate:(NSDate*)UTCdate;
- (NSDate*)localDateForUTCdate:(NSDate*)UTCdate;


#if USE_MultimediaFrameworks
- (void)enableAudioPlaybackCategory;
- (void)disableAudioPlaybackCategory;
#endif

@end

