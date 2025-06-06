

#import "FXDmoduleGlobal.h"


@implementation FXDmoduleGlobal

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSInteger)appLaunchCount {
	_appLaunchCount = [[NSUserDefaults standardUserDefaults] integerForKey:userdefaultIntegerAppLaunchCount];
	
	return _appLaunchCount;
}

#pragma mark -
- (UIStoryboard*)mainStoryboard {
	if (_mainStoryboard == nil) {
		if (self.mainStoryboardName) {
			NSBundle *resourceBundle = [NSBundle bundleForClass:NSClassFromString(self.mainStoryboardName)];
			_mainStoryboard = [UIStoryboard storyboardWithName:self.mainStoryboardName bundle:resourceBundle];
		}
	}

	if (_mainStoryboard == nil) {	FXDLog_OVERRIDE;
	}
	return _mainStoryboard;
}

- (NSString*)mainStoryboardName {
	if (_mainStoryboardName == nil) {	FXDLog_OVERRIDE;
	}
	return _mainStoryboardName;
}

#pragma mark -
- (NSString*)deviceLanguageCode {
	if (_deviceLanguageCode == nil) {	FXDLog_DEFAULT
		NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
		
		_deviceLanguageCode = languages.firstObject;
		
		if ([_deviceLanguageCode isEqualToString:@"zh-Hans"]) {
			_deviceLanguageCode = @"ch";
		}
		else if ([_deviceLanguageCode isEqualToString:@"zh-Hant"]) {
			_deviceLanguageCode = @"tw";
		}
		
		FXDLog(@"1.%@ %@", _Object(_deviceLanguageCode), _Object(languages));
		
		//MARK: limit supported languages
		if ([_deviceLanguageCode isEqualToString:@"en"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ko"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ja"] == NO
			&& [_deviceLanguageCode isEqualToString:@"ch"] == NO
			&& [_deviceLanguageCode isEqualToString:@"tw"] == NO) {
			_deviceLanguageCode = @"en";
		}
		FXDLog(@"2.%@ %@", _Object(_deviceLanguageCode), _Object(languages));
	}

	return _deviceLanguageCode;
}

- (NSString*)deviceCountryCode {
	if (_deviceCountryCode == nil) {	FXDLog_DEFAULT
		NSString *localeIdentifier = [NSLocale currentLocale].localeIdentifier;
		
		NSArray *components = [localeIdentifier componentsSeparatedByString:@"_"];
		
		_deviceCountryCode = components[1];
		
		FXDLogObject(_deviceCountryCode);
	}
	
	return _deviceCountryCode;
}

- (NSString*)deviceModelName {
	if (_deviceModelName == nil) {
		
		struct utsname systemInfo;
		uname(&systemInfo);
		
		NSString *machineName = @(systemInfo.machine);
		
		NSDictionary *commonNamesDictionary =
		@{
		  @"i386":     @"iPhone Simulator",
		  @"x86_64":   @"iPad Simulator",

		  @"iPhone1,1":    @"iPhone",
		  @"iPhone1,2":    @"iPhone 3G",
		  @"iPhone2,1":    @"iPhone 3GS",
		  @"iPhone3,1":    @"iPhone 4",
		  @"iPhone3,2":    @"iPhone 4(Rev A)",
		  @"iPhone3,3":    @"iPhone 4(CDMA)",
		  @"iPhone4,1":    @"iPhone 4S",

		  @"iPhone5,1":    @"iPhone 5(GSM)",
		  @"iPhone5,2":    @"iPhone 5(GSM+CDMA)",
		  @"iPhone5,3":    @"iPhone 5c(GSM)",
		  @"iPhone5,4":    @"iPhone 5c(GSM+CDMA)",
		  @"iPhone6,1":    @"iPhone 5s(GSM)",
		  @"iPhone6,2":    @"iPhone 5s(GSM+CDMA)",

		  @"iPhone7,1":    @"iPhone 6+ (GSM+CDMA)",
		  @"iPhone7,2":    @"iPhone 6 (GSM+CDMA)",

		  @"iPad1,1":  @"iPad",
		  @"iPad2,1":  @"iPad 2(WiFi)",
		  @"iPad2,2":  @"iPad 2(GSM)",
		  @"iPad2,3":  @"iPad 2(CDMA)",
		  @"iPad2,4":  @"iPad 2(WiFi Rev A)",
		  @"iPad2,5":  @"iPad Mini 1G (WiFi)",
		  @"iPad2,6":  @"iPad Mini 1G (GSM)",
		  @"iPad2,7":  @"iPad Mini 1G (GSM+CDMA)",
		  @"iPad3,1":  @"iPad 3(WiFi)",
		  @"iPad3,2":  @"iPad 3(GSM+CDMA)",
		  @"iPad3,3":  @"iPad 3(GSM)",
		  @"iPad3,4":  @"iPad 4(WiFi)",
		  @"iPad3,5":  @"iPad 4(GSM)",
		  @"iPad3,6":  @"iPad 4(GSM+CDMA)",

		  @"iPad4,1":  @"iPad Air(WiFi)",
		  @"iPad4,2":  @"iPad Air(GSM)",
		  @"iPad4,3":  @"iPad Air(GSM+CDMA)",

		  @"iPad4,4":  @"iPad Mini 2G (WiFi)",
		  @"iPad4,5":  @"iPad Mini 2G (GSM)",
		  @"iPad4,6":  @"iPad Mini 2G (GSM+CDMA)",

		  @"iPod1,1":  @"iPod 1st Gen",
		  @"iPod2,1":  @"iPod 2nd Gen",
		  @"iPod3,1":  @"iPod 3rd Gen",
		  @"iPod4,1":  @"iPod 4th Gen",
		  @"iPod5,1":  @"iPod 5th Gen",
		  
		  };

		_deviceModelName = commonNamesDictionary[machineName];

		if (_deviceModelName == nil) {	FXDLog_DEFAULT
			FXDLogObject(machineName);

			_deviceModelName = machineName;
		}
	}

	return _deviceModelName;
}

