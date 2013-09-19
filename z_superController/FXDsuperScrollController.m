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
	[self stopAllCellOperations];
}


#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];
	
	FXDLog(@"self.mainScrollview: %@", self.mainScrollview);
	
	if (self.mainScrollview == nil) {
		return;
	}
	
	
	//MARK: Following should be closely related to scroll view configuration
	
	if (self.mainScrollview.delegate == nil) {
		[self.mainScrollview setDelegate:self];
	}
	
	
	if ([self.mainScrollview respondsToSelector:@selector(dataSource)]
		&& [self.mainScrollview performSelector:@selector(dataSource)] == nil) {
		
		[self.mainScrollview performSelector:@selector(setDataSource:) withObject:self];
	}
	
	
	[self registerMainCellNib];
	
	
	if (self.offsetYdismissingController == 0.0) {
		CGRect screenBounds = [[UIScreen mainScreen] bounds];
		FXDLog(@"screenBounds: %@", NSStringFromCGRect(screenBounds));
		
		self.offsetYdismissingController = 0.0 -(screenBounds.size.height *scaleControllerDismissingOffset);
		FXDLog(@"self.offsetYdismissingController: %f", self.offsetYdismissingController);
	}

	if (self.mainResultsController && self.mainResultsController.additionalDelegate == nil) {
		[self.mainResultsController setAdditionalDelegate:self];
		
		FXDLog(@"self.mainResultsController.additionalDelegate: %@", self.mainResultsController.additionalDelegate);
	}
}


#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding
- (UINib*)mainCellNib {
	if (_mainCellNib == nil) {
		if (self.mainCellIdentifier) {
			_mainCellNib = [UINib nibWithNibName:self.mainCellIdentifier bundle:nil];
		}
		
#if ForDEVELOPER
		if (_mainCellNib) {	FXDLog_DEFAULT;
			FXDLog(@"_mainCellNib: %@", _mainCellNib);
		}
#endif
	}
	
	return _mainCellNib;
}

- (NSString*)mainCellIdentifier {
	if (_mainCellIdentifier == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _mainCellIdentifier;
}

#pragma mark -
- (NSArray*)itemCounts {
	
	if (_itemCounts == nil) {
		//FXDLog_OVERRIDE;
	}
	
	return _itemCounts;
}

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
	
	if (_cellOperationQueue == nil) {	//FXDLog_DEFAULT;
		_cellOperationQueue = [[NSOperationQueue alloc] init];
		[_cellOperationQueue setMaxConcurrentOperationCount:limitConcurrentOperationCount];
	}
	
	return _cellOperationQueue;
}

- (NSMutableDictionary*)cellOperationDictionary {
	
	if (_cellOperationDictionary == nil) {	//FXDLog_DEFAULT;
		_cellOperationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _cellOperationDictionary;
}


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	
	if (parent == nil) {
		[self stopAllCellOperations];
		
		if (self.mainResultsController.additionalDelegate == self) {
			[self.mainResultsController setAdditionalDelegate:nil];
		}
		
		if ([self.mainScrollview respondsToSelector:@selector(setDelegate:)]) {
			[self.mainScrollview performSelector:@selector(setDelegate:) withObject:nil];
		}
	}
	
	[super willMoveToParentViewController:parent];
}


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)registerMainCellNib {	FXDLog_OVERRIDE;
	FXDLog(@"self.mainCellIdentifier: %@", self.mainCellIdentifier);
	FXDLog(@"self.mainCellNib: %@", self.mainCellNib);
}

#pragma mark -
- (void)stopAllCellOperations {
	[_cellOperationDictionary removeAllObjects];
	[_cellOperationQueue cancelAllOperations];
}

- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex {
	
	BOOL didCancel = NO;
	
	id operationObjKey = nil;
	
	if (indexPath) {
		operationObjKey = indexPath;
	}
	else if (rowIndex != integerNotDefined) {
		operationObjKey = NSIndexPathMake(0, rowIndex);
	}
	
	if (operationObjKey == nil) {
		return didCancel;
	}
	
	
	FXDBlockOperation *cellOperation = (self.cellOperationDictionary)[operationObjKey];
	
	if (cellOperation) {
		[cellOperation cancel];
		
		didCancel = [cellOperation isCancelled];
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
	
	NSUInteger numberOfItems = 0;
	
	if (self.mainResultsController) {
		NSUInteger fetchedCount = [self.mainResultsController.fetchedObjects count];
		
#if ForDEVELOPER
		NSArray *sections = self.mainResultsController.sections;
		
		if (section < [sections count]) {
			id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
			
			numberOfItems = [sectionInfo numberOfObjects];
		}
		
		if (numberOfItems != fetchedCount) {	//FXDLog_DEFAULT;
			FXDLog(@"section: %ld numberOfItems: %ld == fetchedCount: %lu", (long)section, (long)numberOfItems, (unsigned long)fetchedCount);
		}
#else
		numberOfItems = fetchedCount;
#endif
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
	
	return (NSInteger)numberOfItems;
}

#pragma mark -
- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView {	FXDLog_OVERRIDE;
	
#if ForDEVELOPER
	if (scrollView == nil) {
		scrollView = self.mainScrollview;
	}
	
	FXDLog(@"contentOffset.y: %f didStartDismissingByPullingDown: %d", scrollView.contentOffset.y, self.didStartDismissingByPullingDown);
#endif
	
	if (self.didStartDismissingByPullingDown) {
		return;
	}
	
	
	self.didStartDismissingByPullingDown = YES;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {	//FXDLog_OVERRIDE;
	if ([self.mainScrollview respondsToSelector:@selector(beginUpdates)]) {
		[self.mainScrollview performSelector:@selector(beginUpdates)];
	}
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {	//FXDLog_OVERRIDE;
	if ([self.mainScrollview respondsToSelector:@selector(endUpdates)]) {
		[self.mainScrollview performSelector:@selector(endUpdates)];
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	//FXDLog_OVERRIDE;
	//FXDLog(@"type: %d indexPath: %@ newIndexPath: %@", type, indexPath, newIndexPath);
	
	if ([self.mainScrollview isKindOfClass:[UITableView class]] == NO) {
		return;
	}
	
	
	UITableView *tableView = (UITableView*)self.mainScrollview;
	
	if (type == NSFetchedResultsChangeInsert) {
		if (newIndexPath) {
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	else if (type == NSFetchedResultsChangeDelete) {
		if (indexPath) {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	else if (type == NSFetchedResultsChangeUpdate) {
		if (indexPath) {
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	else if (type == NSFetchedResultsChangeMove) {
		if (indexPath && newIndexPath) {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (self.shouldDismissingByPullingDown == NO) {
		return;
	}
	
	
	if (scrollView.contentOffset.y < (self.offsetYdismissingController-scrollView.contentInset.top)
		&& self.didStartDismissingByPullingDown == NO) {
		FXDLog(@"self.offsetYdismissingController: %f", self.offsetYdismissingController);
		
		[self dismissByPullingDownScrollView:scrollView];
	}
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	self.didStartAutoScrollingToTop = scrollView.scrollsToTop;
	
	return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	
	self.didStartAutoScrollingToTop = NO;
}

@end