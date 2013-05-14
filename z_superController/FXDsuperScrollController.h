//
//  FXDsuperScrollController.h
//
//
//  Created by petershine on 2/5/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#define scaleControllerDismissingOffset	0.265


@interface FXDsuperScrollController : FXDViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate> {
    // Primitives
	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSDictionary *_cellTitleDictionary;
	NSDictionary *_cellSubTitleDictionary;
	NSArray *_itemCounts;
	
	NSMutableArray *_mainDataSource;
	FXDFetchedResultsController *_mainResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_cellOperationDictionary;
	
	
	UIView *_mainScrollBackgroundView;
	
	UIScrollView *_mainScrollview;
}

// Properties
@property (assign, nonatomic) BOOL didStartAutoScrollingToTop;

@property (assign, nonatomic) BOOL shouldSkipDismissingByPullingDown;
@property (assign, nonatomic) BOOL didStartDismissingByPullingDown;

@property (assign, nonatomic) CGFloat offsetYdismissingController;

@property (strong, nonatomic) NSString *mainCellIdentifier;
@property (strong, nonatomic) UINib *mainCellNib;

@property (strong, nonatomic) NSDictionary *cellTitleDictionary;
@property (strong, nonatomic) NSDictionary *cellSubTitleDictionary;
@property (strong, nonatomic) NSArray *itemCounts;

@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *cellOperationDictionary;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIView *mainScrollBackgroundView;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollview;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;

- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView;
- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section;

- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView;

#warning "//TODO: Only use this when supporting for iOS version previous to 6
- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath didFinishBlock:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))finishedHandler;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
