//
//  FXDsuperTableInterface.h
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDKit.h"


@interface FXDsuperTableInterface : FXDViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	BOOL _isSystemVersionLatest;
	BOOL _didStartAutoScrollingToTop;
	
	NSString *_registeredNibIdentifier;
	UINib *_defaultCellNib;
	
	NSArray *_rowCounts;
	NSDictionary *_cellTexts;
	NSMutableArray *_defaultDatasource;
	
	FXDFetchedResultsController *_defaultResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_queuedOperationDictionary;
	NSMutableArray *_queuedOperationArray;
}

// Properties
@property (assign, nonatomic) BOOL isSystemVersionLatest;
@property (assign, nonatomic) BOOL didStartAutoScrollingToTop;

@property (strong, nonatomic) NSString *registeredNibIdentifier;
@property (strong, nonatomic) UINib *defaultCellNib;

@property (strong, nonatomic) NSArray *rowCounts;
@property (strong, nonatomic) NSDictionary *cellTexts;
@property (strong, nonatomic) NSMutableArray *defaultDatasource;

@property (strong, nonatomic) FXDFetchedResultsController *defaultResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *queuedOperationDictionary;
@property (strong, nonatomic) NSMutableArray *queuedOperationArray;


// IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *defaultTableview;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - at loadView

#pragma mark - at autoRotate

#pragma mark - at viewDidLoad


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public
- (FXDTableViewCell*)dequeueCellFromTableView:(UITableView*)tableView forRowAtIndexPath:(NSIndexPath*)indexPath withIdentifier:(NSString*)identifier andShouldPreconfigure:(BOOL)shouldPreconfigure;

- (BOOL)shouldSkipQueuedCellOperationsForTableView:(UITableView*)tableView forAutoScrollingToTop:(BOOL)didStartAutoScrollingToTop forRowAtIndexPath:(NSIndexPath*)indexPath;

- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)cellTextAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate
#pragma mark - UIScrollViewDelegate
#pragma mark - NSFetchedResultsControllerDelegate


@end
