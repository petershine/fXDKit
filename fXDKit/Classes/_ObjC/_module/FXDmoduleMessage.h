
#import "FXDimportEssential.h"
#import "FXDWindow.h"


@interface FXDmoduleMessage : NSObject <MFMailComposeViewControllerDelegate>

- (void)presentEmailScene:(MFMailComposeViewController*)emailScene forPresentingScene:(UIViewController*)presentingScene usingImage:(UIImage*)image usingMessage:(NSString*)message withRecipients:(NSArray*)recipients;

- (MFMailComposeViewController*)emailSceneWithMailBodyWithRecipients:(NSArray*)recipients;
- (MFMailComposeViewController*)emailSceneForSharingImage:(UIImage*)image usingMessage:(NSString*)message;

@end
