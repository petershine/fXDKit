//
//  FXDWindow.m
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDWindow.h"

#import "FXDsuperLaunchController.h"


#pragma mark - Public implementation
@implementation FXDWindow


#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {	FXDLog_DEFAULT;
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	//MARK: Assume this should be the default;
	self.backgroundColor = [UIColor clearColor];

	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFXDWindowShouldFadeInProgressView:)
	 name:notificationFXDWindowShouldFadeInProgressView
	 object:nil];
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedFXDWindowShouldFadeOutProgressView:)
	 name:notificationFXDWindowShouldFadeOutProgressView
	 object:nil];
	
	
	[notificationCenter
	 addObserver:self
	 selector:@selector(observedUIDeviceOrientationDidChangeNotification:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:nil];
}


#pragma mark - Property overriding

#pragma mark - Method overriding

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation
- (void)observedFXDWindowShouldFadeInProgressView:(NSNotification*)notification {	//FXDLog_DEFAULT;
	[self showProgressViewWithNibName:nil];
}

- (void)observedFXDWindowShouldFadeOutProgressView:(NSNotification*)notification {
	
	if (self.progressView == nil) {
		return;
	}
	
	
	[self
	 removeAsFadeOutSubview:self.progressView
	 afterRemovedBlock:^{	//FXDLog_DEFAULT;
		 self.progressView = nil;
	 }];
}

- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification {
	//FXDLogObject(notification);

	if (self.progressView.viewIndicatorGroup == nil) {
		return;
	}

	
#if	TEST_loggingRotatingOrientation
	FXDLog_DEFAULT;
#endif

	self.progressView.viewIndicatorGroup.transform = CGAffineTransformIdentity;
	
	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

	if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
		CGAffineTransform modifiedTransform = self.progressView.viewIndicatorGroup.transform;
		
		if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
			modifiedTransform = CGAffineTransformRotate(modifiedTransform, ((90)/180.0 * M_PI));
		}
		else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
			modifiedTransform = CGAffineTransformRotate(modifiedTransform, ((270)/180.0 * M_PI));
		}
		
		self.progressView.viewIndicatorGroup.transform = modifiedTransform;
	}
}

//MARK: - Delegate implementation

@end


#pragma mark - Category
@implementation UIWindow (Added)
+ (instancetype)instantiateDefaultWindow {
	id defaultWindow = [[[self class] alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[(FXDWindow*)defaultWindow setBackgroundColor:[UIColor blackColor]];

	return defaultWindow;
}

+ (instancetype)applicationWindow {
	id applicationWindow = nil;

	if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
		applicationWindow = [[UIApplication sharedApplication].delegate performSelector:@selector(window)];
	}

	return applicationWindow;
}

#pragma mark -
- (void)prepareWithLaunchImageController:(FXDsuperLaunchController*)launchImageController {	FXDLog_DEFAULT;
	if (launchImageController == nil) {
		launchImageController = [[FXDsuperLaunchController alloc] initWithNibName:nil bundle:nil];
	}
	
	CGRect modifiedFrame = launchImageController.view.frame;
	modifiedFrame.size.height = self.frame.size.height;
	[launchImageController.view setFrame:modifiedFrame];
	
	modifiedFrame = launchImageController.imageviewDefault.frame;
	modifiedFrame.origin.y = 0.0;
	modifiedFrame.size.height = self.frame.size.height;
	[launchImageController.imageviewDefault setFrame:modifiedFrame];
	
	[self setRootViewController:launchImageController];
}

- (void)configureRootViewController:(UIViewController*)rootViewController shouldAnimate:(BOOL)shouldAnimate willBecomeRootViewControllerBlock:(void(^)(void))willBecomeRootViewControllerBlock didBecomeRootViewControllerBlock:(void(^)(void))didBecomeRootViewControllerBlock finishedAnimationBlock:(void(^)(void))finishedAnimationBlock {	FXDLog_DEFAULT;
	
	//MARK: fade in and replace rootViewController. DO NOT USE addChildViewController
	if (shouldAnimate == NO) {
		if (willBecomeRootViewControllerBlock) {
			willBecomeRootViewControllerBlock();
		}

		[self setRootViewController:rootViewController];

		if (didBecomeRootViewControllerBlock) {
			didBecomeRootViewControllerBlock();
		}

		if (finishedAnimationBlock) {
			finishedAnimationBlock();
		}

		return;
	}
	

	if (willBecomeRootViewControllerBlock) {
		willBecomeRootViewControllerBlock();
	}

	UIViewController *launchController = self.rootViewController;
	
	[self setRootViewController:rootViewController];

	[self addSubview:launchController.view];
	
	
	if (didBecomeRootViewControllerBlock) {
		didBecomeRootViewControllerBlock();
	}

	if ([launchController isKindOfClass:[FXDsuperLaunchController class]]) {

		[(FXDsuperLaunchController*)launchController
		 dismissLaunchControllerWithDidFinishBlock:^(BOOL finished, id responseObj) {
			 FXDLog_BLOCK(launchController, @selector(dismissLaunchControllerWithDidFinishBlock:));

			 FXDLog(@"%@ %@", strBOOL(finished), strObject(launchController));
			 [launchController.view removeFromSuperview];
			 
			 if (finishedAnimationBlock) {
				 finishedAnimationBlock();
			 }
		 }];
		
		return;
	}
	
	
	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 launchController.view.alpha = 0.0;
	 }
	 completion:^(BOOL finished) {
		 FXDLog(@"animateWithDuration %@ %@", strBOOL(finished), strObject(launchController));
		 [launchController.view removeFromSuperview];
		 
		 if (finishedAnimationBlock) {
			 finishedAnimationBlock();
		 }
	 }];
}

