

@import MessageUI;


#import "FXDsuperModule.h"
@interface FXDmoduleMessage : FXDsuperModule <MFMailComposeViewControllerDelegate>

- (void)presentEmailScene:(MFMailComposeViewController*)emailScene forPresentingScene:(UIViewController*)presentingScene usingImage:(UIImage*)image usingMessage:(NSString*)message;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) MFMailComposeViewController *emailSceneWithMailBody;
- (MFMailComposeViewController*)emailSceneForSharingImage:(UIImage*)image usingMessage:(NSString*)message;

@end
