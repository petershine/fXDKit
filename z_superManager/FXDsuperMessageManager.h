//
//  FXDsuperMessageManager.h
//
//
//  Created by petershine on 3/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@import MessageUI;


@interface FXDsuperMessageManager : FXDsuperManager <MFMailComposeViewControllerDelegate>

#pragma mark - Initialization

#pragma mark - Public
- (void)presentEmailScene:(MFMailComposeViewController*)emailScene forPresentingScene:(UIViewController*)presentingScene usingImage:(UIImage*)image usingMessage:(NSString*)message;
- (MFMailComposeViewController*)emailSceneWithMailBody;
- (MFMailComposeViewController*)emailSceneForSharingImage:(UIImage*)image usingMessage:(NSString*)message;

@end
