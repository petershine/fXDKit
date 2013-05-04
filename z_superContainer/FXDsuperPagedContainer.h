//
//  FXDsuperPagedContainer.h
//  PhotoAlbum
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#define limitVisiblePageCount	5


#import "FXDPageViewController.h"


@interface FXDseguePageAdding : FXDsuperTransitionSegue
@end

@interface FXDseguePageRemoving : FXDsuperTransitionSegue
@end


#import "FXDsuperContainer.h"

@interface FXDsuperPagedContainer : FXDsuperContainer <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
	
	// Instance variables
	NSMutableArray *_mainDataSource;
	
	NSOperationQueue *_pagedOperationQueue;
	NSMutableDictionary *_pagedOperationDictionary;

	
	FXDPageViewController *_mainPageController;
}

// Properties
@property (strong, nonatomic) NSMutableArray *mainDataSource;

@property (strong, nonatomic) NSOperationQueue *pagedOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *pagedOperationDictionary;

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDPageViewController *mainPageController;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
