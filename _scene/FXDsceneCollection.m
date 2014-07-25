

#import "FXDsceneCollection.h"


@implementation FXDsceneCollection

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)willMoveToParentViewController:(UIViewController *)parent {

	if (parent == nil) {
		self.mainCollectionview.delegate = nil;
		self.mainCollectionview.dataSource = nil;
	}

	[super willMoveToParentViewController:parent];
}


#pragma mark - Property overriding
- (UIScrollView*)mainScrollview {
	if (_mainScrollview == nil) {
		
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

#pragma mark - Observer

#pragma mark - Delegate
//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	NSInteger numberOfSections = [self numberOfSectionsForScrollView:collectionView];
	
	return numberOfSections;	
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	NSInteger numberOfItems = [self numberOfItemsForScrollView:collectionView atSection:section];

	return numberOfItems;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {	FXDLog_OVERRIDE;
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.mainCellIdentifier forIndexPath:indexPath];


	NSBlockOperation *cellOperation = [[NSBlockOperation alloc] init];
	__weak NSBlockOperation *weakOperation = cellOperation;

	[cellOperation
	 addExecutionBlock:^{

		 if (weakOperation && weakOperation.isCancelled == NO) {
			 //TODO:
		 }


		 [[NSOperationQueue currentQueue]
		  addOperationWithBlock:^{
			  [self.cellOperationQueue
			   removeOperationForKey:indexPath
			   withDictionary:self.cellOperationDictionary];
		  }];
	 }];

	[self.cellOperationQueue
	 enqueOperation:cellOperation
	 forKey:indexPath
	 withDictionary:self.cellOperationDictionary];

	
	return cell;
}

//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	
	BOOL didCancel = [self cancelQueuedCellOperationAtIndexPath:indexPath orRowIndex:integerNotDefined];
	
	if (didCancel) {
		//FXDLog(@"%@ %@", _BOOL(didCancel), indexPath);
	}
}

//MARK: UICollectionViewDelegateFlowLayout

@end