
#import "FXDKit.h"


@class FXDviewInformation;

@class FXDsceneLaunching;


@interface FXDWindow : UIWindow
// IBOutlets
@property (strong, nonatomic) IBOutlet FXDviewInformation *informationView;


- (void)prepareWindowWithLaunchScene:(FXDsceneLaunching*)launchScene;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)showProgressViewAfterDelay:(NSTimeInterval)delay;
- (void)hideProgressViewAfterDelay:(NSTimeInterval)delay;

- (void)showProgressViewWithNibName:(NSString*)nibName;
- (void)hideProgressView;

#pragma mark - Observer
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification;

#pragma mark - Delegate

@end


@interface UIWindow (Essential)
+ (instancetype)newDefaultWindow;

@end
