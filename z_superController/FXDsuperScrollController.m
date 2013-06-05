//
//  FXDsuperScrollController.m
//
//
//  Created by petershine on 2/5/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperScrollController.h"


#pragma mark - Public implementation
@implementation FXDsuperScrollController


#pragma mark - Memory management
- (void)dealloc {
	[_cellOperationDictionary removeAllObjects];
	[_cellOperationQueue cancelAllOperations];
}


#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];
	
	FXDLog(@"self.mainScrollview: %@", self.mainScrollview);
	
	if (self.mainScrollview == nil) {
		return;
	}
	
	
	if (self.mainScrollview.delegate == nil) {
		[self.mainScrollview setDelegate:self];
	}
	
	
	if ([self.mainScrollview respondsToSelector:@selector(dataSource)]
		&& [self.mainScrollview performSelector:@selector(dataSource)] == nil) {
		
		[self.mainScrollview performSelector:@selector(setDataSource:) withObject:self];
	}
	
	
	FXDLog(@"self.mainCellIdentifier: %@", self.mainCellIdentifier);
	FXDLog(@"self.mainCellNib: %@", self.mainCellNib);
	
	if (self.mainCellIdentifier || self.mainCellNib) {		
		if ([self.mainScrollview isKindOfClass:[UITableView class]]) {
			[(UITableView*)self.mainScrollview registerNib:self.mainCellNib forCellReuseIdentifier:self.mainCellIdentifier];
		}
		else if ([self.mainScrollview isKindOfClass:[UICollectionView class]]) {
			[(UICollectionView*)self.mainScrollview registerNib:self.mainCellNib forCellWithReuseIdentifier:self.mainCellIdentifier];
		}
	}
#if DEBUG
	else {
		FXDLog(@"OVERRIDE: mainCellIdentifier: %@ mainCellNib: %@", self.mainCellIdentifier, self.mainCellNib);
	}
#endif
	
	
	if (self.offsetYdismissingController == 0.0) {
		CGRect screenBounds = [[UIScreen mainScreen] bounds];
		FXDLog(@"screenBounds: %@", NSStringFromCGRect(screenBounds));
		
		self.offsetYdismissingController = 0.0 -(screenBounds.size.height *scaleControllerDismissingOffset);
		FXDLog(@"self.offsetYdismissingController: %f", self.offsetYdismissingController);
	}

	if (self.mainResultsController) {
		[self.mainResultsController setAdditionalDelegate:self];
	}
}


