//
//  FXDWindow.h
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDsuperProgressView.h"
#import "FXDsuperMessageView.h"


@class FXDsuperLaunchScene;


@interface FXDWindow : UIWindow
// IBOutlets
@property (strong, nonatomic) IBOutlet FXDsuperProgressView *progressView;
@property (strong, nonatomic) IBOutlet FXDsuperMessageView *messageView;


#pragma mark - IBActions

#pragma mark - Public
- (void)prepareWindowWithLaunchScene:(FXDsuperLaunchScene*)launchScene;
- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)showProgressViewAfterDelay:(NSTimeInterval)delay;
- (void)hideProgressViewAfterDelay:(NSTimeInterval)delay;

- (void)showProgressViewWithNibName:(NSString*)nibName;
- (void)hideProgressView;

- (void)showMessageViewWithNibName:(NSString*)nibName withTitle:(NSString*)title message:(NSString*)message  cancelButtonTitle:(NSString*)cancelButtonTitle acceptButtonTitle:(NSString*)acceptButtonTitle  clickedButtonAtIndexBlock:(FXDcallbackAlert)clickedButtonAtIndexBlock;
- (void)hideMessageView;


//MARK: - Observer implementation
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification;

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIWindow (Added)
+ (instancetype)instantiateNewWindow;

- (void)windowTransitionForSize:(CGSize)size forTransform:(CGAffineTransform)transform forDuration:(NSTimeInterval)duration;

@end
