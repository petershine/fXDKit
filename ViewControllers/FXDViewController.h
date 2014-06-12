//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDViewController+BarButton.h"


@interface FXDViewController : UIViewController
@property (nonatomic) BOOL didFinishInitialAppearing;

// IBOutlets


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIViewController (Added)

#pragma mark - IBActions
- (IBAction)popToRootSceneWithAnimation:(id)sender;
- (IBAction)popSceneWithAnimation:(id)sender;

- (IBAction)dismissSceneWithAnimation:(id)sender;

#pragma mark - Public
- (UIView*)sceneViewFromNibNameOrNil:(NSString*)nibNameOrNil;


#ifdef __IPHONE_8_0
#warning //TODO: Remove categorized implementation when iOS 8 is officially released
#else
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator;
#endif

@end
