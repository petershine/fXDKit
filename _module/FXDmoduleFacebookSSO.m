

#if USE_SocialFrameworks


#import "FXDmoduleFacebookSSO.h"


@implementation FXDmoduleFacebookSSO

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Property overriding
- (NSDictionary*)additionalAccessOptions {
	if (_additionalAccessOptions == nil) {	FXDLog_DEFAULT;

		_additionalAccessOptions =
		@{ACFacebookAppIdKey:	apikeyFacebookAppId,
		  ACFacebookPermissionsKey:	@[facebookPermissionPublicProfile,
									  facebookPermissionUserFriends,
									  facebookPermissionPublishActions,
									  facebookPermissionManagePages,
									  facebookPermissionPublishStream],
		  ACFacebookAudienceKey:	ACFacebookAudienceEveryone};

		FXDLogObject(_additionalAccessOptions);
	}

	return _additionalAccessOptions;
}

- (NSArray*)multiAccountArray {	//NOTE: Using facebookSDK;
	return _multiAccountArray;
}

#pragma mark -
- (FBSessionLoginBehavior)sessionLoginBehavior {
	return FBSessionLoginBehaviorUseSystemAccountIfPresent;
}

#pragma mark -
- (NSDictionary*)currentFacebookAccount {

	if (_currentFacebookAccount == nil) {	FXDLog_DEFAULT;

		NSString *accountObjKey = userdefaultObjMainFacebookAccountIdentifier;


		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

		NSDictionary *accountDictionary = [userDefaults dictionaryForKey:accountObjKey];

		FXDLog(@"accountObjKey: %@", accountObjKey);

		if (accountDictionary) {
			_currentFacebookAccount = accountDictionary;
		}

		FXDLog(@"_currentFacebookAccount: %@", _currentFacebookAccount);
	}

	return _currentFacebookAccount;
}


#pragma mark - Method overriding
- (void)signInBySelectingAccountForTypeIdentifier:(NSString *)typeIdentifier withPresentingView:(UIView *)presentingView withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLogObject(typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	FXDLogObject([UIApplication mainWindow]);
	[(FXDWindow*)[UIApplication mainWindow] showInformationViewAfterDelay:delayQuarterSecond];

	// Initialize a session object
	FBSession *activeSession = [FBSession activeSession];

	FXDLog(@"1.%@", _Variable(activeSession.state));
	FXDLog(@"1.%@", _BOOL(activeSession.isOpen));

	FXDLog(@"1.%@", _Variable(activeSession.accessTokenData.loginType));

	if (activeSession.isOpen) {
		[self
		 updateSessionPermissionWithFinishCallback:^(SEL caller, BOOL finished, id responseObj) {
			 FXDLog_BLOCK(self, caller);
			 FXDLogBOOL(finished);

			 if (finished) {
				 [self
				  showActionSheetInPresentingView:presentingView
				  forSelectingAccountForTypeIdentifier:typeIdentifier
				  withFinishCallback:finishCallback];
			 }
			 else {
				 [(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

				 if (finishCallback) {
					 finishCallback(_cmd, finished, nil);
				 }
			 }
		 }];
		return;
	}


	[FBSession
	 openActiveSessionWithReadPermissions:nil
	 allowLoginUI:YES
	 completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
		 FXDLog_BLOCK(FBSession, @selector(openActiveSessionWithReadPermissions:allowLoginUI:completionHandler:));

		 FXDLog_ERROR;

		 FXDLog(@"2.%@", _Variable(session.state));
		 FXDLog(@"2.%@", _BOOL(session.isOpen));

		 FXDLog(@"2.%@", _Variable(session.accessTokenData.loginType));

		 FXDLogBOOL(FB_ISSESSIONSTATETERMINAL(session.state));


		 BOOL shouldContinue = [self shouldContinueWithError:error];

		 if (shouldContinue == NO || session.isOpen == NO) {
			 [(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }


		 FXDLogBOOL(self.isAskingForMorePermissions);
		 if (self.isAskingForMorePermissions) {
			 return;
		 }


		 self.isAskingForMorePermissions = YES;

		 Float64 delayedSeconds = 2.0;

		 if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
			 delayedSeconds = 0.0;
		 }

		 FXDLog(@"%@ %@", _BOOL([UIApplication sharedApplication].applicationState == UIApplicationStateActive), _Variable(delayedSeconds));

		 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayedSeconds * NSEC_PER_SEC));
		 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			 [self
			  updateSessionPermissionWithFinishCallback:^(SEL caller, BOOL finished, id responseObj) {
				  FXDLog_BLOCK(self, caller);
				  FXDLogBOOL(finished);

				  if (finished) {
					  [self
					   showActionSheetInPresentingView:presentingView
					   forSelectingAccountForTypeIdentifier:typeIdentifier
					   withFinishCallback:finishCallback];
				  }
				  else {
					  [(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

					  if (finishCallback) {
						  finishCallback(_cmd, finished, nil);
					  }
				  }

				  self.isAskingForMorePermissions = NO;
			  }];
		 });
	 }];
}

