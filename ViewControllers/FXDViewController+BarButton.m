//
//  FXDViewController+BarButton.m
//
//
//  Created by petershine on 11/29/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDViewController+BarButton.h"

#pragma mark - Category
@implementation UIViewController (BarButton)

#pragma mark - Public
- (void)customizeBackBarbuttonWithDefaultImagesForTarget:(id)target shouldHideForRoot:(BOOL)shouldHideForRoot {	FXDLog_DEFAULT;

	UIImage *offImage = nil;
	UIImage *onImage = nil;

	BOOL shouldUseBackTitle = NO;

#ifdef imageNavibarBtnBackOff
	offImage = imageNavibarBtnBackOff;
#else
	shouldUseBackTitle = YES;
#endif

#ifdef imageNavibarBtnBackOn
	onImage = imageNavibarBtnBackOn;
#endif

	SEL action = nil;

	FXDLog(@"navigationController.viewControllers count: %d", [self.navigationController.viewControllers count]);

	if ([self.navigationController.viewControllers count] > 1) {	// If there is more than 1 navigated interfaces

		if ([self.navigationController.viewControllers count] == 2) {
			action = @selector(popToRootInterfaceWithAnimation:);
		}
		else {
			action = @selector(popInterfaceWithAnimation:);
		}

		FXDLog(@"onImage: %@, offImage: %@", onImage, offImage);

	}
	else {
		if (shouldHideForRoot) {
			// Do not show back button
		}
		else {
			action = @selector(dismissControllerForSender:);
		}
	}

	if (action) {
		if (shouldUseBackTitle) {
			[self
			 customizeLeftBarbuttonWithText:NSLocalizedString(text_Back, nil)
			 andWithOnImage:onImage
			 andWithOffImage:offImage
			 withOffset:CGPointZero
			 forTarget:target
			 forAction:action];
		}
		else {
			[self
			 customizeLeftBarbuttonWithOnImage:onImage
			 andWithOffImage:offImage
			 withOffset:CGPointZero
			 forTarget:target
			 forAction:action];
		}
	}
	else {
		self.navigationItem.hidesBackButton = YES;
		self.navigationItem.leftItemsSupplementBackButton = YES;
	}
}

- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;

	UIView *buttonGroup = [self buttonGroupWithOnImage:onImage andOffImage:offImage withOffset:offset orWithText:text forTarget:target forAction:action];

	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonGroup];

	[(UIViewController*)target navigationItem].leftBarButtonItem = barButtonItem;
}

- (void)customizeLeftBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;

	UIBarButtonItem *barButtonItem = [self barButtonWithOnImage:onImage andOffImage:offImage withOffset:offset forTarget:target forAction:action];

	if (barButtonItem) {
		[(UIViewController*)target navigationItem].leftBarButtonItem = barButtonItem;
	}
}

- (void)customizeRightBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action {

	UIView *buttonGroup = [self buttonGroupWithOnImage:onImage andOffImage:offImage withOffset:offset orWithText:text forTarget:target forAction:action];

	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonGroup];

	[(UIViewController*)target navigationItem].rightBarButtonItem = barButtonItem;
}

- (void)customizeRightBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action {	//FXDLog_DEFAULT;

	UIBarButtonItem *barButtonItem = [self barButtonWithOnImage:onImage andOffImage:offImage withOffset:offset forTarget:target forAction:action];

	if (barButtonItem) {
		[(UIViewController*)target navigationItem].rightBarButtonItem = barButtonItem;
	}
}

- (UIBarButtonItem*)barButtonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage withOffset:(CGPoint)offset forTarget:(id)target forAction:(SEL)action {

	UIBarButtonItem *barButtonItem = nil;

	if (offImage) {
		UIView *buttonGroup = [self buttonGroupWithOnImage:onImage andOffImage:offImage withOffset:offset orWithText:nil forTarget:target forAction:action];

		barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonGroup];
	}
	else {
		if (action == @selector(dismissControllerForSender:)) {
			barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:target action:action];
		}
	}

	return barButtonItem;
}

- (UIView*)buttonGroupWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage withOffset:(CGPoint)offset orWithText:(NSString*)text forTarget:(id)target forAction:(SEL)action {

	CGRect buttonFrame = CGRectMake(0.0, 0.0, onImage.size.width, onImage.size.height);

	UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

	[button setBackgroundImage:offImage forState:UIControlStateNormal];

	if (onImage) {
		[button setBackgroundImage:onImage forState:UIControlStateHighlighted];
		[button setBackgroundImage:onImage forState:UIControlStateSelected];
	}

	if (text) {
		UILabel *backLabel = [[UILabel alloc] initWithFrame:buttonFrame];
		backLabel.text = text;
		backLabel.textColor = [UIColor whiteColor];
		backLabel.font = [UIFont boldSystemFontOfSize:12.0];

		backLabel.textAlignment = NSTextAlignmentCenter;
		backLabel.backgroundColor = [UIColor clearColor];
		backLabel.adjustsFontSizeToFitWidth = YES;
		backLabel.userInteractionEnabled = NO;

		[button addSubview:backLabel];
	}


	UIView *buttonGroup = nil;

	if (CGPointEqualToPoint(offset, CGPointZero) == NO) {
		buttonGroup = [[UIView alloc] initWithFrame:CGRectMake(0, 0, onImage.size.width+ABS(offset.x), onImage.size.height+ABS(offset.y))];

		// Add only when they are positive numbers
		CGRect modifiedFrame = button.frame;
		modifiedFrame.origin.x += (offset.x > 0) ? offset.x : 0;
		modifiedFrame.origin.y += (offset.y > 0) ? offset.y : 0;
		[button setFrame:modifiedFrame];
	}
	else {
		buttonGroup = [[UIView alloc] initWithFrame:CGRectMake(0, 0, onImage.size.width, onImage.size.height)];
	}

	[buttonGroup addSubview:button];

	return buttonGroup;
}


@end
