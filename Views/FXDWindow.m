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
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// Primitives
	
	// Instance variables
	
	// Properties
}


#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {	//FXDLog_DEFAULT;
	[super awakeFromNib];

	// Primitives

	// Instance variables

	// Properties

	// IBOutlets

	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedApplicationWindowShouldFadeInProgressView:)
	 name:notificationApplicationWindowShouldFadeInProgressView
	 object:nil];
	
	[defaultCenter
	 addObserver:self
	 selector:@selector(observedApplicationWindowShouldFadeOutProgressView:)
	 name:notificationApplicationWindowShouldFadeOutProgressView
	 object:nil];
	
	
	[defaultCenter
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
- (void)observedApplicationWindowShouldFadeInProgressView:(NSNotification*)notification {	FXDLog_DEFAULT;
	[self showProgressViewWithNibName:nil];
}

- (void)observedApplicationWindowShouldFadeOutProgressView:(NSNotification*)notification {
	
	if (self.progressView) {
		[self removeAsFadeOutSubview:self.progressView
						afterRemovedBlock:^{	FXDLog_DEFAULT;
							self.progressView = nil;
						}];
	}
}

- (void)observedUIDeviceOrientationDidChangeNotification:(NSNotification*)notification {	//FXDLog_DEFAULT;
	//FXDLog(@"notification: %@", notification);

	if (self.progressView.viewIndicatorGroup) {
		self.progressView.viewIndicatorGroup.transform = CGAffineTransformIdentity;

		//FXDLog(@"[UIDevice currentDevice].orientation: %d", [UIDevice currentDevice].orientation);
		UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

		if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {

			CGAffineTransform modifiedTransform = self.progressView.viewIndicatorGroup.transform;

			if (orientation == UIDeviceOrientationLandscapeLeft) {
				modifiedTransform = CGAffineTransformRotate(modifiedTransform, ((90)/180.0 * M_PI));
			}
			else if (orientation == UIDeviceOrientationLandscapeRight) {
				modifiedTransform = CGAffineTransformRotate(modifiedTransform, ((270)/180.0 * M_PI));
			}

			self.progressView.viewIndicatorGroup.transform = modifiedTransform;
		}
	}
}

//MARK: - Delegate implementation


@end


#pragma mark - Category
@implementation UIWindow (Added)
+ (id)applicationWindow {
	FXDWindow *applicationWindow = [[UIApplication sharedApplication].delegate performSelector:@selector(window)];
	
	return applicationWindow;
}

+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		FXDWindow *applicationWindow = [self applicationWindow];

		[NSObject cancelPreviousPerformRequestsWithTarget:applicationWindow selector:@selector(showDefaultProgressView) object:nil];
		[applicationWindow performSelector:@selector(showDefaultProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	}];
}

+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		FXDWindow *applicationWindow = [self applicationWindow];

		[NSObject cancelPreviousPerformRequestsWithTarget:applicationWindow selector:@selector(hideProgressView) object:nil];
		[applicationWindow performSelector:@selector(hideProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	}];
}

- (void)showCustomProgressView {	FXDLog_DEFAULT;
	[self showProgressViewWithNibName:nibnameCustomProgressView];
}

- (void)showDefaultProgressView {	//FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedApplicationWindowShouldFadeInProgressView:nil];
}

- (void)showProgressViewWithNibName:(NSString*)nibName {	FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	FXDLog(@"nibName: %@", nibName);

	if (applicationWindow.progressView == nil) {
		applicationWindow.progressView = [FXDsuperProgressView viewFromNibName:nibName];

		CGRect modifiedFrame = applicationWindow.progressView.frame;
		modifiedFrame.size = applicationWindow.frame.size;
		[applicationWindow.progressView setFrame:modifiedFrame];

		[applicationWindow observedUIDeviceOrientationDidChangeNotification:nil];

		[applicationWindow addSubview:applicationWindow.progressView];
		[applicationWindow bringSubviewToFront:applicationWindow.progressView];

		[applicationWindow.progressView fadeInFromHidden];
	}
}

- (void)hideProgressView {	//FXDLog_DEFAULT;
	FXDWindow *applicationWindow = [[self class] applicationWindow];
	
	[applicationWindow observedApplicationWindowShouldFadeOutProgressView:nil];
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
		 dismissLaunchControllerWithDidFinishBlock:^(BOOL finished) {
			 FXDLog_DEFAULT;
			 FXDLog(@"finished: %d launchController: %@", finished, launchController);
			 [launchController.view removeFromSuperview];
			 
			 if (finishedAnimationBlock) {
				 finishedAnimationBlock();
			 }
		 }];
		
		return;
	}
	
	
	[UIView
	 animateWithDuration:delayOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 [launchController.view setAlpha:0.0];
	 } completion:^(BOOL finished) {
		 FXDLog_DEFAULT;
		 FXDLog(@"finished: %d launchController: %@", finished, launchController);
		 [launchController.view removeFromSuperview];
		 
		 if (finishedAnimationBlock) {
			 finishedAnimationBlock();
		 }
	 }];
}

@end
