//
//  FXDsuperPagedContainer.m
//  PhotoAlbum
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperPagedContainer.h"


@implementation FXDseguePageAdding
- (void)perform {	FXDLog_DEFAULT;
	
	__weak FXDsuperPagedContainer *pagedContainer = [self mainContainerOfClass:[FXDsuperPagedContainer class]];
	
	[pagedContainer.mainDataSource addObject:self.destinationViewController];
	
	[pagedContainer.mainPageController
	 setViewControllers:pagedContainer.mainDataSource
	 direction:UIPageViewControllerNavigationDirectionForward
	 animated:YES
	 completion:^(BOOL finished) {
		 if ([pagedContainer.mainDataSource count] > limitVisiblePageCount) {
			 [pagedContainer.mainDataSource removeObjectAtIndex:0];
		 }
		 
		 FXDLog(@"pagedContainer.mainDataSource: %@", pagedContainer.mainDataSource);
	 }];
}

@end

@implementation FXDseguePageRemoving
- (void)perform {
	
	__weak FXDsuperPagedContainer *pagedContainer = [self mainContainerOfClass:[FXDsuperPagedContainer class]];
	
	NSInteger lastCount = [pagedContainer.mainDataSource count];
	
	if ([pagedContainer.mainDataSource containsObject:self.destinationViewController]) {
		[pagedContainer.mainDataSource removeObject:self.destinationViewController];
	}
	
	if (lastCount == [pagedContainer.mainDataSource count]
		|| [pagedContainer.mainDataSource count] == 0) {
		return;
	}
	
	
	[pagedContainer.mainPageController
	 setViewControllers:pagedContainer.mainDataSource
	 direction:UIPageViewControllerNavigationDirectionReverse
	 animated:YES
	 completion:^(BOOL finished) {
		 FXDLog(@"pagedContainer.mainDataSource: %@", pagedContainer.mainDataSource);
	 }];
}

@end


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

#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	
	if (parent == nil) {
		if ([self.mainPageController respondsToSelector:@selector(delegate)]) {			
			[self.mainPageController setDelegate:nil];
		}
	}
	
	[super willMoveToParentViewController:parent];
}

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)beforeViewController {	FXDLog_OVERRIDE;
	
	UIViewController *previousController = nil;
	
	NSInteger beforeIndex = [self.mainDataSource indexOfObject:beforeViewController];
	
	if (beforeIndex > 0) {
		previousController = self.mainDataSource[beforeIndex--];
	}
	
	FXDLog(@"previousController: %@", previousController);
	FXDLog(@"BeforeViewController: %@", beforeViewController);
	
	return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)afterViewController {	FXDLog_OVERRIDE;
	
	UIViewController *nextController = nil;
	
	NSInteger afterIndex = [self.mainDataSource indexOfObject:afterViewController];
	
	if (afterIndex < [self.mainDataSource count]-1) {
		nextController = self.mainDataSource[afterIndex++];
	}
	
	FXDLog(@"AfterViewController: %@", afterViewController);
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