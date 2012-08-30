//
//  FXDAlertView.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDAlertView : UIAlertView {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	id _addedObj;
}

// Properties
@property (strong, nonatomic) id addedObj;

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UIAlertView (Added)
@end
