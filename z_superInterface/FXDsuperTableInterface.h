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
	NSString *_registeredNibIdentifier;
	
	NSArray *_rowCounts;
	NSDictionary *_cellTexts;
	NSMutableArray *_defaultDatasource;
	
	NSOperationQueue *_defaultOperationQueue;
	NSMutableDictionary *_addedOperations;
	
	FXDFetchedResultsController *_defaultResultsController;
}

// Properties
@property (strong, nonatomic) NSString *registeredNibIdentifier;

@property (strong, nonatomic) NSArray *rowCounts;
@property (strong, nonatomic) NSDictionary *cellTexts;
@property (strong, nonatomic) NSMutableArray *defaultDatasource;

@property (strong, nonatomic) NSOperationQueue *defaultOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *addedOperations;

@property (strong, nonatomic) FXDFetchedResultsController *defaultResultsController;

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
#pragma mark - NSFetchedResultsControllerDelegate


@end
