//
//  FXDviewProgress.h
//
//
//  Created by Anonymous on 1/9/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//


@interface FXDviewProgress : FXDView {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
}

// Properties

// IBOutlets
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activitywheelProgress;

@property (nonatomic, retain) IBOutlet UILabel *labelAboveActivityWheel;
@property (nonatomic, retain) IBOutlet UILabel *labelBelowActivityWheel;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Drawing


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
