//
//  FXDsuperScrollScene.h
//
//
//  Created by petershine on 2/5/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#ifndef scaleSceneDismissingOffset
	#define scaleSceneDismissingOffset	0.275
#endif


@interface FXDsuperScrollScene : FXDViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate> {

	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSDictionary *_cellTitleDictionary;
	NSDictionary *_cellSubTitleDictionary;
	NSArray *_itemCounts;
	
	NSMutableArray *_mainDataSource;
	NSFetchedResultsController *_mainResultsController;
	
	FXDOperationQueue *_cellOperationQueue;
	
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
@property (strong, nonatomic) NSFetchedResultsController *mainResultsController;

@property (strong, nonatomic) FXDOperationQueue *cellOperationQueue;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollview;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)registerMainCellNib;

- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;

- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView;
- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section;

- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
