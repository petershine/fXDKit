//
//  FXDAnnotationView.h
//  PopTooUniversal
//
//  Created by Peter SHINe on 5/11/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface FXDAnnotationView : MKAnnotationView {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
}

// Properties

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
@interface MKAnnotationView (Added)
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage;

- (void)animateCustomDropAfterDelay:(NSTimeInterval)delay;

@end
