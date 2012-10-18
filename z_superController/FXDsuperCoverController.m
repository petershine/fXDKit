//
//  FXDsuperCoverController.m
//
//
//  Created by petershine on 10/18/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperCoverController.h"

#pragma mark - Category
@implementation FXDViewController (Covering)

- (IBAction)uncoverUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue {	FXDLog_OVERRIDE;

}

- (COVER_DIRECTION_TYPE)coverDirectionType {	FXDLog_OVERRIDE;
	COVER_DIRECTION_TYPE coverDirectionType = coverDirectionLeft;

	FXDLog(@"coverDirectionType: %d", coverDirectionType);

	return coverDirectionType;
}

@end


@implementation FXDsegueCovering
- (void)perform {	FXDLog_DEFAULT;

	FXDsuperCoverController *coverController = (FXDsuperCoverController*)[self.sourceViewController navigationController];

	FXDViewController *destination = (FXDViewController*)self.destinationViewController;

	FXDLog(@"coverController: %@", coverController);
	FXDLog(@"destination: %@", destination);

	if ([coverController isKindOfClass:[FXDsuperCoverController class]] == NO
		|| [destination isKindOfClass:[FXDViewController class]] == NO) {
		FXDLog(@"WRONG CLASSES!");

		return;
	}


	[coverController addChildViewController:destination];


	CGRect animatedFrame = destination.view.frame;
	CGRect modifiedFrame = destination.view.frame;

	void (^animationBlock)(void) = NULL;

	
	switch ([destination coverDirectionType]) {
		case coverDirectionTop:
			modifiedFrame.origin.y = coverController.view.frame.size.height;
			break;

		case coverDirectionLeft:
			modifiedFrame.origin.x = coverController.view.frame.size.width;
			break;

		case coverDirectionBottom:
			modifiedFrame.origin.y = 0.0 -coverController.view.frame.size.height;
			break;

		case coverDirectionRight:
			modifiedFrame.origin.x = 0.0 -coverController.view.frame.size.width;
			break;

		default:
			break;
	}

	if (animationBlock == NULL) {
		animationBlock = ^{
			[destination.view setFrame:animatedFrame];
		};
	}


	[destination.view setFrame:modifiedFrame];

	[coverController.view insertSubview:destination.view belowSubview:coverController.navigationBar];


	if (destination.navigationItem) {
		[coverController.navigationBar pushNavigationItem:destination.navigationItem animated:YES];
	}

	if (destination.toolbarItems) {
		if (coverController.toolbarItems) {
			if (coverController.previousToolbarItemsArray == nil) {
				coverController.previousToolbarItemsArray = [[NSMutableArray alloc] initWithCapacity:0];
			}

			[coverController.previousToolbarItemsArray addObject:coverController.toolbarItems];

			FXDLog(@"previousToolBarItems:\n%@", coverController.previousToolbarItemsArray);
		}

		[coverController setToolbarItems:destination.toolbarItems animated:YES];
	}

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationCurveEaseOut
					 animations:animationBlock
					 completion:^(BOOL finished) {	FXDLog_DEFAULT;
						 FXDLog(@"finished: %d", finished);
					 }];
}

@end

@implementation FXDsegueUncovering
- (void)perform {	FXDLog_DEFAULT;

	FXDsuperCoverController *coverController = (FXDsuperCoverController*)[self.destinationViewController navigationController];

	FXDViewController *source = (FXDViewController*)self.sourceViewController;

	FXDLog(@"coverController: %@", coverController);
	FXDLog(@"source: %@", source);

	if ([coverController isKindOfClass:[FXDsuperCoverController class]] == NO
		|| [source isKindOfClass:[FXDViewController class]] == NO) {
		FXDLog(@"WRONG CLASSES!");

		return;
	}


	CGRect animatedFrame = source.view.frame;

	void (^animationBlock)(void) = NULL;
	

	switch ([source coverDirectionType]) {
		case coverDirectionTop:
			animatedFrame.origin.y = coverController.view.frame.size.height;
			break;

		case coverDirectionLeft:
			animatedFrame.origin.x = coverController.view.frame.size.width;
			break;

		case coverDirectionBottom:
			animatedFrame.origin.y = 0.0 -coverController.view.frame.size.height;
			break;

		case coverDirectionRight:
			animatedFrame.origin.x = 0.0 -coverController.view.frame.size.width;
			break;

		default:
			break;
	}

	if (animationBlock == NULL) {
		animationBlock = ^{
			[source.view setFrame:animatedFrame];
		};
	}


	if (source.navigationItem) {
		[coverController.navigationBar popNavigationItemAnimated:YES];
	}

	if (source.toolbarItems) {
		NSArray *previousToolbarItems = nil;

		if ([coverController.previousToolbarItemsArray count] > 0) {
			previousToolbarItems = [coverController.previousToolbarItemsArray lastObject];
			[coverController.previousToolbarItemsArray removeLastObject];
		}

		FXDLog(@"previousToolBarItems:\n%@", coverController.previousToolbarItemsArray);

		[coverController setToolbarItems:previousToolbarItems animated:YES];
	}

	[UIView animateWithDuration:durationAnimation
						  delay:0
						options:UIViewAnimationCurveEaseOut
					 animations:animationBlock
					 completion:^(BOOL finished) {	FXDLog_DEFAULT;
						 FXDLog(@"finished: %d", finished);

						 [source.view removeFromSuperview];
						 [source removeFromParentViewController];

						 FXDLog(@"coverController.childViewControllers:\n%@", coverController.childViewControllers);
					 }];
}

@end


#pragma mark - Public implementation
@implementation FXDsuperCoverController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.

	// Instance variables

	// Properties
}

- (void)dealloc {
	// Instance variables

	// Properties
}


#pragma mark - Initialization
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
- (void)viewDidLoad {
    [super viewDidLoad];

	[self setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

}


#pragma mark - Overriding


#pragma mark - Segues
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {	FXDLog_DEFAULT;

	FXDLog(@"toViewController: %@", toViewController);
	FXDLog(@"fromViewController: %@", fromViewController);
	FXDLog(@"identifier: %@", identifier);

	FXDsegueUncovering *uncoveringSegue = [[FXDsegueUncovering alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];

	return uncoveringSegue;
}


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {	FXDLog_DEFAULT;
	FXDLog(@"viewController: %@", viewController);

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {	FXDLog_DEFAULT;

	FXDLog(@"viewController: %@", viewController);
}


@end
