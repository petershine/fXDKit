//
//  FXDPopoverController.m
//
//
//  Created by petershine on 9/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDPopoverController.h"


#pragma mark - Public implementation
@implementation FXDPopoverController


#pragma mark - Memory management

#pragma mark - Initialization
- (id)initWithContentViewController:(UIViewController *)viewController {	FXDLog_SEPARATE;

    self = [super initWithContentViewController:viewController];

    if (self) {
		//TODO:
    }

    return self;
}


#pragma mark - Property overriding

#pragma mark - Method overriding
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {	FXDLog_DEFAULT;

	[super presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];

}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {	FXDLog_DEFAULT;

	[super presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];

}

- (void)dismissPopoverAnimated:(BOOL)animated {	FXDLog_DEFAULT;
	[super dismissPopoverAnimated:animated];
}


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIPopoverController (Added)
@end
