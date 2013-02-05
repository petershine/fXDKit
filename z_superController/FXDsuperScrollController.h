//
//  FXDsuperScrollController.h
//
//
//  Created by petershine on 2/5/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#define limitConcurrentOperationCount	1


#import "FXDKit.h"


@interface FXDsuperScrollController : FXDViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate> {
    // Primitives
	
	// Instance variables
	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSMutableArray *_mainDataSource;
	FXDFetchedResultsController *_mainResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_cellOperationDictionary;
	
	UIScrollView *_mainScrollView;
}

// Properties
@property (assign, nonatomic) BOOL didStartAutoScrollingToTop;

@property (strong, nonatomic) NSString *mainCellIdentifier;
@property (strong, nonatomic) UINib *mainCellNib;

@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) FXDFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *cellOperationDictionary;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;

#warning "//TODO: Only use this when supporting for iOS version previous to 6
- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath didFinishBlock:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))finishedHandler;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
