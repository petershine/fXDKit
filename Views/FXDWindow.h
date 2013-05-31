//
//  FXDWindow.h
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#define delayBeforeShowOrHideProgressView	1.0

#define notificationFXDWindowShouldFadeInProgressView	@"notificationFXDWindowShouldFadeInProgressView"
#define notificationFXDWindowShouldFadeOutProgressView	@"notificationFXDWindowShouldFadeOutProgressView"


#ifndef classnameProgressView
	#define classnameProgressView	@"FXDsuperProgressView"
#endif

#ifndef classnameMessageView
	#define classnameMessageView	@"FXDsuperMessageView"
#endif


#import "FXDsuperProgressView.h"
#import "FXDsuperMessageView.h"


@class FXDsuperLaunchController;


@interface FXDWindow : UIWindow

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDsuperProgressView *progressView;
@property (strong, nonatomic) IBOutlet FXDsuperMessageView *messageView;


#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation
- (void)observedFXDWindowShouldFadeInProgressView:(NSNotification*)notification;
- (void)observedFXDWindowShouldFadeOutProgressView:(NSNotification*)notification;

- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIWindow (Added)
+ (id)applicationWindow;

- (void)prepareWithLaunchImageController:(FXDsuperLaunchController*)launchImageController;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeRootViewControllerBlock:(void(^)(void))willBecomeRootViewControllerBlock didBecomeRootViewControllerBlock:(void(^)(void))didBecomeRootViewControllerBlock finishedAnimationBlock:(void(^)(void))finishedAnimationBlock;

@end

@interface UIWindow (Progress)
+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay;
+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay;

- (void)showDefaultProgressView;
- (void)showProgressViewWithNibName:(NSString*)nibName;

- (void)hideProgressView;

@end

@interface UIWindow (Message)
- (void)showMessageViewWithNibName:(NSString*)nibName withTitle:(NSString*)title message:(NSString*)message  cancelButtonTitle:(NSString*)cancelButtonTitle acceptButtonTitle:(NSString*)acceptButtonTitle  clickedButtonAtIndexBlock:(FXDcallbackBlockForAlert)clickedButtonAtIndexBlock;

- (void)hideMessageView;

@end

