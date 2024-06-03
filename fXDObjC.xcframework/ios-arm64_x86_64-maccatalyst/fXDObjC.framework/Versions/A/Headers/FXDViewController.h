
#import <fXDObjC/FXDimportEssential.h>
#import <fXDObjC/FXDStoryboardSegue.h>


@interface FXDViewController : UIViewController {
	CGRect _initialBounds;
	FXDcallbackFinish _dismissedBlock;
}

@property (nonatomic) CGRect initialBounds;
@property (copy) FXDcallbackFinish dismissedBlock;

@end


@interface UIViewController (Essential)

- (void)sceneTransitionForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback;
- (void)animateSceneUpdatingForForcedSize:(CGSize)forcedSize forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;

- (CGRect)sceneFrameForTransform:(CGAffineTransform)transform forXYratio:(CGPoint)xyRatio insideSize:(CGSize)size;

- (void)addChildScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback withDismissedBlock:(FXDcallbackFinish)dismissedBlock;
- (void)removeChildScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback;

- (void)presentBySlidingForDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback;
- (void)dismissBySlidingForDuration:(NSTimeInterval)duration withCallback:(FXDcallbackFinish)finishCallback;

- (void)presentScene:(UIViewController*)presentedScene shouldSlide:(BOOL)shouldSlide withCallback:(FXDcallbackFinish)finishCallback;
- (void)dismissScene:(UIViewController*)dismissedScene shouldSlide:(BOOL)shouldSlide withCallback:(FXDcallbackFinish)finishCallback;


- (CGRect)centeredDisplayFrameForForcedSize:(CGSize)forcedSize withPresentationSize:(CGSize)presentationSize;

@end
