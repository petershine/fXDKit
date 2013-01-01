//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDKit.h"

#import "FXDViewController+BarButton.h"


@interface FXDViewController : UIViewController {
    // Primitives
	
	// Instance variables
	NSDictionary *_segueNames;
}

// Properties
@property (assign, nonatomic) BOOL isSystemVersionLatest;

@property (strong, nonatomic) NSDictionary *segueNames;

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
- (IBAction)exitSceneUsingUnwindSegue:(UIStoryboardSegue*)unwindSegue;	//MARK: implement this for controller which will unwind childScene (previousScene)

- (IBAction)popToRootInterfaceWithAnimation:(id)sender;
- (IBAction)popInterfaceWithAnimation:(id)sender;
- (IBAction)dismissInterfaceWithAnimation:(id)sender;

@end
