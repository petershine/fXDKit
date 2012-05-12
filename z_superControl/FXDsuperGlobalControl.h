//
//  FXDsuperGlobalControl.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDKit.h"

#import <stdarg.h>
#import <sys/utsname.h>

#import <MessageUI/MessageUI.h>
#import <TargetConditionals.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "Reachability.h"


@interface FXDsuperGlobalControl : FXDObject <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	BOOL _didMakePurchase;
	BOOL _didShareToSocialNet;
	
	// Controllers
	FXDStoryboard *_mainStoryboard;
	id _rootInterface;
	id _homeInterface;
}

// Properties
@property (nonatomic, assign) BOOL didMakePurchase;
@property (nonatomic, assign) BOOL didShareToSocialNet;

// Controllers
@property (retain, nonatomic) FXDStoryboard *mainStoryboard;
@property (retain, nonatomic) id rootInterface;
@property (retain, nonatomic) id homeInterface;


#pragma mark - Memory management

#pragma mark - Initialization


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperGlobalControl*)sharedInstance;
+ (void)releaseSharedInstance;


+ (NSString*)deviceModelName;

+ (BOOL)isOSversionNew;

+ (NSString*)deviceCountryCode;

+ (NSString*)firstLanguageIdentifier;

+ (void)alertWithMessage:(NSString*)message withTitle:(NSString*)title;

+ (void)localNotificationWithAlertBody:(NSString*)alertBody afterDelay:(NSTimeInterval)delay;

+ (void)printoutListOfFonts;

+ (void)presentMailComposeInterfaceForPresentingInterface:(UIViewController*)presentingInterface usingImage:(UIImage*)image usingMessage:(NSString*)message;

- (MFMailComposeViewController*)preparedMailComposeInterface;
- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message;
- (void)presentMailComposeInterfaceForPresentingInterface:(UIViewController*)presentingInterface usingImage:(UIImage*)image usingMessage:(NSString*)message;


//MARK: - Observer implementation
- (void)observedApplicationDidEnterBackground:(id)notification;

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate
#pragma mark - MFMailComposeViewControllerDelegate


@end
