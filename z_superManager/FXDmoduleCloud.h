//
//  FXDmoduleCloud.h
//
//
//  Created by petershine on 6/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define userdefaultObjSavedUbiquityIdentityToken	@"SavedUbiquityIdentityTokenObjKey"
#define userdefaultStringSavedUbiquityContainerURL	@"SavedUbiquityContainerURLstringKey"


@interface FXDmoduleCloud : FXDsuperModule {
	FXDcallbackFinish _statusCallback;

	NSString *_containerIdentifier;
	NSURL *_containerURL;
}

//MARK: can be deallocated dynamically for reacting only once
@property (copy) FXDcallbackFinish statusCallback;

@property (strong, nonatomic) NSString *containerIdentifier;
@property (strong, nonatomic) NSURL *containerURL;


#pragma mark - Public
- (void)prepareContainerURLwithIdentifier:(NSString*)containerIdentifier withStatusCallback:(FXDcallbackFinish)statusCallback;

- (void)notifyCallbackWithContainerURL:(NSURL*)containerURL shouldAddObserver:(BOOL)shouldAddObserver withAlertBody:(NSString*)alertBody;


//MARK: - Observer implementation
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end
