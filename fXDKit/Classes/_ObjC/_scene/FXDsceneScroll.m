

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
