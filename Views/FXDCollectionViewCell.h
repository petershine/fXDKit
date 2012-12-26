//
//  FXDCollectionViewCell.h
//
//
//  Created by petershine on 10/1/12.
//  Copyright (c) 2012 petershine. All rights reserved.
//

#import "FXDKit.h"


@interface FXDCollectionViewCell : UICollectionViewCell {
    // Primitives

	// Instance variables
}

// Properties
@property (strong, nonatomic) id addedObj;
@property (strong, nonatomic) id linkedOperationIdentifier;

@property (strong, nonatomic) NSIndexPath *linkedIndexPath;

// IBOutlets


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end
