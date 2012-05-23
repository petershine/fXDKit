//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDColor.h"

#import "FXDNavigationController.h"
#import "FXDAlertView.h"
#import "FXDActionSheet.h"


@interface FXDViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
}

// Properties

// IBOutlets


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - at loadView

#pragma mark - at autoRotate

#pragma mark - at viewDidLoad


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIAlertViewDelegate
#pragma mark - UIActionSheetDelegate

@end


#pragma mark - Category
@interface UIViewController (Added)
+ (FXDNavigationController*)navigationControllerUsingInitializedInterface;	// Using self instance as a root of navigationController

- (void)customizeBackBarbuttonWithDefaultImagesForTarget:(id)target shouldHideForRoot:(BOOL)shouldHideForRoot;
- (void)customizeLeftBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (void)customizeLeftBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (void)customizeRightBarbuttonWithText:(NSString*)text andWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (void)customizeRightBarbuttonWithOnImage:(UIImage*)onImage andWithOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;

- (UIBarButtonItem*)barButtonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage forTarget:(id)target forAction:(SEL)action;
- (UIButton*)buttonWithOnImage:(UIImage*)onImage andOffImage:(UIImage*)offImage orWithText:(NSString*)text;

- (IBAction)popToRootInterfaceWithAnimation:(id)sender;
- (IBAction)popInterfaceWithAnimation:(id)sender;
- (IBAction)dismissInterfaceWithAnimation:(id)sender;


- (void)startObservingNotifications;
- (void)customizeNavigationBar;
- (void)refreshInterface;


@end