#pragma mark -
- (NSNumber*)isDevice_iPhoneFour {
	if (_isDevice_iPhoneFour == nil) {
		struct utsname systemInfo;
		uname(&systemInfo);

		NSString *machineName = @(systemInfo.machine);

		_isDevice_iPhoneFour = @(([machineName isEqualToString:@"iPhone3,1"]
								  || [machineName isEqualToString:@"iPhone3,2"]
								  || [machineName isEqualToString:@"iPhone3,3"]
								  || [machineName isEqualToString:@"iPhone4,1"]));
	}
	return _isDevice_iPhoneFour;
}

- (NSNumber*)isDevice_iPhoneSix {
	if (_isDevice_iPhoneSix == nil) {
		struct utsname systemInfo;
		uname(&systemInfo);

		NSString *machineName = @(systemInfo.machine);

		_isDevice_iPhoneSix = @(([machineName isEqualToString:@"iPhone7,1"]
								 || [machineName isEqualToString:@"iPhone7,2"]));
	}
	return _isDevice_iPhoneSix;
}

#pragma mark -
- (NSDateFormatter*)dateformatterUTC {
	
	if (_dateformatterUTC == nil) {	FXDLog_DEFAULT
		_dateformatterUTC = [[NSDateFormatter alloc] init];
		
		NSTimeZone *UTCtimezone = [NSTimeZone timeZoneWithName:@"UTC"];
		_dateformatterUTC.timeZone = UTCtimezone;
		[_dateformatterUTC setDateFormat:dateformatDefault];
		
		FXDLogObject(_dateformatterUTC);
	}
	
	return _dateformatterUTC;
}

- (NSDateFormatter*)dateformatterLocal {
	
	if (_dateformatterLocal == nil) {	FXDLog_DEFAULT
		_dateformatterLocal = [[NSDateFormatter alloc] init];
		
		NSTimeZone *localTimeZone = [NSTimeZone defaultTimeZone];
		_dateformatterLocal.timeZone = localTimeZone;
		[_dateformatterLocal setDateFormat:dateformatDefault];
				
		FXDLogObject(_dateformatterLocal);
	}
	
	return _dateformatterLocal;
}

#pragma mark -
- (id)initialScene {
	if (_initialScene) {
		return _initialScene;
	}


	if (self.mainStoryboard) {
		_initialScene = [self.mainStoryboard instantiateInitialViewController];
	}

	FXDLog_DEFAULT
	FXDLogObject(_initialScene);

	return _initialScene;
}


#pragma mark - Method overriding

#pragma mark - Public
- (void)prepareGlobalModuleWithCallback:(FXDcallbackFinish _Nullable )callback {	FXDLog_DEFAULT
	FXDLogObject([[UIDevice currentDevice].identifierForVendor UUIDString]);
	//FXDLogObject([[NSBundle mainBundle] infoDictionary]);

	FXDLogObject(NSUserName());
	FXDLogObject(NSFullUserName());

	FXDLogObject(NSHomeDirectory());
	FXDLogObject(NSTemporaryDirectory());

	FXDLogObject(NSOpenStepRootDirectory());


	[self incrementAppLaunchCount];

	[self configureUserDefaultsInfo];
	[self configureGlobalAppearance];


	if (callback) {
		callback(_cmd, YES, nil);
	}
}

