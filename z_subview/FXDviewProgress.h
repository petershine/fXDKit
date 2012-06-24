//
//  FXDviewProgress.h
//
//
//  Created by petershine on 1/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

#import "FXDKit.h"


@interface FXDviewProgress : FXDView {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activitywheelProgress;

@property (strong, nonatomic) IBOutlet UILabel *labelAboveActivityWheel;
@property (strong, nonatomic) IBOutlet UILabel *labelBelowActivityWheel;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