- (void)showActionSheetInPresentingView:(UIView*)presentingView forSelectingAccountForTypeIdentifier:(NSString*)typeIdentifier withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLog(@"typeIdentifier: %@", typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		[(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	void (^ConfigureActionSheet)(void) = ^(void){
		FXDLogObject(self.multiAccountArray);

		NSString *actionsheetTitle = NSLocalizedString(@"Please select your Facebook Timeline or Page", nil);

		FXDActionSheet *actionSheet =
		[[FXDActionSheet alloc]
		 initWithTitle:actionsheetTitle
		 withButtonTitleArray:nil
		 cancelButtonTitle:nil
		 destructiveButtonTitle:nil
		 withAlertCallback:^(id alertObj, NSInteger buttonIndex) {
			 [self
			  selectAccountForTypeIdentifier:typeIdentifier
			  fromActionSheet:alertObj
			  forButtonIndex:buttonIndex
			  withFinishCallback:finishCallback];
		 }];

		[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
		actionSheet.cancelButtonIndex = 0;

		for (NSDictionary *account in self.multiAccountArray) {
			NSString *buttonTitle = nil;

			if ([account[objkeyFacebookCategory] length] == 0) {
				if ([account[objkeyFacebookUsername] length] > 0) {
					buttonTitle = [NSString stringWithFormat:@"TIMELINE: %@", account[objkeyFacebookUsername]];
				}
				else {
					buttonTitle = [NSString stringWithFormat:@"TIMELINE: %@", account[objkeyFacebookName]];
				}
			}
			else {
				buttonTitle = [NSString stringWithFormat:@"PAGE: %@", account[objkeyFacebookName]];
			}

			if (buttonTitle) {
				[actionSheet addButtonWithTitle:buttonTitle];
			}
		}

		[actionSheet addButtonWithTitle:NSLocalizedString(@"Sign Out", nil)];
		actionSheet.destructiveButtonIndex = [self.multiAccountArray count]+1;

		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showInView:presentingView];

		[(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];
	};


	void (^RequestingFailed)(void) = ^(void){
		[(FXDWindow*)[UIApplication mainWindow] hideInformationViewAfterDelay:delayQuarterSecond];

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
	};


	if ([self.multiAccountArray count] > 0) {
		ConfigureActionSheet();
		return;
	}


	__block NSMutableArray *collectedAccounts = [[NSMutableArray alloc] initWithCapacity:0];
	FXDLogObject(collectedAccounts);

	[self
	 facebookRequestForMeWithFinishCallback:^(SEL caller, BOOL finished, NSArray *accounts) {
		 FXDLog_BLOCK(self, caller);
		 FXDLogObject(accounts);

		 if ([accounts count] > 0) {
			 [collectedAccounts addObjectsFromArray:accounts];
		 }

		 FXDLogObject(collectedAccounts);

		 [self
		  facebookRequestForAccountsWithFinishCallback:^(SEL caller, BOOL finished, NSArray *accounts) {
			  FXDLog_BLOCK(self, caller);
			  FXDLogObject(accounts);

			  if ([accounts count] > 0) {
				  [collectedAccounts addObjectsFromArray:accounts];
			  }

			  FXDLogObject(collectedAccounts);


			  _multiAccountArray = [collectedAccounts copy];
			  FXDLogVariable([_multiAccountArray count]);

			  if ([self.multiAccountArray count] > 0) {
				  ConfigureActionSheet();
			  }
			  else {
				  _multiAccountArray = nil;

				  RequestingFailed();
			  }
		  }];
	 }];
}

- (void)selectAccountForTypeIdentifier:(NSString*)typeIdentifier fromActionSheet:(FXDActionSheet*)actionSheet forButtonIndex:(NSInteger)buttonIndex withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	if (typeIdentifier == nil) {
		typeIdentifier = self.typeIdentifier;
	}

	FXDLogObject(typeIdentifier);

	if (typeIdentifier == nil || [typeIdentifier isEqualToString:self.typeIdentifier] == NO) {
		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	FXDLogVariable(buttonIndex);
	FXDLogVariable(actionSheet.cancelButtonIndex);
	FXDLogVariable(actionSheet.destructiveButtonIndex);


	if (buttonIndex == (NSInteger)[actionSheet performSelector:@selector(cancelButtonIndex)]) {
		_multiAccountArray = nil;

		if (finishCallback) {
			finishCallback(_cmd, NO, nil);
		}
		return;
	}


	NSString *accountObjKey = userdefaultObjMainFacebookAccountIdentifier;


	BOOL didAssignAccount = NO;

	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

	if ([actionSheet isKindOfClass:[UIActionSheet class]]
		&& buttonIndex == [(FXDActionSheet*)actionSheet destructiveButtonIndex]) {

		[self resetCredential];
	}
	else {
		NSDictionary *selectedAccount = (self.multiAccountArray)[buttonIndex-1];
		FXDLog(@"selectedAccount: %@", selectedAccount);

		if (selectedAccount) {
			[userDefaults setObject:selectedAccount forKey:accountObjKey];

			_currentFacebookAccount = selectedAccount;
		}

		[userDefaults synchronize];

		didAssignAccount = YES;
	}

	_multiAccountArray = nil;

	FXDLogBOOL(didAssignAccount);

	if (finishCallback) {
		finishCallback(_cmd, didAssignAccount, nil);
	}
}

#pragma mark -
- (void)renewAccountCredentialForTypeIdentifier:(NSString*)typeIdentifier withRequestingBlock:(void(^)(BOOL shouldRequest))requestingBlock {	FXDLog_DEFAULT;

	FBSession *activeSession = [FBSession activeSession];
	FXDLog(@"1.%@ %@ %@ %@", _BOOL(activeSession.isOpen), _Variable(activeSession.state), _Object(activeSession.accessTokenData.accessToken), _Variable(activeSession.accessTokenData.loginType));

	if (activeSession.isOpen) {
		if (requestingBlock) {
			requestingBlock(YES);
		}
		return;
	}


	void (^SessionOpening)(FXDcallbackFinish) = ^(FXDcallbackFinish finishCallback){
		FXDLog(@"SessionOpening: %@", finishCallback);

		[[FBSession activeSession]
		 openWithBehavior:self.sessionLoginBehavior
		 completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
			 FXDLog_BLOCK([FBSession activeSession], @selector(openWithBehavior:completionHandler:));

			 FXDLog_ERROR;

			 FXDLog(@"2.%@", _Variable(session.state));
			 FXDLog(@"2.%@", _BOOL(session.isOpen));

			 FXDLog(@"2.%@", _Variable(session.accessTokenData.loginType));

			 FXDLogBOOL(FB_ISSESSIONSTATETERMINAL(session.state));


			 BOOL shouldRequest = (status == FBSessionStateCreatedOpening
								   || status == FBSessionStateOpen
								   || status == FBSessionStateOpenTokenExtended);
			 FXDLogBOOL(shouldRequest);

			 if (finishCallback) {
				 finishCallback(_cmd, shouldRequest, nil);
			 }
		 }];
	};


	SessionOpening(^(SEL caller, BOOL finished, id responseObj){
		FXDLog(@"SessionOpening %@", _BOOL(finished));
		FXDLog(@"2.%@ %@ %@ %@", _BOOL(activeSession.isOpen), _Variable(activeSession.state), _Object(activeSession.accessTokenData.accessToken), _Variable(activeSession.accessTokenData.loginType));

		if (finished
			|| (activeSession.accessTokenData
				&& activeSession.accessTokenData.loginType != FBSessionLoginTypeSystemAccount)) {

				if (requestingBlock) {
					requestingBlock(finished);
				}
				return;
			}


		[FBSession
		 renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
			 FXDLog_BLOCK(FBSession, @selector(renewSystemCredentials:));
			 FXDLog_ERROR;

			 if (error) {
				 NSString *alertMessage = [error localizedDescription];

				 if ([error code] == 9) {
					 alertMessage = [alertMessage stringByAppendingString:NSLocalizedString(@"\nPlease try again", nil)];
				 }
				 FXDLogObject(alertMessage);

				 [FXDAlertView
				  showAlertWithTitle:nil
				  message:alertMessage
				  cancelButtonTitle:nil
				  withAlertCallback:nil];
			 }

			 BOOL didRenew = (result == ACAccountCredentialRenewResultRenewed);
			 FXDLogBOOL(didRenew);

			 if (didRenew) {
				 SessionOpening(^(SEL caller, BOOL finished, id responseObj){
					 FXDLog(@"SessionOpening finished: %d", finished);

					 if (requestingBlock) {
						 requestingBlock(finished);
					 }
				 });
				 return;
			 }

			 [self resetCredential];

			 if (requestingBlock) {
				 requestingBlock(NO);
			 }
		 }];
	});
}


#pragma mark - Public
- (void)resetCredential {	FXDLog_DEFAULT;
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:userdefaultObjMainFacebookAccountIdentifier];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:userdefaultObjKeyFacebookAccessToken];

	_currentFacebookAccount = nil;
	_currentPageAccessToken = nil;


	[[FBSession activeSession] closeAndClearTokenInformation];

	FXDLogVariable([FBSession activeSession].state);
	FXDLogBOOL([FBSession activeSession].isOpen);

	FXDLogVariable([FBSession activeSession].accessTokenData.loginType);

	FXDLogBOOL(FB_ISSESSIONSTATETERMINAL([FBSession activeSession].state));
}

