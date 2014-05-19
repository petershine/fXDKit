//
//  FXDViewController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#ifndef TEST_loggingMemoryWarning
	#define TEST_loggingMemoryWarning	FALSE
#endif

#ifndef TEST_loggingRotatingOrientation
	#define TEST_loggingRotatingOrientation	FALSE
#endif


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

- (void)updateSubviewsForBounds:(CGRect)bounds forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation forDuration:(NSTimeInterval)duration;

@end
