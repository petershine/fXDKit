//
//  FXDsuperScrollScene.m
//
//
//  Created by petershine on 2/5/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperScrollScene.h"


#pragma mark - Public implementation
@implementation FXDsuperScrollScene


#pragma mark - Memory management
- (void)dealloc {
	[_cellOperationQueue resetOperationQueue];
}


#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	if (self.mainResultsController && self.mainResultsController.additionalDelegate == nil) {
		[self.mainResultsController setAdditionalDelegate:self];

		FXDLogObject(self.mainResultsController.additionalDelegate);
	}
	
	if (self.mainScrollview) {
		//MARK: Following should be closely related to scroll view configuration
		FXDLogObject(self.mainScrollview);

		if (self.mainScrollview.delegate == nil) {
			[self.mainScrollview setDelegate:self];
		}

		FXDLogObject(self.mainScrollview.delegate);


		if ([self.mainScrollview respondsToSelector:@selector(dataSource)]
			&& [self.mainScrollview performSelector:@selector(dataSource)] == nil) {

			[self.mainScrollview performSelector:@selector(setDataSource:) withObject:self];
		}


		[self registerMainCellNib];


		if (self.offsetYdismissingController == 0.0) {
			CGRect screenBounds = [[UIScreen mainScreen] bounds];
			FXDLogRect(screenBounds);

			self.offsetYdismissingController = 0.0 -(screenBounds.size.height *scaleControllerDismissingOffset);
			FXDLogVariable(self.offsetYdismissingController);
		}
	}
}


#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding
- (UINib*)mainCellNib {
	if (_mainCellNib == nil) {
		if (self.mainCellIdentifier) {	FXDLog_DEFAULT;
			_mainCellNib = [UINib nibWithNibName:self.mainCellIdentifier bundle:nil];
		}
		
#if ForDEVELOPER
		if (_mainCellNib) {	FXDLog_DEFAULT;
			FXDLogObject(_mainCellNib);
		}
#endif
	}
	
	return _mainCellNib;
}

- (NSString*)mainCellIdentifier {
	if (_mainCellIdentifier == nil) {
		FXDLog_OVERRIDE;
	}
	
	return _mainCellIdentifier;
}

#pragma mark -
- (NSArray*)itemCounts {
	
	if (_itemCounts == nil) {
		FXDLog_OVERRIDE;
	}
	
	return _itemCounts;
}

- (NSDictionary*)cellTitleDictionary {
	
	if (_cellTitleDictionary == nil) {
		FXDLog_OVERRIDE;
	}
	
	return _cellTitleDictionary;
}

- (NSDictionary*)cellSubTitleDictionary {
	if (_cellSubTitleDictionary == nil) {
		FXDLog_OVERRIDE;
	}
	
	return _cellSubTitleDictionary;
}

#pragma mark -
- (NSMutableArray*)mainDataSource {
	
	if (_mainDataSource == nil) {
		FXDLog_OVERRIDE;
	}
	
	return _mainDataSource;
}

- (FXDFetchedResultsController*)mainResultsController {
	
	if (_mainResultsController == nil) {
		FXDLog_OVERRIDE;
	}
	
	return _mainResultsController;
}

#pragma mark -
- (FXDOperationQueue*)cellOperationQueue {
	
	if (_cellOperationQueue == nil) {	FXDLog_DEFAULT;
		_cellOperationQueue = [FXDOperationQueue newSerialQueue];
	}
	
	return _cellOperationQueue;
}


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	
	if (parent == nil) {
		[self.cellOperationQueue resetOperationQueue];
		
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
	FXDLogObject(self.mainCellIdentifier);
	FXDLogObject(self.mainCellNib);
}

#pragma mark -
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex {
	
	BOOL didCancel = NO;
	
	id operationKey = nil;
	
	if (indexPath) {
		operationKey = indexPath;
	}
	else if (rowIndex != integerNotDefined) {
		operationKey = NSIndexPathMake(0, rowIndex);
	}
	
	if (operationKey == nil) {
		return didCancel;
	}
	

	didCancel = [self.cellOperationQueue cancelForOperationKey:operationKey];	
	
	return didCancel;
}

#pragma mark -
- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView {
	
	NSInteger numberOfSections = 1;
	
	if (self.mainResultsController) {
		numberOfSections = [[self.mainResultsController sections] count];
	}
	else if (self.mainDataSource) {
		//MARK: Assume it's just one array
	}
	else if (self.itemCounts) {
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
		
		if (numberOfItems != fetchedCount) {	FXDLog_DEFAULT;
			FXDLog(@"%@ %@ == %@", _Variable(section), _Variable(numberOfItems), _Variable(fetchedCount));
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
	
	FXDLog(@"%@ %@", _Variable(scrollView.contentOffset.y), _BOOL(self.didStartDismissingByPullingDown));
#endif
	
	if (self.didStartDismissingByPullingDown) {
		return;
	}
	
	
	self.didStartDismissingByPullingDown = YES;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {
	if ([self.mainScrollview respondsToSelector:@selector(beginUpdates)]) {
		[self.mainScrollview performSelector:@selector(beginUpdates)];
	}
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {
	if ([self.mainScrollview respondsToSelector:@selector(endUpdates)]) {
		[self.mainScrollview performSelector:@selector(endUpdates)];
	}
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
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
		FXDLogVariable(self.offsetYdismissingController);
		
		[self dismissByPullingDownScrollView:scrollView];
	}
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
	self.didStartAutoScrollingToTop = scrollView.scrollsToTop;
	
	return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
	
	self.didStartAutoScrollingToTop = NO;
}

@end