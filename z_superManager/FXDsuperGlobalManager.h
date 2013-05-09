//
//  FXDsuperGlobalManager.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//


@interface FXDsuperGlobalManager : FXDObject {
    // Primitives
	BOOL _didMakePurchase;
	BOOL _didShareToSocialNet;

	// Instance variables
	NSString *_mainStoryboardName;
	FXDStoryboard *_mainStoryboard;
}

@property (assign, nonatomic) BOOL didMakePurchase;
@property (assign, nonatomic) BOOL didShareToSocialNet;

@property (strong, nonatomic) NSString *mainStoryboardName;
@property (strong, nonatomic) FXDStoryboard *mainStoryboard;

// Properties
@property (strong, nonatomic) NSString *deviceLanguageCode;

@property (strong, nonatomic) id rootController;
@property (strong, nonatomic) id homeController;


#pragma mark - Public
+ (FXDsuperGlobalManager*)sharedInstance;

- (void)prepareGlobalManagerAtLaunchWithWindowLoadingBlock:(void(^)(void))windowLoadingBlock;

- (void)startObservingEssentialNotifications;

- (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;


#warning "//TODO: refactor following method to be organized into categories or subclasses"

+ (NSString*)deviceModelName;
+ (NSString*)deviceCountryCode;
+ (NSString*)deviceLanguageCode;

+ (void)alertWithMessage:(NSString*)message withTitle:(NSString*)title;
+ (void)printoutListOfFonts;


//MARK: - Observer implementation
- (void)observedUIApplicationWillChangeStatusBarFrame:(NSNotification*)notification;
- (void)observedUIApplicationDidChangeStatusBarFrame:(NSNotification*)notification;

- (void)observedUIApplicationWillResignActive:(NSNotification*)notification;
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;
- (void)observedUIApplicationDidBecomeActive:(NSNotification*)notification;
- (void)observedUIApplicationWillTerminate:(NSNotification*)notification;

- (void)observedNSUserDefaultsDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#pragma mark - Category

@interface FXDsuperGlobalManager (MailComposing) <MFMailComposeViewControllerDelegate>

- (MFMailComposeViewController*)preparedMailComposeInterface;
- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message;
- (void)presentMailComposeInterfaceForPresentingInterface:(UIViewController*)presentingInterface usingImage:(UIImage*)image usingMessage:(NSString*)message;

#pragma mark - MFMailComposeViewControllerDelegate

@end