@end


@implementation UIWindow (Progress)
+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 FXDWindow *applicationWindow = [self applicationWindow];
		 
		 [NSObject cancelPreviousPerformRequestsWithTarget:applicationWindow selector:@selector(showDefaultProgressView) object:nil];
		 [applicationWindow performSelector:@selector(showDefaultProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{
		 FXDWindow *applicationWindow = [self applicationWindow];
		 
		 [NSObject cancelPreviousPerformRequestsWithTarget:applicationWindow selector:@selector(hideProgressView) object:nil];
		 [applicationWindow performSelector:@selector(hideProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

#pragma mark -
- (void)showDefaultProgressView {	//FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedFXDWindowShouldFadeInProgressView:nil];
}

- (void)showProgressViewWithNibName:(NSString*)nibName {
	
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	if (applicationWindow.progressView) {
		return;
	}
	

	//FXDLog_DEFAULT;

	Class progressViewClass = NSClassFromString(classnameProgressView);
	FXDLog(@"%@ %@", strObject(progressViewClass), strObject(nibName));
	
	applicationWindow.progressView = [progressViewClass viewFromNibName:nibName];
	
	CGRect modifiedFrame = applicationWindow.progressView.frame;
	modifiedFrame.size = applicationWindow.frame.size;
	[applicationWindow.progressView setFrame:modifiedFrame];
	
	[applicationWindow observedUIDeviceOrientationDidChangeNotification:nil];
	
	[applicationWindow addSubview:applicationWindow.progressView];
	[applicationWindow bringSubviewToFront:applicationWindow.progressView];
	
	[applicationWindow.progressView fadeInFromHidden];
}

- (void)hideProgressView {	//FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedFXDWindowShouldFadeOutProgressView:nil];
}

@end

@implementation UIWindow (Message)
- (void)showMessageViewWithNibName:(NSString*)nibName withTitle:(NSString*)title message:(NSString*)message  cancelButtonTitle:(NSString*)cancelButtonTitle acceptButtonTitle:(NSString*)acceptButtonTitle  clickedButtonAtIndexBlock:(FXDblockAlertCallback)clickedButtonAtIndexBlock {
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	if (applicationWindow.messageView) {
		return;
	}


	FXDLog_DEFAULT;
	
	Class messageViewClass = NSClassFromString(classnameMessageView);
	FXDLog(@"%@ %@", strObject(messageViewClass), strObject(nibName));
	
	applicationWindow.messageView = [messageViewClass viewFromNibName:nibName];
	applicationWindow.messageView.callbackBlock = clickedButtonAtIndexBlock;
	
	CGRect modifiedFrame = applicationWindow.messageView.frame;
	modifiedFrame.size = applicationWindow.frame.size;
	[applicationWindow.messageView setFrame:modifiedFrame];
	
	[applicationWindow observedUIDeviceOrientationDidChangeNotification:nil];
	
	
	applicationWindow.messageView.labelTitle.text = title;
	
	if (applicationWindow.messageView.textviewMessage) {
		applicationWindow.messageView.textviewMessage.text = message;
	}
	else {
		applicationWindow.messageView.labelMessage_0.text = message;
	}
	
	[applicationWindow.messageView configureWithCancelButtonTitle:cancelButtonTitle withAcceptButtonTitle:acceptButtonTitle];
	
	
	[applicationWindow addSubview:applicationWindow.messageView];
	[applicationWindow bringSubviewToFront:applicationWindow.messageView];
	
	[applicationWindow.messageView fadeInFromHidden];
}

- (void)hideMessageView {
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	if (applicationWindow.messageView == nil) {
		return;
	}
	
	
	[applicationWindow
	 removeAsFadeOutSubview:applicationWindow.messageView
	 afterRemovedBlock:^{	//FXDLog_DEFAULT;
		 applicationWindow.messageView = nil;
	 }];
}

@end
