//
//  FXDsuperPagedContainer.m
//  PhotoAlbum
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDsuperPagedContainer.h"


@implementation FXDseguePageAdding
- (void)perform {
	FXDsuperPagedContainer *pagedContainer = (FXDsuperPagedContainer*)self.sourceViewController;
	
	if ([pagedContainer isKindOfClass:[FXDsuperPagedContainer class]] == NO) {
		pagedContainer = (FXDsuperPagedContainer*)[self.sourceViewController parentViewController];
	}
}

@end

@implementation FXDseguePageRemoving
- (void)perform {
	FXDsuperPagedContainer *pagedContainer = (FXDsuperPagedContainer*)self.sourceViewController;
	
	if ([pagedContainer isKindOfClass:[FXDsuperPagedContainer class]] == NO) {
		pagedContainer = (FXDsuperPagedContainer*)[self.sourceViewController parentViewController];
	}
}

@end


#pragma mark - Public implementation
@implementation FXDsuperPagedContainer


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
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

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {	FXDLog_DEFAULT;
	FXDLog(@"obj: %@", obj);
	
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {	FXDLog_OVERRIDE;
	FXDLog(@"BeforeViewController: %@", viewController);
	
	return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {	FXDLog_OVERRIDE;
	FXDLog(@"AfterViewController: %@", viewController);
	
	return nil;
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