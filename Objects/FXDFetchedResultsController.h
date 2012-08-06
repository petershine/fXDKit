//
//  FXDFetchedResultsController.h
//  PopTooUniversal
//
//  Created by petershine on 7/4/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"

#import <CoreData/CoreData.h>


@interface FXDFetchedResultsController : NSFetchedResultsController {
    // Primitives
	
	// Instance variables
	
    // Properties : For subclass to be able to reference
	id<NSFetchedResultsControllerDelegate> _dynamicDelegate;
}

// Properties
@property (strong, nonatomic) id<NSFetchedResultsControllerDelegate> dynamicDelegate;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end

#pragma mark - Category
@interface NSFetchedResultsController (Added)
@end
