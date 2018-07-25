

#import "FXDsceneScroll.h"


@implementation FXDsceneScroll

#pragma mark - Memory management
- (void)dealloc {
    [_cellOperationQueue resetOperationQueueAndDictionary:_cellOperationDictionary];
}


#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];

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
        
        [(id<FXDsceneWithCells>)self registerMainCellNib];


		if (self.offsetYdismissingController == 0.0) {
			CGRect screenBounds = [UIScreen mainScreen].bounds;
			//FXDLogRect(screenBounds);

			self.offsetYdismissingController = 0.0 -(screenBounds.size.height *scaleSceneDismissingOffset);
			//FXDLogVariable(self.offsetYdismissingController);
		}
	}
}


#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)willMoveToParentViewController:(UIViewController *)parent {

	if (parent == nil) {
		[self.cellOperationQueue resetOperationQueueAndDictionary:self.cellOperationDictionary];

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
	if (_mainCellIdentifier == nil) {
	}
	return _mainCellIdentifier;
}

#pragma mark -
- (NSArray*)itemCounts {
	if (_itemCounts == nil) {
	}
	return _itemCounts;
}

- (NSDictionary*)cellTitleDictionary {
	if (_cellTitleDictionary == nil) {
	}
	return _cellTitleDictionary;
}

- (NSDictionary*)cellSubTitleDictionary {
	if (_cellSubTitleDictionary == nil) {
	}
	return _cellSubTitleDictionary;
}

#pragma mark -
- (NSMutableArray*)mainDataSource {
	if (_mainDataSource == nil) {
	}
	return _mainDataSource;
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

#pragma mark -
- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView {	FXDLog_OVERRIDE;
	
#if DEBUG
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
//MARK: UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (self.shouldDismissingByPullingDown == NO) {
		return;
	}
	
	
	if (scrollView.contentOffset.y < (self.offsetYdismissingController-scrollView.contentInset.top)
		&& self.didStartDismissingByPullingDown == NO) {
		//FXDLogVariable(self.offsetYdismissingController);
		
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
