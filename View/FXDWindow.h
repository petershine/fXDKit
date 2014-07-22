
#import "FXDKit.h"


@class FXDviewInformation;

@class FXDsceneLaunching;


@interface FXDWindow : UIWindow

@property (strong, nonatomic) IBOutlet FXDviewInformation *informationView;


- (void)prepareWindowWithLaunchScene:(FXDsceneLaunching*)launchScene;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)showInformationViewAfterDelay:(NSTimeInterval)delay;
- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay;

- (void)showInformationViewWithClassName:(NSString*)className;
- (void)hideProgressView;

@end


@interface UIWindow (Essential)
+ (instancetype)newDefaultWindow;

@end
