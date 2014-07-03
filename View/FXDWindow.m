//
//  FXDWindow.m
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#import "FXDWindow.h"

#import "FXDviewInformation.h"

#import "FXDsceneLaunching.h"


@implementation FXDWindow

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
	
    return self;
}

- (void)awakeFromNib {	FXDLog_DEFAULT;
	[super awakeFromNib];

	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(observedUIDeviceOrientationDidChange:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:nil];
}


#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)makeKeyAndVisible {	FXDLog_SEPARATE;
	[super makeKeyAndVisible];
}


#pragma mark - IBActions

#pragma mark - Public
- (void)prepareWindowWithLaunchScene:(FXDsceneLaunching*)launchScene {	FXDLog_DEFAULT;
	if (launchScene == nil) {
		launchScene = [[FXDsceneLaunching alloc] initWithNibName:nil bundle:nil];
	}

	CGRect modifiedFrame = launchScene.view.frame;
	modifiedFrame.size.height = self.frame.size.height;
	launchScene.view.frame = modifiedFrame;

	modifiedFrame = launchScene.imageviewDefault.frame;
	modifiedFrame.origin.y = 0.0;
	modifiedFrame.size.height = self.frame.size.height;
	launchScene.imageviewDefault.frame = modifiedFrame;

	[self setRootViewController:launchScene];
}

- (void)configureRootViewController:(UIViewController*)rootScene shouldAnimate:(BOOL)shouldAnimate willBecomeBlock:(void(^)(void))willBecomeBlock didBecomeBlock:(void(^)(void))didBecomeBlock withFinishCallback:(FXDcallbackFinish)finishCallback {	FXDLog_DEFAULT;

	//MARK: fade in and replace rootViewController. DO NOT USE addChildViewController
	if (shouldAnimate == NO) {
		if (willBecomeBlock) {
			willBecomeBlock();
		}

		[self setRootViewController:rootScene];

		if (didBecomeBlock) {
			didBecomeBlock();
		}

		if (finishCallback) {
			finishCallback(_cmd, YES, nil);
		}
		return;
	}


	if (willBecomeBlock) {
		willBecomeBlock();
	}

	UIViewController *launchScene = self.rootViewController;

	[self setRootViewController:rootScene];

	[self addSubview:launchScene.view];


	if (didBecomeBlock) {
		didBecomeBlock();
	}

	if ([launchScene isKindOfClass:[FXDsceneLaunching class]]) {

		[(FXDsceneLaunching*)launchScene
		 dismissLaunchSceneWithFinishCallback:^(SEL caller, BOOL didFinish, id responseObj) {
			 FXDLog_BLOCK(launchScene, caller);
			 FXDLogBOOL(didFinish);

			 [launchScene.view removeFromSuperview];

			 if (finishCallback) {
				 finishCallback(_cmd, didFinish, responseObj);
			 }
		 }];

		return;
	}


	[UIView
	 animateWithDuration:durationOneSecond
	 delay:0.0
	 options:UIViewAnimationOptionCurveEaseIn
	 animations:^{
		 launchScene.view.alpha = 0.0;
	 }
	 completion:^(BOOL didFinish) {

		 [launchScene.view removeFromSuperview];

		 if (finishCallback) {
			 finishCallback(_cmd, YES, nil);
		 }
	 }];
}

#pragma mark -
- (void)showProgressViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showProgressViewWithNibName:) object:nil];
		 [self performSelector:@selector(showProgressViewWithNibName:) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

- (void)hideProgressViewAfterDelay:(NSTimeInterval)delay {
	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideProgressView) object:nil];
		 [self performSelector:@selector(hideProgressView) withObject:nil afterDelay:delay inModes:@[NSRunLoopCommonModes]];
	 }];
}

#pragma mark -
- (void)showProgressViewWithNibName:(NSString*)nibName {

	if (self.informationView) {
		return;
	}


	self.informationView = [FXDviewInformation viewFromNibName:nibName];

	CGRect modifiedFrame = self.informationView.frame;
	modifiedFrame.size = self.frame.size;
	self.informationView.frame = modifiedFrame;

	[self addSubview:self.informationView];
	[self bringSubviewToFront:self.informationView];

	[self.informationView fadeInFromHidden];
}

- (void)hideProgressView {

	if (self.informationView == nil) {
		return;
	}


	[self
	 removeAsFadeOutSubview:self.informationView
	 afterRemovedBlock:^{
		 self.informationView = nil;
	 }];
}


#pragma mark - Observer
- (void)observedUIDeviceOrientationDidChange:(NSNotification*)notification {

	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

	if (UIDeviceOrientationIsValidInterfaceOrientation(deviceOrientation) == NO) {
		return;
	}


	FXDLog_OVERRIDE;
	FXDLogVariable(deviceOrientation);
}


#pragma mark - Delegate

@end



@implementation UIWindow (Essential)
+ (instancetype)instantiateNewWindow {	FXDLog_SEPARATE;
	CGRect screenBounds = [UIScreen mainScreen].bounds;
	FXDLogRect(screenBounds);

	UIWindow *newWindow = [[[self class] alloc] initWithFrame:screenBounds];
	newWindow.backgroundColor = [UIColor blackColor];

	return newWindow;
}

@end
