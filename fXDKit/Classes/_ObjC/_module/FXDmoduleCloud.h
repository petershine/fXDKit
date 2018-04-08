
#import "FXDimportEssential.h"
#import "FXDOperationQueue.h"

#define userdefaultObjSavedUbiquityIdentityToken	@"SavedUbiquityIdentityTokenObjKey"
#define userdefaultStringSavedUbiquityContainerURL	@"SavedUbiquityContainerURLstringKey"


@interface FXDmoduleCloud : NSObject {
	FXDcallbackFinish _statusCallback;

	NSString *_containerIdentifier;
	NSURL *_containerURL;
}

@property (copy) FXDcallbackFinish statusCallback;

@property (strong, nonatomic) NSString *containerIdentifier;
@property (strong, nonatomic) NSURL *containerURL;


- (void)prepareContainerURLwithIdentifier:(NSString*)containerIdentifier withStatusCallback:(FXDcallbackFinish)statusCallback;

- (void)notifyCallbackWithContainerURL:(NSURL*)containerURL shouldAddObserver:(BOOL)shouldAddObserver withAlertBody:(NSString*)alertBody;


#pragma mark - Observer
- (void)observedNSUbiquityIdentityDidChange:(NSNotification*)notification;

#pragma mark - Delegate

@end
