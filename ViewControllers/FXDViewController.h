//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDViewController+BarButton.h"


@interface FXDViewController : UIViewController
@end


#pragma mark - Category
@interface UIViewController (Added)

#pragma mark - IBActions
- (IBAction)exitSceneUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue;	//MARK: implement this for controller which will unwind childScene (previousScene)

- (IBAction)popToRootSceneWithAnimationForSender:(id)sender;
- (IBAction)popSceneWithAnimationForSender:(id)sender;

- (IBAction)dismissSceneWithAnimationForSender:(id)sender;

#pragma mark - Public
- (UIView*)sceneViewFromNibNameOrNil:(NSString*)nibNameOrNil;

@end
