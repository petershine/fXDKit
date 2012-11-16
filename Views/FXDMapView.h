	//
//  FXDMapView.h
//
//
//  Created by petershine on 5/25/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDMapView : MKMapView {
    // Primitives
	
	// Instance variables
	CGRect _initialDisclaimerViewFrame;
	CGPoint _disclaimerViewOffset;
}

// Properties
@property (assign, nonatomic) CGRect initialDisclaimerViewFrame;
@property (assign, nonatomic) CGPoint disclaimerViewOffset;

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark - Category
@interface MKMapView (Added)
- (id)disclaimerView;

@end
