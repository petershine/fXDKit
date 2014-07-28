

#import "FXDsceneScroll.h"


@implementation FXDsceneScroll

#pragma mark - Memory management
- (void)dealloc {
	[_cellOperationQueue resetOperationQueueAndDictionary:_cellOperationDictionary];
}


#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

	if (self.mainResultsController && self.mainResultsController.delegate == nil) {
		self.mainResultsController.delegate = self;
	}
	
	if (self.mainScrollview) {
		//MARK: Following should be closely related to scroll view configuration
		FXDLogObject(self.mainScrollview);

		if (self.mainScrollview.delegate == nil) {
			self.mainScrollview.delegate = self;
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

			self.offsetYdismissingController = 0.0 -(screenBounds.size.height *scaleSceneDismissingOffset);
			FXDLogVariable(self.offsetYdismissingController);
		}
	}
}


#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)willMoveToParentViewController:(UIViewController *)parent {

	if (parent == nil) {
		[self.cellOperationQueue resetOperationQueueAndDictionary:self.cellOperationDictionary];

		if (self.mainResultsController.delegate == self) {
			self.mainResultsController.delegate = nil;
		}

		if ([self.mainScrollview respondsToSelector:@selector(setDelegate:)]) {
			[self.mainScrollview performSelector:@selector(setDelegate:) withObject:nil];
		}
	}

	[super willMoveToParentViewController:parent];
}


#pragma mark - Property overriding
- (UINib*)mainCellNib {
	if (_mainCellNib == nil) {
		if (self.mainCellIdentifier) {
			_mainCellNib = [UINib nibWithNibName:self.mainCellIdentifier bundle:nil];
		}
		

		if (_mainCellNib) {	FXDLog_DEFAULT;
			FXDLogObject(_mainCellNib);
		}
	}
	
	return _mainCellNib;
}

- (NSString*)mainCellIdentifier {
	if (_mainCellIdentifier == nil) {	FXDLog_OVERRIDE;
	}
	
	return _mainCellIdentifier;
}

#pragma mark -
- (NSArray*)itemCounts {
	if (_itemCounts == nil) {	//FXDLog_OVERRIDE;
	}
	return _itemCounts;
}

- (NSDictionary*)cellTitleDictionary {
	if (_cellTitleDictionary == nil) {	//FXDLog_OVERRIDE;
	}
	return _cellTitleDictionary;
}

- (NSDictionary*)cellSubTitleDictionary {
	if (_cellSubTitleDictionary == nil) {	//FXDLog_OVERRIDE;
	}
	return _cellSubTitleDictionary;
}

#pragma mark -
- (NSMutableArray*)mainDataSource {
	if (_mainDataSource == nil) {	//FXDLog_OVERRIDE;
	}
	return _mainDataSource;
}

- (NSFetchedResultsController*)mainResultsController {
	if (_mainResultsController == nil) {	//FXDLog_OVERRIDE;
	}
	return _mainResultsController;
}

#pragma mark -
- (NSOperationQueue*)cellOperationQueue {
	if (_cellOperationQueue == nil) {	//FXDLog_DEFAULT;
		_cellOperationQueue = [NSOperationQueue newSerialQueueWithName:NSStringFromSelector(_cmd)];
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

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)registerMainCellNib {	FXDLog_OVERRIDE;
	FXDLogObject(self.mainCellIdentifier);
	FXDLogObject(self.mainCellNib);
}

#pragma mark -
- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView {
	
	NSInteger numberOfSections = 1;
	
	if (self.mainResultsController) {
		numberOfSections = self.mainResultsController.sections.count;
	}
	else if (self.mainDataSource) {
		//MARK: Assume it's just one array
	}
	else if (self.itemCounts) {
		numberOfSections = self.itemCounts.count;
	}
	
	return numberOfSections;
}

- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section {
	
	NSUInteger numberOfItems = 0;
	
	if (self.mainResultsController) {
		NSUInteger fetchedCount = self.mainResultsController.fetchedObjects.count;
		
#if ForDEVELOPER
		NSArray *sections = self.mainResultsController.sections;
		
		if (section < sections.count) {
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
		numberOfItems = self.mainDataSource.count;
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


#pragma mark - Observer

#pragma mark - Delegate
//MARK: NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller {
	if ([self.mainScrollview respondsToSelector:@selector(beginUpdates)]) {
		[self.mainScrollview performSelector:@selector(beginUpdates)];
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
	if ([self.mainScrollview respondsToSelector:@selector(endUpdates)]) {
		[self.mainScrollview performSelector:@selector(endUpdates)];
	}
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	if ([self.mainScrollview isKindOfClass:[UITableView class]] == NO) {
		return;
	}


	if (indexPath == nil) {
		return;
	}


	UITableView *tableView = (UITableView*)self.mainScrollview;
	
	if (type == NSFetchedResultsChangeInsert) {
		[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else if (type == NSFetchedResultsChangeDelete) {
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else if (type == NSFetchedResultsChangeUpdate) {
		[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}


	if (newIndexPath == nil) {
		return;
	}


	if (type == NSFetchedResultsChangeMove) {
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

//MARK: UIScrollViewDelegate
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