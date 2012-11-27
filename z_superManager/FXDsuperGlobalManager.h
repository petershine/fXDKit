//
//  FXDsuperGlobalManager.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#warning @"//TODO: remove unnecessary methods, not related to app launching and managing, especially those for utility providing"

#import "Reachability.h"


#import "FXDObject.h"

@interface FXDsuperGlobalManager : FXDObject <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    // Primitives
	BOOL _didMakePurchase;
	BOOL _didShareToSocialNet;
	
	// Instance variables
	NSString *_deviceLanguageCode;

	NSString *_mainStoryboardName;
	FXDStoryboard *_mainStoryboard;

	id _rootScene;
	id _homeScene;
}

// Properties
@property (assign, nonatomic) BOOL didMakePurchase;
@property (assign, nonatomic) BOOL didShareToSocialNet;

@property (strong, nonatomic) NSString *deviceLanguageCode;

@property (strong, nonatomic) NSString *mainStoryboardName;
@property (strong, nonatomic) FXDStoryboard *mainStoryboard;

@property (strong, nonatomic) id rootScene;
@property (strong, nonatomic) id homeScene;


#pragma mark - Public
+ (FXDsuperGlobalManager*)sharedInstance;

- (void)prepareGlobalManagerAtLaunchWithWindowLoadingBlock:(void(^)(void))windowLoadingBlock;

#warning @"//TODO: refactor following method to be organized into categories or subclasses

+ (BOOL)isSystemVersionLatest;

+ (NSString*)deviceModelName;

+ (NSString*)deviceCountryCode;

+ (NSString*)deviceLanguageCode;


+ (void)alertWithMessage:(NSString*)message withTitle:(NSString*)title;
+ (void)alertCancelAndOKwithMessage:(NSString*)message withTitle:(NSString*)title alertDelegate:(id)alertDelegate;

+ (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;

+ (void)printoutListOfFonts;

+ (void)presentMailComposeInterfaceForPresentingInterface:(UIViewController*)presentingInterface usingImage:(UIImage*)image usingMessage:(NSString*)message;

- (MFMailComposeViewController*)preparedMailComposeInterface;
- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message;
- (void)presentMailComposeInterfaceForPresentingInterface:(UIViewController*)presentingInterface usingImage:(UIImage*)image usingMessage:(NSString*)message;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate
#pragma mark - MFMailComposeViewControllerDelegate


@end
