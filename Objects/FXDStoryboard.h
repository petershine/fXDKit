//
//  FXDStoryboard.h
//
//
//  Created by petershine on 4/24/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDStoryboard : UIStoryboard {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
}

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UIStoryboard (Added)
+ (UIStoryboard*)storyboardWithDefaultName;

@end