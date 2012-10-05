//
//  FXDsuperTableInterface.h
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define limitMaximumCachedImageCount	50


typedef NSString* (^FXDidentifierOperation)(NSInteger sectionIndex, NSInteger rowIndex);


#import "FXDKit.h"


@interface FXDsuperTableInterface : FXDViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    // Primitives
	
	// Instance variables
	FXDidentifierOperation _mainOperationIdentifier;
	
	// Properties : For accessor overriding
	BOOL _isSystemVersionLatest;
	BOOL _didStartAutoScrollingToTop;
	
	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSArray *_rowCounts;
	NSDictionary *_cellTexts;
	NSMutableArray *_mainDataSource;
	
	FXDFetchedResultsController *_mainResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_queuedOperationDictionary;

	NSOperationQueue *_secondaryOperationQueue;
	NSMutableDictionary *_secondaryQueuedOperationDictionary;

	NSMutableDictionary *_cachedImageDictionary;
}

// Properties
@property (assign, nonatomic) BOOL isSystemVersionLatest;
@property (assign, nonatomic) BOOL didStartAutoScrollingToTop;

@property (strong, nonatomic) NSString *mainCellIdentifier;
@property (strong, nonatomic) UINib *mainCellNib;

@property (strong, nonatomic) NSArray *rowCounts;
@property (strong, nonatomic) NSDictionary *cellTexts;
@property (strong, nonatomic) NSMutableArray *mainDataSource;

@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *queuedOperationDictionary;

@property (strong, nonatomic) NSOperationQueue *secondaryOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *secondaryQueuedOperationDictionary;

@property (strong, nonatomic) NSMutableDictionary *cachedImageDictionary;


// IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *mainTableview;


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)didCancelQueuedCellOperationForIdentifier:(NSString*)operationIdentifier orAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;
- (BOOL)shouldSkipReturningCellForAutoScrollingToTop:(BOOL)isForAutoScrollingToTop forScrollView:(UIScrollView*)scrollView atIndexPath:(NSIndexPath*)indexPath;

- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)cellTextAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;

- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath forFinishedHandler:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))finishedHandler;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate
#pragma mark - UIScrollViewDelegate
#pragma mark - NSFetchedResultsControllerDelegate


@end
