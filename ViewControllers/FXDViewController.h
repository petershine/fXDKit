//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//


@interface FXDViewController : UIViewController {
	FXDcallbackFinish _dismissedCallback;
}

@property (copy, nonatomic) FXDcallbackFinish dismissedCallback;

@end


#pragma mark - Category
@interface UIViewController (Added)

#pragma mark - IBActions
- (IBAction)popToRootSceneWithAnimation:(id)sender;
- (IBAction)popSceneWithAnimation:(id)sender;

- (IBAction)dismissSceneWithAnimation:(id)sender;

#pragma mark - Public
- (UIView*)sceneViewFromNibNameOrNil:(NSString*)nibNameOrNil;

- (void)sceneTransitionForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;

- (CGRect)animatedFrameForTransform:(CGAffineTransform)transform forSize:(CGSize)size forDeviceOrientation:(UIDeviceOrientation)deviceOrientation forXYratio:(CGPoint)xyRatio;

- (void)fadeInAndAddScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withDismissedCallback:(FXDcallbackFinish)dismissedCallback withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)fadeOutAndRemoveScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withDismissedCallback:(FXDcallbackFinish)dismissedCallback withFinishCallback:(FXDcallbackFinish)finishCallback;

@end