#pragma mark -
- (void)startObservingFBSessionNotifications {	FXDLog_DEFAULT;

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidSetActiveSession:)
	 name:FBSessionDidSetActiveSessionNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidUnsetActiveSession:)
	 name:FBSessionDidUnsetActiveSessionNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidBecomeOpenActiveSession:)
	 name:FBSessionDidBecomeOpenActiveSessionNotification
	 object:nil];

	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFBSessionDidBecomeClosedActiveSession:)
	 name:FBSessionDidBecomeClosedActiveSessionNotification
	 object:nil];
}

#pragma mark -
- (BOOL)shouldContinueWithError:(NSError*)error {
	if (error == nil) {
		return YES;
	}


	FXDLog_DEFAULT;

	FXDLog_ERROR;


	BOOL shouldNotifyUser = [FBErrorUtility shouldNotifyUserForError:error];
	FXDLogBOOL(shouldNotifyUser);
	if (shouldNotifyUser) {
	}

	BOOL isTransient = [FBErrorUtility isTransientError:error];
	FXDLogBOOL(isTransient);
	if (isTransient) {
	}

	FBErrorCategory errorCategory = [FBErrorUtility errorCategoryForError:error];
	FXDLogVariable(errorCategory);
	if (errorCategory == FBErrorCategoryServer) {
	}



	NSString *userTitle = [FBErrorUtility userTitleForError:error];
	NSString *userMessage = [FBErrorUtility userMessageForError:error];
	FXDLogObject(userTitle);
	FXDLogObject(userMessage);


	NSString *localizedDescription = error.userInfo[NSLocalizedDescriptionKey];
	NSString *failureReason = error.userInfo[NSLocalizedFailureReasonErrorKey];
	FXDLogObject(localizedDescription);
	FXDLogObject(failureReason);

	NSString *alertTitle = (userTitle.length > 0) ? userTitle:NSLocalizedString(@"Facebook", nil);

	NSString *alertMessage = [NSString stringWithFormat:@"%@\n%@\n%@",
							  (localizedDescription) ? localizedDescription:@"",
							  (failureReason) ? failureReason:@"",
							  (userMessage) ? userMessage:@""];

	NSDictionary *errorInformation = [error userInfo][@"com.facebook.sdk:ParsedJSONResponseKey"][@"body"][@"error"];
	NSString *errorMessage = errorInformation[@"message"];

	if (errorMessage.length > 0) {
		alertMessage = [alertMessage stringByAppendingFormat:@"\n%@", errorMessage];
	}

	FXDLogObject(alertMessage);

	if (alertMessage.length > 0) {
		[FXDAlertView
		 showAlertWithTitle:alertTitle
		 message:alertMessage
		 cancelButtonTitle:nil
		 withAlertCallback:nil];
	}


	//ERROR:
	/*
	 ERROR: [FCMmoduleFacebook shouldContinueWithError:]
	 FILE: /Users/thckbrws/Desktop/_WORK_fXceed/_PROJECT/__FXDKit/_module/FXDmoduleSocial.m
	 LINE: 1213
	 {
	 Code = 2;
	 Description = "\Uc8c4\Uc1a1\Ud569\Ub2c8\Ub2e4. \Uc774 \Uae30\Ub2a5\Uc740 \Ud604\Uc7ac \Uc774\Uc6a9\Ud560 \Uc218 \Uc5c6\Uc2b5\Ub2c8\Ub2e4.: \Uc774 \Uc694\Uccad\Uc744 \Ucc98\Ub9ac\Ud558\Ub294 \Ub3d9\Uc548 \Uc624\Ub958\Uac00 \Ubc1c\Uc0dd\Ud588\Uc2b5\Ub2c8\Ub2e4. \Ub098\Uc911\Uc5d0 \Ub2e4\Uc2dc \Uc2dc\Ub3c4\Ud574 \Uc8fc\Uc138\Uc694.";
	 Domain = "com.facebook.sdk";
	 FailureReason = "com.facebook.sdk:UserLoginOtherError";
	 UserInfo =     {
	 NSLocalizedDescription = "\Uc8c4\Uc1a1\Ud569\Ub2c8\Ub2e4. \Uc774 \Uae30\Ub2a5\Uc740 \Ud604\Uc7ac \Uc774\Uc6a9\Ud560 \Uc218 \Uc5c6\Uc2b5\Ub2c8\Ub2e4.: \Uc774 \Uc694\Uccad\Uc744 \Ucc98\Ub9ac\Ud558\Ub294 \Ub3d9\Uc548 \Uc624\Ub958\Uac00 \Ubc1c\Uc0dd\Ud588\Uc2b5\Ub2c8\Ub2e4. \Ub098\Uc911\Uc5d0 \Ub2e4\Uc2dc \Uc2dc\Ub3c4\Ud574 \Uc8fc\Uc138\Uc694.";
	 NSLocalizedFailureReason = "com.facebook.sdk:UserLoginOtherError";
	 "com.facebook.sdk:ErrorLoginFailedOriginalErrorCode" = 2;
	 "com.facebook.sdk:ErrorLoginFailedReason" = "com.facebook.sdk:UserLoginOtherError";
	 "com.facebook.sdk:ErrorSessionKey" = "<FBSession: 0x16e38ba0, state: FBSessionStateClosedLoginFailed, loginHandler: 0x0, appID: 734812369930783, urlSchemeSuffix: , tokenCachingStrategy:<FBSessionTokenCachingStrategy: 0x16d49570>, expirationDate: (null), refreshDate: (null), attemptedRefreshDate: 0001-12-30 00:00:00 +0000, permissions:(null)>";
	 };
	 }
	 2014-12-01 11:25:36.329 GroveCam[1575:60b] errorMessage: (null)
	 */


	return NO;
}

