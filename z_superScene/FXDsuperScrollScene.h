//
//  FXDsuperScrollScene.h
//
//
//  Created by petershine on 2/5/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//


#ifndef scaleControllerDismissingOffset
	#define scaleControllerDismissingOffset	0.275
#endif


@interface FXDsuperScrollScene : FXDViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate> {

	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSDictionary *_cellTitleDictionary;
	NSDictionary *_cellSubTitleDictionary;
	NSArray *_itemCounts;
	
	NSMutableArray *_mainDataSource;
	FXDFetchedResultsController *_mainResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_cellOperationDictionary;
	
	UIScrollView *_mainScrollview;
}

@property (nonatomic) BOOL didStartAutoScrollingToTop;

@property (nonatomic) BOOL shouldDismissingByPullingDown;
@property (nonatomic) BOOL didStartDismissingByPullingDown;

@property (nonatomic) CGFloat offsetYdismissingController;

@property (strong, nonatomic) UINib *mainCellNib;
@property (strong, nonatomic) NSString *mainCellIdentifier;

@property (strong, nonatomic) NSArray *itemCounts;
@property (strong, nonatomic) NSDictionary *cellTitleDictionary;
@property (strong, nonatomic) NSDictionary *cellSubTitleDictionary;

@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *cellOperationDictionary;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollview;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)registerMainCellNib;

- (void)stopAllCellOperations;
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;

- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView;
- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section;

- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
