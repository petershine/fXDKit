//
//  FXDWindow.h
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#define delayBeforeShowOrHideProgressView	1.0

#define notificationApplicationWindowShouldFadeInProgressView	@"notificationApplicationWindowShouldFadeInProgressView"
#define notificationApplicationWindowShouldFadeOutProgressView	@"notificationApplicationWindowShouldFadeOutProgressView"


#import "FXDsuperProgressView.h"

@class FXDsuperLaunchImageController;


@interface FXDWindow : UIWindow

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDsuperProgressView *progressView;


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedApplicationWindowShouldFadeInProgressView:(NSNotification*)notification;
- (void)observedApplicationWindowShouldFadeOutProgressView:(NSNotification*)notification;

- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification;

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface UIWindow (Added)
+ (id)applicationWindow;

+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay;
+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay;

- (void)showCustomProgressView;
- (void)showDefaultProgressView;
- (void)showProgressViewWithNibName:(NSString*)nibName;

- (void)hideProgressView;

- (void)prepareWithLaunchImageController:(FXDsuperLaunchImageController*)launchImageController;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeRootViewControllerBlock:(void (^)(void))willBecomeRootViewControllerBlock didBecomeRootViewControllerBlock:(void (^)(void))didBecomeRootViewControllerBlock finishedAnimationBlock:(void(^)(void))finishedAnimationBlock;

@end

