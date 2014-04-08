//
//  FXDsuperCollectionScene.h
//
//
//  Created by petershine on 2/6/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//


#import "FXDsuperTableScene.h"

@interface FXDsuperCollectionScene : FXDsuperTableScene <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// IBOutlets
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionview;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
