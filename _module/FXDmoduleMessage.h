
@import MessageUI;

#import "FXDKit.h"


@interface FXDmoduleMessage : FXDsuperModule <MFMailComposeViewControllerDelegate>

- (void)presentEmailScene:(MFMailComposeViewController*)emailScene forPresentingScene:(UIViewController*)presentingScene usingImage:(UIImage*)image usingMessage:(NSString*)message;
- (MFMailComposeViewController*)emailSceneWithMailBody;
- (MFMailComposeViewController*)emailSceneForSharingImage:(UIImage*)image usingMessage:(NSString*)message;

@end