#pragma mark -
- (void)updateSessionPermissionWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	BOOL canReturnEarly = YES;

	FBSession *activeSession = [FBSession activeSession];
	FXDLogObject(activeSession.permissions);

	if ([activeSession.permissions containsObject:facebookPermissionPublishActions] == NO) {
		canReturnEarly = NO;
	}

	FXDLogBOOL(canReturnEarly);

	if (canReturnEarly) {
		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
		return;
	}


	NSArray *permissions = @[facebookPermissionPublishActions,
							 facebookPermissionManagePages];
	FXDLogObject(permissions);


	FBSessionDefaultAudience defaultAudience = FBSessionDefaultAudienceNone;

	if ([self.additionalAccessOptions[ACFacebookAudienceKey] isEqualToString:ACFacebookAudienceEveryone]) {
		defaultAudience = FBSessionDefaultAudienceEveryone;
	}
	else if ([self.additionalAccessOptions[ACFacebookAudienceKey] isEqualToString:ACFacebookAudienceFriends]) {
		defaultAudience = FBSessionDefaultAudienceFriends;
	}
	else if ([self.additionalAccessOptions[ACFacebookAudienceKey] isEqualToString:ACFacebookAudienceOnlyMe]) {
		defaultAudience = FBSessionDefaultAudienceOnlyMe;
	}

	[activeSession
	 requestNewPublishPermissions:permissions
	 defaultAudience:defaultAudience
	 completionHandler:^(FBSession *session, NSError *error) {
		 FXDLog(@"3.%@", _Variable(session.state));
		 FXDLog(@"3.%@", _BOOL(session.isOpen));

		 FXDLog(@"3.%@", _Object(session.permissions));
		 FXDLog(@"3.%@", _Variable(session.accessTokenData.loginType));

		 BOOL shouldContinue = [self shouldContinueWithError:error];

		 if (finishCallback) {
			 finishCallback(_cmd, shouldContinue, nil);
		 }
	 }];
}


