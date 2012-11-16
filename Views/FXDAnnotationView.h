//
//  FXDAnnotationView.h
//
//
//  Created by petershine on 5/11/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDAnnotationView : MKAnnotationView {
    // Primitives
	
	// Instance variables
}

// Properties

// IBOutlets


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
