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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	// Instance variables
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];
	
	// Primitives
	
    // Instance variables
	
    // Properties
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    // IBOutlet
}


#pragma mark - Autorotating


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark - Property overriding
- (UIScrollView*)mainScrollView {
	if (_mainScrollView == nil) {
		
		if (self.mainCollectionView) {
			_mainScrollView = self.mainCollectionView;			
		}
		else {
			_mainScrollView = [super mainScrollView];
		}
	}
	
	return _mainScrollView;
}


#pragma mark - Method overriding


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
	
	
	FXDBlockOperation *cellOperation = [[FXDBlockOperation alloc] init];
	__weak FXDBlockOperation *_weakCellOperation = cellOperation;
	
	[cellOperation addExecutionBlock:^{
		
		if (_weakCellOperation && _weakCellOperation.isCancelled == NO) {
			//TODO:
		}
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{		
			
			[self.cellOperationDictionary removeObjectForKey:[indexPath stringValue]];
		}];
	}];
	
	
	self.cellOperationDictionary[[indexPath stringValue]] = cellOperation;
	
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