#pragma mark -
- (void)facebookRequestForMeWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }


		 FXDAssert_IsMainThread;

		 [FBRequestConnection
		  startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {

			  BOOL shouldContinue = [self shouldContinueWithError:error];

			  if (shouldContinue == NO) {
				  if (finishCallback) {
					  finishCallback(_cmd, shouldContinue, nil);
				  }
				  return;
			  }


			  NSDictionary *facebookMeInfo =
			  @{objkeyFacebookID:	(result[objkeyFacebookID]) ? result[objkeyFacebookID]:@"",
				objkeyFacebookName:	(result[objkeyFacebookName]) ? result[objkeyFacebookName]:@"",
				objkeyFacebookUsername:	(result[objkeyFacebookUsername]) ? result[objkeyFacebookUsername]:@""};

			  if (finishCallback) {
				  NSArray *accounts = @[facebookMeInfo];

				  finishCallback(_cmd, shouldContinue, accounts);
			  }
		  }];
	 }];
}

- (void)facebookRequestForAccountsWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }


		 FXDAssert_IsMainThread;

		 [FBRequestConnection
		  startWithGraphPath:facebookGraphMeAccounts
		  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
			  FXDLogObject(result);

			  BOOL shouldContinue = [self shouldContinueWithError:error];

			  if (finishCallback) {
				  finishCallback(_cmd, shouldContinue, [result[@"data"] copy]);
			  }
		  }];
	 }];
}

