//
//  FXDsuperMessageManager.h
//
//
//  Created by petershine on 3/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@interface FXDsuperMessageManager : FXDsuperManager <MFMailComposeViewControllerDelegate>
// Properties

#pragma mark - Initialization
+ (FXDsuperMessageManager*)sharedInstance;


#pragma mark - Public
- (void)presentEmailController:(MFMailComposeViewController*)emailController forPresentingController:(UIViewController*)presentingController usingImage:(UIImage*)image usingMessage:(NSString*)message;
- (MFMailComposeViewController*)preparedMailComposeInterface;
- (MFMailComposeViewController*)preparedMailComposeInterfaceForSharingUsingImage:(UIImage*)image usingMessage:(NSString*)message;

@end
