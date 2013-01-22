//
//  FXDsuperTableController.h
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#define limitConcurrentOperationCount	1


#import "FXDKit.h"


@interface FXDsuperTableController : FXDViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    // Primitives
	BOOL _didStartAutoScrollingToTop;

	// Instance variables
	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;

	NSDictionary *_cellTexts;
	NSArray *_rowCounts;

	NSMutableArray *_mainDataSource;
	FXDFetchedResultsController *_mainResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_cellOperationDictionary;
}

// Properties
@property (assign, nonatomic) BOOL didStartAutoScrollingToTop;

@property (strong, nonatomic) NSString *mainCellIdentifier;
@property (strong, nonatomic) UINib *mainCellNib;

@property (strong, nonatomic) NSDictionary *cellTexts;
@property (strong, nonatomic) NSArray *rowCounts;

@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *cellOperationDictionary;


// IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *mainTableview;


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;

- (void)initializeCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;
- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (void)configureSectionPostionTypeForCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)cellTextAtIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;

#warning "//TODO: Only use this when supporting for iOS version previous to 6
- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath didFinishBlock:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))finishedHandler;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate
#pragma mark - UIScrollViewDelegate
#pragma mark - NSFetchedResultsControllerDelegate


@end
