//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDViewController+BarButton.h"


@interface FXDViewController : UIViewController {
	FXDcallbackFinish _dismissedCallback;
}

@property (copy, nonatomic) FXDcallbackFinish dismissedCallback;

// IBOutlets

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

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

- (void)fadeInAndAddScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)fadeOutAndRemoveScene:(UIViewController*)scene forDuration:(NSTimeInterval)duration withFinishCallback:(FXDcallbackFinish)finishCallback;

@end
