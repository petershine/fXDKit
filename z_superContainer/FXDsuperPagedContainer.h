//
//  FXDsuperPagedContainer.h
//
//
//  Created by petershine on 5/3/13.
//  Copyright (c) 2013 Provus. All rights reserved.
//

#import "FXDPageViewController.h"


#import "FXDsuperContainer.h"

@interface FXDsuperPagedContainer : FXDsuperContainer <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
	// Primitive
	
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
- (id)pageForPageIndex:(NSInteger)pageIndex;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface FXDViewController (Paged)

#pragma mark - Public
- (NSInteger)pageIndexUsingDataSource:(NSMutableArray*)dataSource;

@end