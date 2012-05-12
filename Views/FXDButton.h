//
//  FXDButton.h
//
//
//  Created by petershine on 10/12/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//


@interface FXDButton : UIButton {
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


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
