	//
//  FXDMapView.h
//  PopTooUniversal
//
//  Created by Peter SHINe on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"

#import <MapKit/MapKit.h>


@interface FXDMapView : MKMapView {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	CGRect _initialDisclaimerLabelFrame;
	CGPoint _disclaimerLabelOffset;
}

// Properties
@property (assign, nonatomic) CGRect initialDisclaimerLabelFrame;
@property (assign, nonatomic) CGPoint disclaimerLabelOffset;

// IBOutlets


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


#pragma mark - Category
@interface MKMapView (Added)
- (id)disclaimerLabel;

@end
