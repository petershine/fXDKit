//
//  FXDsuperPagedContainer.m
//
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperPagedContainer.h"


#pragma mark - Public implementation
@implementation FXDsuperPagedContainer


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[_pagedOperationQueue cancelAllOperations];
	_pagedOperationQueue = nil;
	
	[_pagedOperationDictionary removeAllObjects];
	_pagedOperationDictionary = nil;
	
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
	if (self.mainPageController == nil) {
		for (UIViewController *childController in self.childViewControllers) {
			if ([childController isKindOfClass:[UIPageViewController class]]) {
				self.mainPageController = (FXDPageViewController*)childController;
				break;
			}
		}
	}
	
	FXDLog(@"self.mainPageController: %@", self.mainPageController);
	
	if (self.mainPageController) {
		if (self.mainPageController.dataSource == nil) {
			[self.mainPageController setDataSource:self];
		}
		
		if (self.mainPageController.delegate == nil) {
			[self.mainPageController setDelegate:self];
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
- (NSMutableArray*)mainDataSource {
	
	if (_mainDataSource == nil) {
		_mainDataSource = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	return _mainDataSource;
}


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	
	if (parent == nil) {
		
		if ([self.mainPageController respondsToSelector:@selector(setDelegate:)]) {
			[self.mainPageController performSelector:@selector(setDelegate:) withObject:nil];
		}
		
		if ([self.mainPageController respondsToSelector:@selector(setDataSource:)]) {
			[self.mainPageController performSelector:@selector(setDataSource:) withObject:nil];
		}
	}
	
	[super willMoveToParentViewController:parent];
}


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (id)pageForPageIndex:(NSInteger)pageIndex {	FXDLog_OVERRIDE;
	FXDLog(@"pageIndex: %d self.mainDataSource count: %d", pageIndex, [self.mainDataSource count]);
	
	return nil;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(FXDViewController*)beforeViewController {	FXDLog_DEFAULT;
	
	UIViewController *previousController = nil;
	
	NSInteger currentPageIndex = [beforeViewController pageIndexUsingDataSource:self.mainDataSource];
	
	if (currentPageIndex-1 >= 0) {
		currentPageIndex--;
		
		previousController = [self pageForPageIndex:currentPageIndex];
	}
	
	FXDLog(@"previousController: %@", previousController);
	
	return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(FXDViewController*)afterViewController {	FXDLog_DEFAULT;
	
	UIViewController *nextController = nil;
	
	NSInteger currentPageIndex = [afterViewController pageIndexUsingDataSource:self.mainDataSource];
	
	if (currentPageIndex+1 < [self.mainDataSource count]) {
		currentPageIndex++;
		
		nextController = [self pageForPageIndex:currentPageIndex];
	}
	
	FXDLog(@"nextController: %@", nextController);
	
	return nextController;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {	FXDLog_DEFAULT;
	FXDLog(@"pendingViewControllers: %@", pendingViewControllers);
	
	// Sent when a gesture-initiated transition begins.
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
	FXDLog(@"finished: %d completed: %d previousViewControllers: %@", finished, completed, previousViewControllers);
	
	// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
}

@end


#pragma mark - Category
@implementation FXDViewController (Paged)

#pragma mark - Public
- (NSInteger)pageIndexUsingDataSource:(NSMutableArray*)dataSource {	FXDLog_OVERRIDE;
	FXDLog(@"dataSource: %@", dataSource);
	
	return 0;
}

@end