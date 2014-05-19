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

#pragma mark - Initialization
- (void)viewDidLoad {
	[super viewDidLoad];
		
	if (self.mainPageController == nil) {
		for (UIViewController *childController in self.childViewControllers) {
			if ([childController isKindOfClass:[UIPageViewController class]]) {
				self.mainPageController = (FXDPageViewController*)childController;
				break;
			}
		}
	}
	
	FXDLogObject(self.mainPageController);
	
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

#pragma mark - Property overriding
- (NSMutableArray*)mainDataSource {
	
	if (_mainDataSource == nil) {	FXDLog_DEFAULT;
		_mainDataSource = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	return _mainDataSource;
}


#pragma mark - Method overriding

#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)addPreviewPageWithAddedObj:(id)addedObj {	FXDLog_DEFAULT;

	__weak FXDsuperPagedContainer *weakSelf = self;

	[weakSelf.mainDataSource addObject:addedObj];
	
	
	FXDsuperPlaybackScene *previewPage = [weakSelf previewPageForModifiedPageIndex:[weakSelf.mainDataSource count]-1];
	
	[weakSelf.mainPageController
	 setViewControllers:@[previewPage]
	 direction:UIPageViewControllerNavigationDirectionForward
	 animated:YES
	 completion:^(BOOL didFinish) {
		 FXDLog_BLOCK(weakSelf.mainPageController, @selector(setViewControllers:direction:animated:completion:));
	 }];
}

#pragma mark -
- (id)previewPageForModifiedPageIndex:(NSInteger)modifiedPageIndex {	FXDLog_OVERRIDE;
	FXDLogVariable(modifiedPageIndex);
	
	return nil;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(FXDsuperPlaybackScene*)beforeViewController {	FXDLog_DEFAULT;
	
	UIViewController *previousController = nil;
	
	NSInteger modifiedPageIndex = beforeViewController.previewPageIndex;
	modifiedPageIndex--;
	
	if (modifiedPageIndex >= 0) {
		previousController = [self previewPageForModifiedPageIndex:modifiedPageIndex];
	}
	
	FXDLog(@"%@ %@", _Variable(modifiedPageIndex), _Object(previousController));
	
	return previousController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(FXDsuperPlaybackScene*)afterViewController {	FXDLog_DEFAULT;
	
	UIViewController *nextController = nil;
	
	NSInteger modifiedPageIndex = afterViewController.previewPageIndex;
	modifiedPageIndex++;
	
	if (modifiedPageIndex < [self.mainDataSource count]) {		
		nextController = [self previewPageForModifiedPageIndex:modifiedPageIndex];
	}
	
	FXDLog(@"%@ %@", _Variable(modifiedPageIndex), _Object(nextController));
	
	return nextController;
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {	FXDLog_DEFAULT;
	FXDLogObject(pendingViewControllers);
	
	// Sent when a gesture-initiated transition begins.
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
	FXDLog(@"%@ %@ %@", _BOOL(finished), _BOOL(completed), _Object(previousViewControllers));
	
	// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
}

@end
