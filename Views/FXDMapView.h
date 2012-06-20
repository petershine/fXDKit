//
//  FXDMapView.h
//  PopTooUniversal
//
//  Created by Peter SHINe on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "FXDKit.h"

#import <MapKit/MapKit.h>


@interface FXDMapView : MKMapView {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	CGRect _logoInitialFrame;
	CGPoint _logoOffset;
}

// Properties
@property (assign, nonatomic) CGRect logoInitialFrame;
@property (assign, nonatomic) CGPoint logoOffset;

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
- (UIImageView*)logoImageView;

@end
