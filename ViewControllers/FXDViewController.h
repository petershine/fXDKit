//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDViewController : UIViewController {
    // Primitives
	
	// Instance variables
}

// Properties

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
//MARK: implement this for controller whick will unwind
- (IBAction)exitSceneUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue;

- (IBAction)popToRootInterfaceWithAnimation:(id)sender;
- (IBAction)popInterfaceWithAnimation:(id)sender;
- (IBAction)dismissInterfaceWithAnimation:(id)sender;

#pragma mark - Public
- (void)customizeBackBarbuttonWithDefaultImagesForTarget:(id)target shouldHideForRoot:(BOOL)shouldHideForRoot;
- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (void)customizeLeftBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (void)customizeRightBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (void)customizeRightBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;

- (UIBarButtonItem*)barButtonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (UIButton*)buttonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage orWithText:(NSString*)text;


@end