- (void)facebookRequestPageAccessTokenWithFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	FXDLog(@"1.%@", _Object(self.currentPageAccessToken));

	if (self.currentPageAccessToken.length > 0) {
		if (finishCallback) {
			finishCallback(_cmd, YES, self.currentPageAccessToken);
		}
		return;
	}


	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }



		 NSString *facebookPageId = self.currentFacebookAccount[objkeyFacebookID];

		 NSString *graphPath = [NSString stringWithFormat:@"/%@?fields=access_token", facebookPageId];
		 FXDLogObject(graphPath);


		 //NOTE: MainQueue is necessaryfor safe requesting
		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{

			  FXDAssert_IsMainThread;

			  [FBRequestConnection
			   startWithGraphPath:graphPath
			   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
				   FXDLog_BLOCK(FBRequestConnection, @selector(startWithGraphPath:completionHandler:));
				   FXDLog(@"result[\"%@\"]: %@", objkeyFacebookAccessToken, result[objkeyFacebookAccessToken]);

				   BOOL shouldContinue = [self shouldContinueWithError:error];

				   if (shouldContinue) {
					   self.currentPageAccessToken = [result[objkeyFacebookAccessToken] copy];
				   }
				   else {
					   self.currentPageAccessToken = nil;
				   }

				   FXDLog(@"2.%@", _Object(self.currentPageAccessToken));

				   if (finishCallback) {
					   finishCallback(_cmd, shouldContinue, self.currentPageAccessToken);
				   }
			   }];
		  }];
	 }];
}

