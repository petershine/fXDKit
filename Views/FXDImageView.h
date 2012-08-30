//
//  FXDImageView.h
//
//
//  Created by petershine on 2/1/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDImageView : UIImageView {
    // Primitives
	
	// Instance variables
    
    // Properties : For subclass to be able to reference
}

// Properties

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UIImageView (Added)
- (void)modifyHeightForContainedImage;

- (void)replaceImageWithResizableImageWithCapInsets:(UIEdgeInsets)capInsets;

@end