#pragma mark -
- (void)incrementAppLaunchCount {	FXDLog_DEFAULT
	//MARK: Make sure value is retrieved from userDefaults first
	_appLaunchCount = (self.appLaunchCount)+1;
	FXDLogVariable(_appLaunchCount);
	
	[[NSUserDefaults standardUserDefaults] setInteger:_appLaunchCount forKey:userdefaultIntegerAppLaunchCount];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
- (void)configureUserDefaultsInfo {	FXDLog_OVERRIDE;
}

- (void)configureGlobalAppearance {	FXDLog_OVERRIDE;
}


#pragma mark -
- (BOOL)shouldUpgradeForNewAppVersion {
	NSInteger versionInteger = [application_BundleVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
	FXDLogVariable(versionInteger);

	BOOL shouldUpgrade = [self isLastVersionOlderThanVersionInteger:versionInteger];
	FXDLogBOOL(shouldUpgrade);

	return shouldUpgrade;
}

- (BOOL)isLastVersionOlderThanVersionInteger:(NSInteger)versionInteger {
	BOOL isOlder = NO;

	id lastVersionObj = [[NSUserDefaults standardUserDefaults] objectForKey:userdefaultIntegerLastUpgradedAppVersion];
	FXDLog(@"%@ < %@", _Variable([lastVersionObj integerValue]), _Variable(versionInteger));

	if ([lastVersionObj integerValue] < versionInteger) {
		isOlder = YES;
	}
	FXDLogBOOL(isOlder);

	return isOlder;
}

- (void)updateLastUpgradedAppVersionAfterLaunch {	FXDLog_DEFAULT
	NSInteger versionInteger = [application_BundleVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;

	[[NSUserDefaults standardUserDefaults] setInteger:versionInteger forKey:userdefaultIntegerLastUpgradedAppVersion];
	[[NSUserDefaults standardUserDefaults] synchronize];
	FXDLog(@"SAVED: %@", _Variable(versionInteger));
}

#pragma mark -
- (void)shouldAlertAboutCurrentVersionForAppStoreID:(NSString*_Nullable)appStoreID withCallback:(FXDcallbackFinish _Nullable )finishCallback {	FXDLog_DEFAULT
	FXDLogObject(appStoreID);

#ifdef application_AppStoreID
	if (appStoreID.length == 0) {
		appStoreID = application_AppStoreID;
	}
#endif

	if (appStoreID.length == 0) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	//MARK: Use different locale for future reuse
	NSString *requestPath = [NSString stringWithFormat:@"http://itunes.apple.com/kr/lookup?id=%@", appStoreID];

	NSURLRequest *evaluationRequest = [NSURLRequest requestWithURL:[NSURL evaluatedURLforPath:requestPath]];
	FXDLogObject(evaluationRequest);


	NSURLSessionDataTask *evaluationSessionTask =
	[[NSURLSession sharedSession]
	 dataTaskWithRequest:evaluationRequest
	 completionHandler:^(NSData *data,
						 NSURLResponse *response,
						 NSError *error) {	FXDLog_BLOCK(self, _cmd);
		 FXDLogObject(response);
		 FXDLog_ERROR;

		 FXDLogVariable(data.length);

		 if (error || data.length == 0) {
			 if (finishCallback) {
				 [[NSOperationQueue mainQueue]
				  addOperationWithBlock:^{
					  finishCallback(_cmd, NO, nil);
				  }];
			 }
			 return;
		 }


		 error = nil;
		 NSDictionary *jsonObject = [NSJSONSerialization
									 JSONObjectWithData:data
									 options:NSJSONReadingAllowFragments
									 error:&error];FXDLog_ERROR;
		 //FXDLogObject(jsonObject);


		 NSArray *resultArray = jsonObject[@"results"];
		 FXDLogVariable(resultArray.count);

		 NSDictionary *firstResult = resultArray.firstObject;

		 NSString *appStoreVersion = firstResult[@"version"];
		 FXDLogObject(appStoreVersion);
		 FXDLogObject(application_ShortVersion);
		 FXDLogBOOL(([appStoreVersion isEqualToString:application_ShortVersion] == NO));

		 NSInteger currentVersionInteger = [application_ShortVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
		 NSInteger appStoreVersionInteger = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
		 FXDLogVariable(currentVersionInteger);
		 FXDLogVariable(appStoreVersionInteger);
		 FXDLogBOOL((currentVersionInteger < appStoreVersionInteger));


		 BOOL shouldAlert = (appStoreVersion && (currentVersionInteger < appStoreVersionInteger));
		 FXDLogBOOL(shouldAlert);

		 if (finishCallback) {
			 [[NSOperationQueue mainQueue]
			  addOperationWithBlock:^{
				  finishCallback(_cmd, shouldAlert, appStoreVersion);
			  }];
		 }
	 }];

	[evaluationSessionTask resume];
}

#pragma mark -
- (NSString*_Nullable)UTCdateStringForLocalDate:(NSDate*_Nullable)localDate {
	if (localDate == nil) {
		localDate = [NSDate date];
	}

    NSString *UTCdateString = [self.dateformatterUTC stringFromDate:localDate];

    return UTCdateString;
}

- (NSDate*_Nullable)UTCdateForLocalDate:(NSDate*_Nullable)localDate {

	NSString *UTCdateString = [self UTCdateStringForLocalDate:localDate];

	NSDate *UTCdate = [self.dateformatterUTC dateFromString:UTCdateString];

	return UTCdate;
}

- (NSString*_Nullable)localDateStringForUTCdate:(NSDate*_Nullable)UTCdate {

	NSString *localDateString = [self.dateformatterLocal stringFromDate:UTCdate];

	return localDateString;
}

- (NSDate*_Nullable)localDateForUTCdate:(NSDate*_Nullable)UTCdate {
	NSString *localDateString = [self localDateStringForUTCdate:UTCdate];
	
	NSDate *localDate = [self.dateformatterLocal dateFromString:localDateString];
	
	return localDate;
}


@end
