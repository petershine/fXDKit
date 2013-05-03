//
//  FXDsuperPageContainer.h
//  PhotoAlbum
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDPageViewController.h"


#import "FXDsuperContainer.h"

@interface FXDsuperPageContainer : FXDsuperContainer <NSCacheDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
	
	// Instance variables
	NSMutableArray *_mainDataSource;
	NSCache *_cachedPagesDictionary;
	
	NSOperationQueue *_pagingOperationQueue;
	NSMutableDictionary *_pagingOperationDictionary;

	
	FXDPageViewController *_mainPageController;
}

// Properties
@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) NSCache *cachedPagesDictionary;

@property (strong, nonatomic) NSOperationQueue *pagingOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *pagingOperationDictionary;

// IBOutlets
@property (strong, nonatomic) IBOutlet FXDPageViewController *mainPageController;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
