//
//  FXDsuperTableController.h
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define limitConcurrentOperationCount	1


#import "FXDViewController.h"

@interface FXDsuperTableController : FXDViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    // Primitives

	BOOL _isSystemVersionLatest;
	BOOL _didStartAutoScrollingToTop;

	BOOL _shouldCancelSecondaryOperation;
	
	// Instance variables
	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSArray *_rowCounts;
	NSDictionary *_cellTexts;
	NSDictionary *_segueNames;

	NSMutableArray *_mainDataSource;
	
	FXDFetchedResultsController *_mainResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_queuedCellOperationDictionary;

	NSOperationQueue *_secondaryOperationQueue;
	NSMutableDictionary *_secondaryQueuedOperationDictionary;
}

// Properties
@property (assign, nonatomic) BOOL isSystemVersionLatest;
@property (assign, nonatomic) BOOL didStartAutoScrollingToTop;

@property (assign, nonatomic) BOOL shouldCancelSecondaryOperation;

@property (strong, nonatomic) NSString *mainCellIdentifier;
@property (strong, nonatomic) UINib *mainCellNib;

@property (strong, nonatomic) NSArray *rowCounts;
@property (strong, nonatomic) NSDictionary *cellTexts;
@property (strong, nonatomic) NSDictionary *segueNames;

@property (strong, nonatomic) NSMutableArray *mainDataSource;

@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *queuedCellOperationDictionary;

@property (strong, nonatomic) NSOperationQueue *secondaryOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *secondaryQueuedOperationDictionary;


// IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *mainTableview;


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)didCancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;

- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (void)configureSectionPostionTypeForCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)cellTextAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)segueNameAtIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;

#warning @"//TODO: Only use this when supporting for iOS version previous to 6
- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath forFinishedHandler:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))finishedHandler;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate
#pragma mark - UIScrollViewDelegate
#pragma mark - NSFetchedResultsControllerDelegate


@end