#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding
- (NSString*)mainCellIdentifier {
	if (_mainCellIdentifier == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _mainCellIdentifier;
}

- (UINib*)mainCellNib {
	if (_mainCellNib == nil) {
		if (self.mainCellIdentifier) {
			_mainCellNib = [UINib nibWithNibName:self.mainCellIdentifier bundle:nil];
		}
	}
	
	return _mainCellNib;
}

#pragma mark -
- (NSDictionary*)cellTitleDictionary {
	
	if (_cellTitleDictionary == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _cellTitleDictionary;
}

- (NSDictionary*)cellSubTitleDictionary {
	if (_cellSubTitleDictionary == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _cellSubTitleDictionary;
}
- (NSArray*)itemCounts {
	
	if (_itemCounts == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _itemCounts;
}

#pragma mark -
- (NSMutableArray*)mainDataSource {
	
	if (_mainDataSource == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _mainDataSource;
}

- (FXDFetchedResultsController*)mainResultsController {
	
	if (_mainResultsController == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _mainResultsController;
}

#pragma mark -
- (NSOperationQueue*)cellOperationQueue {
	
	if (_cellOperationQueue == nil) {	FXDLog_OVERRIDE;
		_cellOperationQueue = [[NSOperationQueue alloc] init];
		
		[_cellOperationQueue setMaxConcurrentOperationCount:limitConcurrentOperationCount];
		FXDLog(@"maxConcurrentOperationCount: %d", [_cellOperationQueue maxConcurrentOperationCount]);
	}
	
	return _cellOperationQueue;
}

- (NSMutableDictionary*)cellOperationDictionary {
	
	if (_cellOperationDictionary == nil) {
		_cellOperationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _cellOperationDictionary;
}


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	
	if (parent == nil) {
		if (self.mainResultsController.additionalDelegate == self) {
			[self.mainResultsController setAdditionalDelegate:nil];
		}
				
		if ([self.mainScrollview respondsToSelector:@selector(setDelegate:)]) {
			[self.mainScrollview performSelector:@selector(setDelegate:) withObject:nil];
		}
		
		if ([self.mainScrollview respondsToSelector:@selector(setDataSource:)]) {
			[self.mainScrollview performSelector:@selector(setDataSource:) withObject:nil];
		}
	}
	
	[super willMoveToParentViewController:parent];
}


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex {
	
	BOOL didCancel = NO;
	
	id operationObjKey = nil;
	
	if (indexPath) {
		operationObjKey = [indexPath stringValue];
	}
	else if (rowIndex != integerNotDefined) {
		operationObjKey = NSIndexPathString(0, rowIndex);
	}
	
	if (operationObjKey == nil) {
		return didCancel;
	}
	
	
	FXDBlockOperation *cellOperation = (self.cellOperationDictionary)[operationObjKey];
	
	if (cellOperation) {
		[cellOperation cancel];
		
		didCancel = cellOperation.isCancelled;
	}
	
	
	return didCancel;
}

#pragma mark -
- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView {	//FXDLog_OVERRIDE;
	NSInteger numberOfSections = 1;
	
	if (self.mainResultsController) {
		//FXDLog(@"self.mainResultsController sections: %@", [self.mainResultsController sections]);
		
		numberOfSections = [[self.mainResultsController sections] count];
	}
	else if (self.mainDataSource) {
		//MARK: Assume it's just one array
	}
	else if (self.itemCounts) {	//FXDLog_OVERRIDE;
		numberOfSections = [self.itemCounts count];
	}
	
	return numberOfSections;
}

- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section {
	
	NSInteger numberOfItems = 0;
	
	if (self.mainResultsController) {
		NSInteger fetchedCount = [self.mainResultsController.fetchedObjects count];
		
#if ForDEVELOPER
		NSArray *sections = self.mainResultsController.sections;
		
		if (section < [sections count]) {
			id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
			
			numberOfItems = [sectionInfo numberOfObjects];
		}
		
		if (numberOfItems != fetchedCount) {
			numberOfItems = fetchedCount;
		}
#else
		numberOfItems = fetchedCount;
#endif
		FXDLog_DEFAULT;
		FXDLog(@"section: %d numberOfRows: %d == fetchedCount: %d", section, numberOfItems, fetchedCount);
	}
	else if (self.mainDataSource) {
		numberOfItems = [self.mainDataSource count];
	}
	else if (self.itemCounts) {
		numberOfItems = [(self.itemCounts)[section] integerValue];
	}
#if ForDEVELOPER
	else {
		FXDLog_OVERRIDE;
	}
#endif
	
	return numberOfItems;
}

#pragma mark -
- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView {	FXDLog_OVERRIDE;
	
	if (scrollView == nil) {
		scrollView = self.mainScrollview;
	}
	
	
	FXDLog(@"contentOffset.y: %f didStartDismissingByPullingDown: %d", scrollView.contentOffset.y, self.didStartDismissingByPullingDown);
	
	if (self.didStartDismissingByPullingDown) {
		return;
	}
	
	
	self.didStartDismissingByPullingDown = YES;
}

#pragma mark -
- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath didFinishBlock:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))didFinishBlock {
	
	BOOL shouldContinue = NO;
	
	// Get valid index row for disappeared cell
	if ([self.mainScrollview isKindOfClass:[UITableView class]] == NO) {		
		didFinishBlock(shouldContinue, integerNotDefined, NO);
		return;
	}
	
	
	NSArray *visibleIndexPaths = [(UITableView*)self.mainScrollview indexPathsForVisibleRows];
	NSInteger visibleRowCount = [visibleIndexPaths count];
	
	if (visibleRowCount == 0) {
		FXDLog(@"visibleRowCount: %d", visibleRowCount);
		
		didFinishBlock(shouldContinue, integerNotDefined, NO);
		
		return;
	}
	
	
	NSInteger firstVisibleRow = [visibleIndexPaths[0] row];
	NSInteger lastVisibleRow = [[visibleIndexPaths lastObject] row];
	
	NSInteger disappearedRow = integerNotDefined;
	
	if (indexPath.row == lastVisibleRow) {
		disappearedRow = lastVisibleRow -visibleRowCount;
	}
	else if (indexPath.row == firstVisibleRow) {
		disappearedRow = firstVisibleRow +visibleRowCount;
	}
	
	if (disappearedRow < 0) {
		didFinishBlock(shouldContinue, integerNotDefined, NO);
		
		return;
	}
	
	
	// Canceling queuedOperations
	BOOL shouldEvaluateBackward = NO;
	
	if (indexPath.row == lastVisibleRow) {
		shouldEvaluateBackward = YES;
	}
	
	shouldContinue = YES;
	
	
	didFinishBlock(shouldContinue, disappearedRow, shouldEvaluateBackward);
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {	FXDLog_OVERRIDE;
	
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {	FXDLog_OVERRIDE;
	
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {	FXDLog_OVERRIDE;
	
	FXDLog(@"type: %d indexPath: %@ newIndexPath: %@", type, indexPath, newIndexPath);	
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {	FXDLog_OVERRIDE;
	
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (self.shouldSkipDismissingByPullingDown) {
		return;
	}
	
	
	if (scrollView.contentOffset.y < (self.offsetYdismissingController-scrollView.contentInset.top)
		&& self.didStartDismissingByPullingDown == NO) {
		FXDLog(@"self.offsetYdismissingController: %f", self.offsetYdismissingController);
		
		[self dismissByPullingDownScrollView:scrollView];
	}
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	//FXDLog(@"scrollView.scrollsToTop: %d self.didStartAutoScrollingToTop: %d", scrollView.scrollsToTop, self.didStartAutoScrollingToTop);
	
	self.didStartAutoScrollingToTop = scrollView.scrollsToTop;
	
	return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	
	self.didStartAutoScrollingToTop = NO;
}

@end