#pragma mark -
- (void)facebookRequestToPostWithMessage:(NSString*)message withMediaLink:(NSString*)mediaLink atLatitude:(CLLocationDegrees)latitude atLongitude:(CLLocationDegrees)longitude withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;
	FXDLog(@"%@ %@", _Object(message), _Object(mediaLink));

	[self
	 renewAccountCredentialForTypeIdentifier:self.typeIdentifier
	 withRequestingBlock:^(BOOL shouldRequest){
		 FXDLog_BLOCK(self, @selector(renewAccountCredentialForTypeIdentifier:withRequestingBlock:));
		 FXDLogBOOL(shouldRequest);

		 if (shouldRequest == NO) {
			 if (finishCallback) {
				 finishCallback(_cmd, NO, nil);
			 }
			 return;
		 }


		 void (^PostWithLink)(NSString*) = ^(NSString *placeId){	FXDLog_DEFAULT;
			 FXDLog(@"PostWithLink: %@", _Object(placeId));

			 NSString *facebookId = self.currentFacebookAccount[objkeyFacebookID];
			 NSString *graphPath = [NSString stringWithFormat:facebookGraphProfileFeed, facebookId];
			 FXDLogObject(graphPath);


			 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
			 if (message) {parameters[@"message"] = message;}
			 if (mediaLink) {parameters[@"link"] = mediaLink;}
			 if (placeId) {parameters[@"place"] = placeId;}


			 NSString *pageCategory = self.currentFacebookAccount[objkeyFacebookCategory];
			 FXDLogObject(pageCategory);

			 if (pageCategory.length == 0) {
				 parameters[objkeyFacebookAccessToken] = [FBSession activeSession].accessTokenData.accessToken;

				 FXDLog(@"1.PostWithLink parameters: %@", parameters);

				 FXDAssert_IsMainThread;

				 [FBRequestConnection
				  startWithGraphPath:graphPath
				  parameters:parameters
				  HTTPMethod:@"POST"
				  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
					  FXDLog_BLOCK(FBRequestConnection, @selector(startWithGraphPath:parameters:HTTPMethod:completionHandler:));
					  FXDLog(@"PostWithLink result: %@", result);

					  BOOL shouldContinue = [self shouldContinueWithError:error];

					  if (finishCallback) {
						  finishCallback(_cmd, shouldContinue, nil);
					  }
				  }];

				 return;
			 }


			 //http://stackoverflow.com/a/18279372/259765
			 [self
			  facebookRequestPageAccessTokenWithFinishCallback:^(SEL caller, BOOL finished, NSString *pageAccessToken) {
				  FXDLog_BLOCK(self, caller);
				  FXDLogBOOL(finished);

				  FXDLogObject(pageAccessToken);

				  if (finished == NO
					  || self.currentPageAccessToken.length == 0) {

					  if (finishCallback) {
						  finishCallback(_cmd, NO, nil);
					  }
					  return;
				  }


				  parameters[objkeyFacebookAccessToken] = self.currentPageAccessToken;
				  FXDLog(@"2.PostWithLink parameters: %@", parameters);

				  NSString *requestQuery = [urlstringFacebook(graphPath) stringByAppendURLparameters:parameters];
				  NSURL *requestURL = [NSURL URLWithString:requestQuery];

				  NSMutableURLRequest *facebookRequest = [[NSMutableURLRequest alloc] initWithURL:requestURL];
				  facebookRequest.HTTPMethod = @"POST";

				  FXDLogObject(facebookRequest);

				  NSURLSessionTask *facebookTask =
				  [[NSURLSession sharedSession]
				   dataTaskWithRequest:facebookRequest
				   completionHandler:^(NSData *data,
									   NSURLResponse *response,
									   NSError *error) {	FXDLog_BLOCK(self, _cmd);
					   FXDLogObject(response);
					   FXDLog_ERROR;

#if	ForDEVELOPER
					   if (data.length > 0) {
						   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
						   FXDLogObject(responseString);
					   }
#endif

					   if (finishCallback) {
						   finishCallback(_cmd, (error == nil), nil);
					   }
				   }];

				  [facebookTask resume];
			  }];
		 };


		 if (latitude == 0.0 && longitude == 0.0) {
			 PostWithLink(nil);
			 return;
		 }


		 NSString *graphPath = @"search";

		 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
		 parameters[objkeyFacebookAccessToken] = [FBSession activeSession].accessTokenData.accessToken;
		 parameters[@"type"] = @"place";
		 parameters[@"center"] = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
		 parameters[@"distance"] = [NSString stringWithFormat:@"%@", @(kCLLocationAccuracyKilometer)];

		 FXDLogObject(parameters);

		 FXDAssert_IsMainThread;

		 [FBRequestConnection
		  startWithGraphPath:graphPath
		  parameters:parameters
		  HTTPMethod:@"GET"
		  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
			  FXDLog_BLOCK(FBRequestConnection, @selector(startWithGraphPath:parameters:HTTPMethod:completionHandler:));

			  BOOL shouldContinue = [self shouldContinueWithError:error];

			  if (shouldContinue == NO) {
				  if (finishCallback) {
					  finishCallback(_cmd, shouldContinue, nil);
				  }
				  return;
			  }


			  NSString *placeId = nil;

			  //TODO: Check if distance sorting is necessary

			  for (NSDictionary *place in result[@"data"]) {

				  if (placeId == nil) {
					  placeId = place[objkeyFacebookID];
					  FXDLog(@"%@ %@", _Object(placeId), _Object(place[objkeyFacebookName]));
					  break;
				  }
			  }

			  PostWithLink(placeId);
		  }];
	 }];
}


#pragma mark - Observer
- (void)observedACAccountStoreDidChange:(NSNotification*)notification {
	[super observedACAccountStoreDidChange:notification];

	ACAccountStore *accountStore = [notification object];

	for (ACAccount *account in accountStore.accounts) {
		ACAccountType *accountType = account.accountType;

		if ([accountType.identifier isEqualToString:self.typeIdentifier]
			|| [accountType.accountTypeDescription isEqualToString:self.typeIdentifier]) {
			
			if (accountType.accessGranted) {
				return;
			}
		}
	}
	
	
	[self resetCredential];
}

#pragma mark -
- (void)observedFBSessionDidSetActiveSession:(NSNotification*)notification {
}

- (void)observedFBSessionDidUnsetActiveSession:(NSNotification*)notification {
}

- (void)observedFBSessionDidBecomeOpenActiveSession:(NSNotification*)notification {	FXDLog_DEFAULT;
	FXDLog(@"notification: %@", notification);
}

- (void)observedFBSessionDidBecomeClosedActiveSession:(NSNotification*)notification {	FXDLog_DEFAULT;
}

#pragma mark - Delegate

@end


#endif