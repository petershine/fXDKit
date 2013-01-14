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


#import "FXDviewProgress.h"


@interface FXDWindow : UIWindow {
    // Primitives
	
	// Instance variables
}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDviewProgress *progressView;


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

- (void)configureRootViewController:(UIViewController*)rootViewController withAnimation:(BOOL)withAnimation willBecomeRootViewControllerBlock:(void (^)(void))willBecomeRootViewControllerBlock didBecomeRootViewControllerBlock:(void (^)(void))didBecomeRootViewControllerBlock finishedAnimationBlock:(void(^)(void))finishedAnimationBlock;

@end

