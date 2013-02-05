//
//  FXDsuperScrollController.m
//
//
//  Created by petershine on 2/5/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDsuperScrollController.h"


#pragma mark - Public implementation
@implementation FXDsuperScrollController


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	// Instance variables
	FXDLog(@"_cellOperationQueue operationCount: %u", [_cellOperationQueue operationCount]);
	
	[_cellOperationQueue cancelAllOperations];
	_cellOperationQueue = nil;
	
	
	[_cellOperationDictionary removeAllObjects];
	_cellOperationDictionary = nil;
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];
	
	// Primitives
	
    // Instance variables
	
    // Properties
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
    // IBOutlet
}


#pragma mark - Autorotating


#pragma mark - View Appearing
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark - Property overriding
- (NSString*)mainCellIdentifier {
	if (_mainCellIdentifier == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _mainCellIdentifier;
}

- (UINib*)mainCellNib {
	if (_mainCellNib == nil) {
		if (self.mainCellIdentifier) {
			_mainCellNib = [UINib nibWithNibName:self.mainCellIdentifier bundle:nil];
		}
	}
	
	return _mainCellNib;
}

#pragma mark -
- (NSMutableArray*)mainDataSource {
	
	if (_mainDataSource == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _mainDataSource;
}

- (FXDFetchedResultsController*)mainResultsController {
	
	if (_mainResultsController == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _mainResultsController;
}

#pragma mark -
- (NSOperationQueue*)cellOperationQueue {
	
	if (_cellOperationQueue == nil) {	FXDLog_OVERRIDE;
		_cellOperationQueue = [[NSOperationQueue alloc] init];
		
		[_cellOperationQueue setMaxConcurrentOperationCount:limitConcurrentOperationCount];
		FXDLog(@"maxConcurrentOperationCount: %d", [_cellOperationQueue maxConcurrentOperationCount]);
	}
	
	return _cellOperationQueue;
}

- (NSMutableDictionary*)cellOperationDictionary {
	
	if (_cellOperationDictionary == nil) {
		_cellOperationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _cellOperationDictionary;
}


#pragma mark - Method overriding


#pragma mark - Segues


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex {
	
	BOOL didCancel = NO;
	
	id operationObjKey = nil;
	
	if (indexPath) {
		operationObjKey = [indexPath stringValue];
	}
	else if (rowIndex != integerNotDefined) {
		operationObjKey = NSIndexPathString(0, rowIndex);
	}
	
	if (operationObjKey == nil) {
		return didCancel;
	}
	
	
	FXDBlockOperation *cellOperation = (self.cellOperationDictionary)[operationObjKey];
	
	if (cellOperation) {
		[cellOperation cancel];
		
		didCancel = cellOperation.isCancelled;
	}
	
	
	return didCancel;
}

#pragma mark -
- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath didFinishBlock:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))didFinishBlock {
	
	BOOL shouldContinue = NO;
	
	// Get valid index row for disappeared cell
	if ([self.mainScrollView isKindOfClass:[UITableView class]] == NO) {
		FXDLog(@"self.mainScrollView: %@", self.mainScrollView);
		
		didFinishBlock(shouldContinue, integerNotDefined, NO);
		return;
	}
	
	
	NSArray *visibleIndexPaths = [(UITableView*)self.mainScrollView indexPathsForVisibleRows];
	NSInteger visibleRowCount = [visibleIndexPaths count];
	
	if (visibleRowCount == 0) {
		FXDLog(@"visibleRowCount: %d", visibleRowCount);
		
		didFinishBlock(shouldContinue, integerNotDefined, NO);
		
		return;
	}
	
	
	NSInteger firstVisibleRow = [visibleIndexPaths[0] row];
	NSInteger lastVisibleRow = [[visibleIndexPaths lastObject] row];
	
	NSInteger disappearedRow = integerNotDefined;
	
	if (indexPath.row == lastVisibleRow) {
		disappearedRow = lastVisibleRow -visibleRowCount;
	}
	else if (indexPath.row == firstVisibleRow) {
		disappearedRow = firstVisibleRow +visibleRowCount;
	}
	
	if (disappearedRow < 0) {
		didFinishBlock(shouldContinue, integerNotDefined, NO);
		
		return;
	}
	
	
	// Canceling queuedOperations
	BOOL shouldEvaluateBackward = NO;
	
	if (indexPath.row == lastVisibleRow) {
		shouldEvaluateBackward = YES;
	}
	
	shouldContinue = YES;
	
	
	didFinishBlock(shouldContinue, disappearedRow, shouldEvaluateBackward);
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {	FXDLog_DEFAULT;
	FXDLog(@"scrollView.scrollsToTop: %d self.didStartAutoScrollingToTop: %d", scrollView.scrollsToTop, self.didStartAutoScrollingToTop);
	
	self.didStartAutoScrollingToTop = scrollView.scrollsToTop;
	
	return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {	FXDLog_DEFAULT;
	
	self.didStartAutoScrollingToTop = NO;
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {	FXDLog_OVERRIDE;
	
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {	FXDLog_OVERRIDE;
	
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {	FXDLog_OVERRIDE;
	FXDLog(@"type: %d", type);
	FXDLog(@"indexPath: %@ newIndexPath: %@", indexPath, newIndexPath);
	
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {	FXDLog_OVERRIDE;
	
}

@end