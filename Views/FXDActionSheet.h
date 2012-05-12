//
//  FXDActionSheet.h
//
//
//  Created by petershine on 2/13/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDActionSheet : UIActionSheet {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	id _addedObj;
}

// Properties
@property (retain, nonatomic) id addedObj;

// IBOutlets


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Drawing


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation
- (void)observedApplicationDidEnterBackground:(id)notification;

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface UIActionSheet (Added)
@end
