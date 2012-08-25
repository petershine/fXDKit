//
//  FXDsuperGlobalControl.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "Reachability.h"


#import "FXDKit.h"

@class FXDStoryboard;


@interface FXDsuperGlobalControl : NSObject <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference	
	BOOL _didMakePurchase;
	BOOL _didShareToSocialNet;
	
	NSString *_deviceLanguageCode;
	
	FXDStoryboard *_mainStoryboard;
	id _rootScene;
	id _homeScene;
}

// Properties
@property (assign, nonatomic) BOOL didMakePurchase;
@property (assign, nonatomic) BOOL didShareToSocialNet;

@property (strong, nonatomic) NSString *deviceLanguageCode;

@property (strong, nonatomic) FXDStoryboard *mainStoryboard;
@property (strong, nonatomic) id rootScene;
@property (strong, nonatomic) id homeScene;


#pragma mark - Memory management

#pragma mark - Initialization


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public
+ (FXDsuperGlobalControl*)sharedInstance;

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
