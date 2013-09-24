//
//  FXDsuperCollectionController.m
//
//
//  Created by petershine on 2/6/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperCollectionController.h"


#pragma mark - Public implementation
@implementation FXDsuperCollectionController


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
	
	if (numberOfItems == 0) {	FXDLog_OVERRIDE;
		FXDLog(@"numberOfItems: %ld", (long)numberOfItems);
	}
	
	return numberOfItems;
}

- (FXDCollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {	FXDLog_OVERRIDE;
	
	FXDCollectionViewCell *cell = (FXDCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:self.mainCellIdentifier forIndexPath:indexPath];
	
	
	__weak typeof(self) _weakSelf = self;
	
	FXDBlockOperation *cellOperation = [[FXDBlockOperation alloc] init];
	__weak FXDBlockOperation *_weakOperation = cellOperation;
	
	[cellOperation addExecutionBlock:^{
		
		if ([_weakOperation isCancelled] == NO) {
			//TODO:
		}
		
		
		[[NSOperationQueue mainQueue]
		 addOperationWithBlock:^{
			 __strong typeof(_weakSelf) _strongSelf = _weakSelf;
			 
			 [_strongSelf.cellOperationDictionary removeObjectForKey:indexPath];
		 }];
	}];
	
	
	self.cellOperationDictionary[indexPath] = cellOperation;
	[self.cellOperationQueue addOperation:cellOperation];
	
	return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	
	BOOL didCancel = [self cancelQueuedCellOperationAtIndexPath:indexPath orRowIndex:integerNotDefined];
	
	if (didCancel) {
		FXDLog(@"didCancel: %d %@", didCancel, indexPath);
	}
}

#pragma mark - UICollectionViewDelegateFlowLayout

@end