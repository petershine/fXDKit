
#import "FXDKit.h"


@interface FXDViewController : UIViewController {
	FXDcallbackFinish _dismissedCallback;
}

@property (copy) FXDcallbackFinish dismissedCallback;

@end


@interface UIViewController (Essential)

- (IBAction)dismissSceneWithAnimation:(id)sender;


- (UIView*)sceneViewFromNibNameOrNil:(NSString*)nibNameOrNil;

- (void)sceneTransitionForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;

- (CGRect)animatedFrameForTransform:(CGAffineTransform)transform forSize:(CGSize)size forDeviceOrientation:(UIDeviceOrientation)deviceOrientation forXYratio:(CGPoint)xyRatio;

- (void)fadeInAndAddScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withDismissedCallback:(FXDcallbackFinish)dismissedCallback withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)fadeOutAndRemoveScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withDismissedCallback:(FXDcallbackFinish)dismissedCallback withFinishCallback:(FXDcallbackFinish)finishCallback;

@end
