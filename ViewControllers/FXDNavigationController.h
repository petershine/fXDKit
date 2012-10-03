//
//  FXDNavigationController.h
//
//
//  Created by petershine on 10/4/11.
//  Copyright 2011 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDNavigationController : UINavigationController {
    // Primitives
	
	// Instance variables
	
	// Properties : For accessor overriding
	BOOL _shouldUseDefaultNavigationBar;
}

// Properties
@property (assign, nonatomic) BOOL shouldUseDefaultNavigationBar;

// IBOutlets


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UINavigationController (Added)
@end