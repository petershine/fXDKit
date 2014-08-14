
#import "FXDKit.h"


typedef UIView* (^FXDblockHitTest)(UIView *testedView, CGPoint point, UIEvent *event);


@class FXDsubviewInformation;

@class FXDsceneLaunching;


@interface FXDWindow : UIWindow {
	FXDblockHitTest _hitTestBlock;
}

@property (copy, nonatomic) FXDblockHitTest hitTestBlock;

@property (strong, nonatomic) IBOutlet FXDsubviewInformation *informationSubview;


- (void)prepareWindowWithLaunchScene:(FXDsceneLaunching*)launchScene;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)showInformationViewAfterDelay:(NSTimeInterval)delay;
- (void)hideInformationViewAfterDelay:(NSTimeInterval)delay;

- (void)showInformationViewWithClassName:(NSString*)className;
- (void)hideInformationView;

@end


@interface UIWindow (Essential)
+ (instancetype)newDefaultWindow;

@end
