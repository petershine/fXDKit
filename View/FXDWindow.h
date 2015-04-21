
@import UIKit;
@import Foundation;

#import "FXDimportCore.h"


@class FXDsubviewInformation;

@class FXDsceneLaunching;


@interface FXDWindow : UIWindow

@property (strong, nonatomic) IBOutlet FXDsubviewInformation *informationSubview;


- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)showInformationViewAfterDelay:(NSTimeInterval)delay;
- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay;

- (void)showInformationViewWithClassName:(NSString*)className;
- (void)hideInformationView;

@end


@interface UIWindow (Essential)
+ (instancetype)newDefaultWindow;

@end