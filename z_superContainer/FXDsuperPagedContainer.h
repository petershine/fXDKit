//
//  FXDsuperPagedContainer.h
//
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDPageViewController.h"
#import "FXDsuperPlaybackScene.h"


@interface FXDsuperPagedContainer : FXDsuperContainer <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
	NSMutableArray *_mainDataSource;
	FXDPageViewController *_mainPageController;
}

@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) FXDPageViewController *mainPageController;

// IBOutlets


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)addPreviewPageWithAddedObj:(id)addedObj;

- (id)previewPageForModifiedPageIndex:(NSInteger)modifiedPageIndex;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
