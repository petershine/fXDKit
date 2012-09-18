//
//  FXDPopoverController.m
//  KeyChamp
//
//  Created by petershine on 9/18/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDPopoverController.h"


#pragma mark - Private interface
@interface FXDPopoverController (Private)
@end


#pragma mark - Public implementation
@implementation FXDPopoverController

#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)dealloc {
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (id)initWithContentViewController:(UIViewController *)viewController {	FXDLog_SEPARATE;

    self = [super initWithContentViewController:viewController];

    if (self) {
    	[self awakeFromNib];
    }

    return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

    // Primitives

    // Instance variables

    // Properties

    // IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad


#pragma mark - Private


#pragma mark - Overriding
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {	FXDLog_DEFAULT;

	[super presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];

}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {	FXDLog_DEFAULT;

	[super presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];

}

- (void)dismissPopoverAnimated:(BOOL)animated {	FXDLog_DEFAULT;
	[super dismissPopoverAnimated:animated];
}


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@implementation UIPopoverController (Added)
@end
