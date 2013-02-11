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

CGFloat _offsetYdismissingController = (-180.0);


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	// Instance variables
	FXDLog(@"_cellOperationQueue operationCount: %u", [_cellOperationQueue operationCount]);
	
	[_cellOperationQueue cancelAllOperations];
	_cellOperationQueue = nil;
	
	
	[_cellOperationDictionary removeAllObjects];
	_cellOperationDictionary = nil;
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];
	
	if (SCREEN_SIZE_35inch) {
		_offsetYdismissingController = (-140.0);
	}
	
	
	// Primitives
	
    // Instance variables
	
    // Properties
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    // IBOutlet
	if (self.mainScrollView == nil) {
		return;
	}
	
	
	if (self.mainScrollView.delegate == nil) {
		[self.mainScrollView setDelegate:self];
	}
	
	
	if ([self.mainScrollView performSelector:@selector(dataSource)] == nil
		&& [self.mainScrollView respondsToSelector:@selector(dataSource)]) {
		
		[self.mainScrollView performSelector:@selector(setDataSource:) withObject:self];
	}
	
	
	FXDLog(@"self.mainCellIdentifier: %@", self.mainCellIdentifier);
	FXDLog(@"self.mainCellNib: %@", self.mainCellNib);
	
	if (self.mainCellIdentifier || self.mainCellNib) {
		FXDLog(@"self.mainScrollView: %@", self.mainScrollView);
		
		if ([self.mainScrollView isKindOfClass:[UITableView class]]) {
			[(UITableView*)self.mainScrollView registerNib:self.mainCellNib forCellReuseIdentifier:self.mainCellIdentifier];
		}
		else if ([self.mainScrollView isKindOfClass:[UICollectionView class]]) {
			[(UICollectionView*)self.mainScrollView registerNib:self.mainCellNib forCellWithReuseIdentifier:self.mainCellIdentifier];
		}
	}
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
- (NSString*)mainCellIdentifier {
	if (_mainCellIdentifier == nil) {	//FXDLog_OVERRIDE;
		//
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
- (NSDictionary*)cellTexts {
	
	if (_cellTexts == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _cellTexts;
}

- (NSArray*)itemCounts {
	
	if (_itemCounts == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _itemCounts;
}

#pragma mark -
- (NSMutableArray*)mainDataSource {
	
	if (_mainDataSource == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _mainDataSource;
}

- (FXDFetchedResultsController*)mainResultsController {
	
	if (_mainResultsController == nil) {	//FXDLog_OVERRIDE;
		//
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
		FXDLog(@"self.mainResultsController sections: %@", [self.mainResultsController sections]);
		
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

- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section {	FXDLog_DEFAULT;
	
	NSInteger numberOfItems = 0;
	
	if (self.mainResultsController) {
		NSInteger fetchedObjectsCount = [self.mainResultsController.fetchedObjects count];
		
#if ForDEVELOPER
		NSArray *sections = self.mainResultsController.sections;
		
		if (section < [sections count]) {
			id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
			
			numberOfItems = [sectionInfo numberOfObjects];
		}
		
		if (numberOfItems != fetchedObjectsCount) {
			numberOfItems = fetchedObjectsCount;
		}
#else
		numberOfRows = fetchedObjectsCount;
#endif
		FXDLog(@"section: %d numberOfRows: %d == fetchedObjectsCount: %d", section, numberOfItems, fetchedObjectsCount);
	}
	else if (self.mainDataSource) {
		numberOfItems = [self.mainDataSource count];
	}
	else if (self.itemCounts) {	//FXDLog_OVERRIDE;
		numberOfItems = [(self.itemCounts)[section] integerValue];
	}
	
	return numberOfItems;
}

#pragma mark -
- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView {	FXDLog_OVERRIDE;
	
	if (scrollView == nil) {
		scrollView = self.mainScrollView;
		
		if (scrollView == nil) {
			FXDLog(@"self.mainScrollView: %@", self.mainScrollView);
		}
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
	if ([self.mainScrollView isKindOfClass:[UITableView class]] == NO) {
		FXDLog(@"self.mainScrollView: %@", self.mainScrollView);
		
		didFinishBlock(shouldContinue, integerNotDefined, NO);
		return;
	}
	
	
	NSArray *visibleIndexPaths = [(UITableView*)self.mainScrollView indexPathsForVisibleRows];
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
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (self.backgroundviewSticky) {
		CGRect modifiedFrame = self.backgroundviewSticky.frame;
		
		CGFloat modifiedOffsetY = (scrollView.contentOffset.y +scrollView.contentInset.top);
		
		if (modifiedOffsetY < 0.0) {
			modifiedFrame.origin.y = (0.0 -modifiedOffsetY);
		}
		else {
			modifiedFrame.origin.y = 0.0;
		}
		
		[self.backgroundviewSticky setFrame:modifiedFrame];
	}
	
	
	if (scrollView.contentOffset.y < _offsetYdismissingController && self.didStartDismissingByPullingDown == NO) {
		FXDLog(@"_offsetYdismissingController: %f", _offsetYdismissingController);
		
		[self dismissByPullingDownScrollView:scrollView];
	}
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {	FXDLog_DEFAULT;
	FXDLog(@"scrollView.scrollsToTop: %d self.didStartAutoScrollingToTop: %d", scrollView.scrollsToTop, self.didStartAutoScrollingToTop);
	
	self.didStartAutoScrollingToTop = scrollView.scrollsToTop;
	
	return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {	FXDLog_DEFAULT;
	
	self.didStartAutoScrollingToTop = NO;
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {
	
	if ([self.mainScrollView respondsToSelector:@selector(beginUpdates)]) {
		[self.mainScrollView performSelector:@selector(beginUpdates)];
	}
	else {
		FXDLog_OVERRIDE;
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {	FXDLog_OVERRIDE;
	
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {	FXDLog_OVERRIDE;
	
	FXDLog(@"type: %d indexPath: %@ newIndexPath: %@", type, indexPath, newIndexPath);
	
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	
	if ([self.mainScrollView respondsToSelector:@selector(endUpdates)]) {
		[self.mainScrollView performSelector:@selector(endUpdates)];
	}
	else {
		FXDLog_OVERRIDE;
	}
	
}

@end