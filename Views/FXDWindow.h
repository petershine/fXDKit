//
//  FXDWindow.h
//
//
//  Created by petershine on 11/6/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#define notificationApplicationWindowShouldFadeInProgressView	@"notificationApplicationWindowShouldFadeInProgressView"
#define notificationApplicationWindowShouldFadeOutProgressView	@"notificationApplicationWindowShouldFadeOutProgressView"


#import "FXDKit.h"

@class FXDviewProgress;


@interface FXDWindow : UIWindow {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDviewProgress *progressView;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedApplicationWindowShouldFadeInProgressView:(NSNotification*)notification;
- (void)observedApplicationWindowShouldFadeOutProgressView:(NSNotification*)notification;

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface UIWindow (Added)
+ (id)applicationWindow;

- (void)showProgressView;
- (void)hideProgressView;

+ (void)showProgressViewAfterDelay:(NSTimeInterval)delay;
+ (void)hideProgressViewAfterDelay:(NSTimeInterval)delay;


@end

