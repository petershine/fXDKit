//
//  FXDActionSheet.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDActionSheet : UIActionSheet {
    // Primitives
	
	// Instance variables
}

// Properties
@property (strong, nonatomic) id addedObj;

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedUIApplicationDidEnterBackground:(NSNotification*)notification;

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UIActionSheet (Added)
@end
