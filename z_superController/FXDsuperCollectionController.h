//
//  FXDsuperCollectionController.h
//  PopTooUniversal
//
//  Created by petershine on 2/6/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperTableController.h"

@interface FXDsuperCollectionController : FXDsuperTableController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    // Primitives
	
	// Instance variables
	
}

// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
