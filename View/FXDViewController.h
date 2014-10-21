
#import "FXDKit.h"


@interface FXDViewController : UIViewController {
	CGRect _initialBounds;
	FXDcallbackFinish _dismissedCallback;
}

@property (nonatomic) CGRect initialBounds;

@property (copy) FXDcallbackFinish dismissedCallback;

@end


@interface UIViewController (Essential)

- (IBAction)dismissSceneForEventSender:(id)sender;


- (UIView*)sceneViewFromNibNameOrNil:(NSString*)nibNameOrNil;

- (void)sceneTransitionForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;
- (void)animateSceneUpdatingForForcedSize:(CGSize)forcedSize forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;

- (CGRect)sceneFrameForTransform:(CGAffineTransform)transform forXYratio:(CGPoint)xyRatio insideSize:(CGSize)size;

- (void)fadeInAndAddScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withFinishCallback:(FXDcallbackFinish)finishCallback withDismissedCallback:(FXDcallbackFinish)dismissedCallback;
- (void)fadeOutAndRemoveScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withFinishCallback:(FXDcallbackFinish)finishCallback;

@end
