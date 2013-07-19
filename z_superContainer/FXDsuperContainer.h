//
//  FXDsuperContainer.h
//
//
//  Created by petershine on 5/1/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//


@interface FXDsuperContainer : FXDViewController

// Properties

// IBOutlets


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


//SAMPLE: Segues
/*
 @interface PWDsegueCoverUp : FXDsuperTransitionSegue
 @end
 
 @interface PWDsegueUncoverDown : FXDsuperTransitionSegue
 @end
*/

/*
 @implementation PWDsegueCoverUp
 - (void)perform {
 FXDLog(@"self description: %@", [self description]);
 
 PWDVaultContainer *vaultContainer = (PWDVaultContainer*)[PWDmanagerGlobal sharedInstance].rootController;
 
 UIViewController *coveringController = [self destinationViewController];
 
 #warning "//TODO: Replace navigationController
 
 CGRect animatedFrame = coveringController.view.frame;
 
 CGRect modifiedFrame = coveringController.view.frame;
 modifiedFrame.origin.y = vaultContainer.view.frame.size.height;
 [coveringController.view setFrame:modifiedFrame];
 FXDLog(@"1.coveringController.view: %@", coveringController.view);
 
 [vaultContainer addChildViewController:coveringController];
 [vaultContainer.view insertSubview:coveringController.view belowSubview:vaultContainer.lockController.view];
 [coveringController didMoveToParentViewController:vaultContainer];
 
 [UIView
 animateWithDuration:durationAnimation
 delay:0.0
 options:UIViewAnimationOptionCurveEaseInOut
 animations:^{
 [coveringController.view setFrame:animatedFrame];
 } completion:^(BOOL finished) {
 FXDLog(@"2.coveringController.view: %@", coveringController.view);
 }];
 }
 
 @end
 
 @implementation PWDsegueUncoverDown
 - (void)perform {
 FXDLog(@"self description: %@", [self description]);
 
 PWDVaultContainer *vaultContainer = [self destinationViewController];
 
 UIViewController *uncoveringController = [self sourceViewController];
 
 CGRect animatedFrame = uncoveringController.view.frame;
 animatedFrame.origin.y = vaultContainer.view.frame.size.height;
 
 FXDLog(@"1.uncoveringController.view: %@", uncoveringController.view);
 
 [uncoveringController willMoveToParentViewController:nil];
 
 [UIView
 animateWithDuration:durationAnimation
 delay:0.0
 options:UIViewAnimationOptionCurveEaseInOut
 animations:^{
 [uncoveringController.view setFrame:animatedFrame];
 } completion:^(BOOL finished) {
 FXDLog(@"2.uncoveringController.view: %@", uncoveringController.view);
 
 [uncoveringController.view removeFromSuperview];
 [uncoveringController removeFromParentViewController];
 }];
 }
 
 @end
*/