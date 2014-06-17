//
//  FXDsuperCollectionScene.m
//
//
//  Created by petershine on 2/6/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperCollectionScene.h"


#pragma mark - Public implementation
@implementation FXDsuperCollectionScene


#pragma mark - Memory management
- (void)dealloc {
	[_mainCollectionview setDelegate:nil];
	[_mainCollectionview setDataSource:nil];
}


#pragma mark - Initialization

#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding
- (UIScrollView*)mainScrollview {
	
	if (_mainScrollview == nil) {	FXDLog_DEFAULT;
		
		if (self.mainCollectionview) {
			_mainScrollview = self.mainCollectionview;			
		}
		else {
			_mainScrollview = [super mainScrollview];
		}
	}
	
	return _mainScrollview;
}


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	
	if (parent == nil) {
		[self.mainCollectionview setDelegate:nil];
		[self.mainCollectionview setDataSource:nil];
	}
	
	[super willMoveToParentViewController:parent];
}

#pragma mark -
- (void)registerMainCellNib {
	
	if (self.mainCellNib == nil && self.mainCellIdentifier == nil) {
		[super registerMainCellNib];
		return;
	}
	
	
	FXDLog_DEFAULT;
	
	[self.mainCollectionview registerNib:self.mainCellNib forCellWithReuseIdentifier:self.mainCellIdentifier];
}


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	NSInteger numberOfSections = [self numberOfSectionsForScrollView:collectionView];
	
	return numberOfSections;	
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger numberOfItems = [self numberOfItemsForScrollView:collectionView atSection:section];

	return numberOfItems;
}

- (FXDCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {	FXDLog_OVERRIDE;
	
	FXDCollectionViewCell *cell = (FXDCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:self.mainCellIdentifier forIndexPath:indexPath];


	NSBlockOperation *cellOperation = [[NSBlockOperation alloc] init];
	__weak NSBlockOperation *weakOperation = cellOperation;

	[cellOperation
	 addExecutionBlock:^{

		 if (weakOperation && [weakOperation isCancelled] == NO) {
			 //TODO:
		 }


		 [[NSOperationQueue mainQueue]
		  addOperationWithBlock:^{
			  [self.cellOperationQueue removeOperationForKey:indexPath];
		  }];
	 }];

	[self.cellOperationQueue enqueOperation:cellOperation forKey:indexPath];

	
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	
	BOOL didCancel = [self cancelQueuedCellOperationAtIndexPath:indexPath orRowIndex:integerNotDefined];
	
	if (didCancel) {
		//FXDLog(@"%@ %@", _BOOL(didCancel), indexPath);
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout

@end