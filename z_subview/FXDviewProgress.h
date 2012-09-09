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
	
	// Properties : For accessor overriding
}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_0;
@property (strong, nonatomic) IBOutlet UILabel *labelMessage_1;

@property (strong, nonatomic) IBOutlet UISlider *sliderProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *indicatorProgress;


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
