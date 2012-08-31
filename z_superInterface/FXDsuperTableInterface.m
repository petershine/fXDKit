//
//  FXDsuperTableInterface.m
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperTableInterface.h"


#pragma mark - Private interface
@interface FXDsuperTableInterface (Private)
@end


#pragma mark - Public implementation
@implementation FXDsuperTableInterface	

#pragma mark Synthesizing
// Properties

// IBOutlets


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
	
	// IBOutlets
	self.mainTableview = nil;
}

- (void)dealloc {
	// Instance variables

	// Properties
}


#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
	
    // Primitives
	
	// Instance variables
	_mainOperationObjKey = ^(NSInteger sectionIndex, NSInteger rowIndex) {
		NSString *operationObjKey = nil;

		if (sectionIndex != integerNotDefined && rowIndex != integerNotDefined){
			operationObjKey = [NSString stringWithFormat:@"%d%d", sectionIndex, rowIndex];
		}

		return operationObjKey;
	};
	
	// Properties	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= latestSupportedSystemVersion) {
		_isSystemVersionLatest = YES;
	}
	
	// IBOutlets
}


#pragma mark - Accessor overriding
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
- (NSArray*)rowCounts {
	
	if (_rowCounts == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _rowCounts;
}

- (NSDictionary*)cellTexts {
	
	if (_cellTexts == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _cellTexts;
}

- (NSMutableArray*)mainDataSource {
	
	if (_mainDataSource == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _mainDataSource;
}

#pragma mark -
- (FXDFetchedResultsController*)mainResultsController {
	
	if (_mainResultsController == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _mainResultsController;
}

#pragma mark -
- (NSOperationQueue*)cellOperationQueue {
	
	if (_cellOperationQueue == nil) {
		_cellOperationQueue = [[NSOperationQueue alloc] init];
	}
	
	return _cellOperationQueue;
}

- (NSMutableDictionary*)queuedOperationDictionary {
	
	if (_queuedOperationDictionary == nil) {
		_queuedOperationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _queuedOperationDictionary;
}

#pragma mark -
- (NSMutableDictionary*)cachedImageDictionary {
	
	if (_cachedImageDictionary == nil) {
		_cachedImageDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _cachedImageDictionary;
}


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.mainTableview) {
		if (self.mainTableview.dataSource == nil) {
			[self.mainTableview setDataSource:self];
		}
		
		if (self.mainTableview.delegate == nil) {
			[self.mainTableview setDelegate:self];
		}
	}
}

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


#pragma mark - Private


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)didCancelQueuedCellOperationForObjKey:(NSString*)operationObjKey orAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex {

	if (operationObjKey == nil) {
		if (indexPath) {
			operationObjKey = _mainOperationObjKey(indexPath.section, indexPath.row);
		}
		else {
			operationObjKey = _mainOperationObjKey(0, rowIndex);
		}
	}
	

	BOOL didCancel = NO;


	FXDBlockOperation *cellOperation = [self.queuedOperationDictionary objectForKey:operationObjKey];

	if (cellOperation) {
		[cellOperation cancel];

		didCancel = cellOperation.isCancelled;
	}

	[self.queuedOperationDictionary removeObjectForKey:operationObjKey];
	

	return didCancel;
}

- (BOOL)shouldSkipReturningCellForAutoScrollingToTop:(BOOL)isForAutoScrollingToTop forTableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {

	BOOL shouldSkip = NO;

	if (isForAutoScrollingToTop && indexPath.row > [[tableView indexPathsForVisibleRows] count]) {
		shouldSkip = YES;

		//FXDLog(@"shouldSkip: %d indexPath.row: %d", shouldSkip, indexPath.row);
	}

	return shouldSkip;
}


#pragma mark -
- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
	
	NSInteger rowCount = [[self.rowCounts objectAtIndex:indexPath.section] integerValue];
	
	if (rowCount == 1) {
		cell.sectionPositionType = sectionPositionOne;
	}
	else if (rowCount > 1) {
		if (indexPath.row == 0) {
			cell.sectionPositionType = sectionPositionTop;
		}
		else if (indexPath.row == rowCount-1) {
			cell.sectionPositionType = sectionPositionBottom;
		}
		else {
			cell.sectionPositionType = sectionPositionMiddle;
		}
	}
	
	UIImage *backgroundImage = [self backgroundImageForCellAtIndexPath:indexPath];
	UIImage *highlightedImage = [self selectedBackgroundImageForCellAtIndexPath:indexPath];
	[cell customizeBackgroundWithImage:backgroundImage withHighlightedImage:highlightedImage];
	
	cell.textLabel.text = [self cellTextAtIndexPath:indexPath];
	
	UIImage *mainImage = [self mainImageForCellAtIndexPath:indexPath];
	UIImage *highlightedMainImage = [self highlightedMainImageForCellAtIndexPath:indexPath];
	[cell customizeWithMainImage:mainImage withHighlightedMainImage:highlightedMainImage];
	
	cell.accessoryView = [self accessoryViewForCellAtIndexPath:indexPath];
}

#pragma mark -
- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath {	//FXDLog_OVERRIDE;
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath {	//FXDLog_OVERRIDE;
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

- (NSString*)cellTextAtIndexPath:(NSIndexPath*)indexPath {
	NSString *cellText = nil;
	
	if (self.cellTexts) {				
		NSString *objKey = [NSString stringWithFormat:@"%d%d", indexPath.section, indexPath.row];
		
		cellText = [self.cellTexts objectForKey:objKey];
	}
	
	return cellText;
}

- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *mainImage = nil;
	
#ifdef imagenameformatSettingsCellMainOff
	NSString *imageName = [NSString stringWithFormat:imagenameformatSettingsCellMainOff, indexPath.section, indexPath.row];
	
	mainImage = [UIImage bundledImageForName:imageName];
#endif
		
	return mainImage;
}

- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *highlightedMainImage = nil;
	
#ifdef imagenameformatSettingsCellMainOn	
	NSString *imageName = [NSString stringWithFormat:imagenameformatSettingsCellMainOn, indexPath.section, indexPath.row];
	
	highlightedMainImage = [UIImage bundledImageForName:imageName];
#endif
		
	return highlightedMainImage;
}

- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath {
	id accessoryView = nil;
	
#ifdef imagenameSettingsCellArrowOff
	accessoryView = [[UIImageView alloc] initWithImage:imagenameSettingsCellArrowOff];
	
	#ifdef imagenameSettingsCellArrowOn
	[(UIImageView*)accessoryView setHighlightedImage:imagenameSettingsCellArrowOn];
	#endif
#endif
	
	if (accessoryView) {
		if ([(UIImageView*)accessoryView image] == nil) {
			accessoryView = nil;
		}
	}
	
	return (UIView*)accessoryView;
}

#pragma mark -
- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height {
	CGRect dividerFrame = CGRectMake(0.0, 0.0, width, height);
	
	UIView *sectionDividingView = [[UIView alloc] initWithFrame:dividerFrame];
	sectionDividingView.backgroundColor = [UIColor clearColor];
	
	return sectionDividingView;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {	//FXDLog_OVERRIDE;
	NSInteger numberOfSections = 1;
	
	if (self.mainResultsController) {
		numberOfSections = [[self.mainResultsController sections] count];
	}
	else if (self.mainDataSource) {
		//SKIP
	}
	else if (self.rowCounts) {	//FXDLog_OVERRIDE;
		numberOfSections = [self.rowCounts count];
	}
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	//FXDLog_OVERRIDE;
	NSInteger numberOfRows = 0;
	
	if (self.mainResultsController) {
#if DEBUG
		NSArray *sections = self.mainResultsController.sections;
		
		id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
		
		numberOfRows = [sectionInfo numberOfObjects];
		
		NSInteger fetchedObjectsCount = [self.mainResultsController.fetchedObjects count];
		FXDLog(@"numberOfRows: %d == fetchedObjectsCount: %d", numberOfRows, fetchedObjectsCount);
		
		if (numberOfRows != fetchedObjectsCount) {
			numberOfRows = fetchedObjectsCount;
		}
#else
		numberOfRows = [self.defaultResultsController.fetchedObjects count];
#endif
	}
	else if (self.mainDataSource) {
		numberOfRows = [self.mainDataSource count];
	}
	else if (self.rowCounts) {	//FXDLog_OVERRIDE;
		numberOfRows = [[self.rowCounts objectAtIndex:section] integerValue];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.mainCellIdentifier];
	
	if (cell == nil) {	FXDLog_OVERRIDE;
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.mainCellIdentifier];
	}
	
	
	[self configureCell:cell forIndexPath:indexPath];
	
	return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//MARK: Use iOS 6 method
	if (self.isSystemVersionLatest) {
		return;
	}
	
	if (isTableViewScrolling == NO) {
		return;
	}
	
	
	// Get valid index row for disappeared cell
	NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];	
	NSInteger visibleRowCount = [visibleIndexPaths count];
	
	NSInteger firstVisibleRow = [[visibleIndexPaths objectAtIndex:0] row];
	NSInteger lastVisibleRow = [[visibleIndexPaths lastObject] row];

	NSInteger disappearedRow = integerNotDefined;

	if (indexPath.row == lastVisibleRow) {
		disappearedRow = lastVisibleRow -visibleRowCount;
	}
	else if (indexPath.row == firstVisibleRow) {
		disappearedRow = firstVisibleRow +visibleRowCount;
	}

	if (disappearedRow < 0) {
		return;
	}


	// Canceling queuedOperations
	BOOL shouldEvaluateBackward = NO;

	if (indexPath.row == lastVisibleRow) {
		shouldEvaluateBackward = YES;
	}

#if ForDEVELOPER
	NSInteger canceledCount = 0;
#endif

	if (shouldEvaluateBackward) {
		for (NSInteger evaluatedRow = disappearedRow; evaluatedRow >= 0; evaluatedRow--) {
			BOOL didCancel = [self didCancelQueuedCellOperationForObjKey:nil orAtIndexPath:nil orRowIndex:evaluatedRow];

			if (didCancel) {
				canceledCount++;
			}
		}
	}
	else {
		for (NSInteger evaluatedRow = disappearedRow; evaluatedRow < [self.mainDataSource count]; evaluatedRow++) {
			BOOL didCancel = [self didCancelQueuedCellOperationForObjKey:nil orAtIndexPath:nil orRowIndex:evaluatedRow];

			if (didCancel) {
				canceledCount++;
			}
		}
	}

#if ForDEVELOPER
	if (canceledCount > 0) {
		FXDLog(@"CANCELED: %d rows operationCount: %u disappearedRow: %d", canceledCount, self.cellOperationQueue.operationCount, disappearedRow);
	}
#endif
}

//MARK: Usable in iOS 6
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	BOOL didCancel = [self didCancelQueuedCellOperationForObjKey:nil orAtIndexPath:indexPath orRowIndex:integerNotDefined];

	if (didCancel) {
		FXDLog(@"didCancel: %d %@", didCancel, indexPath);
	}
}

#pragma mark -
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


#pragma mark - UIScrollViewDelegate
/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (decelerate == NO) {
		//MARK: do actions as if decelerating did end
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	// called on finger up as we are moving
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	// called when scroll view grinds to a halt
}
 */

#pragma mark -
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	//FXDLog(@"scrollView.scrollsToTop: %d", scrollView.scrollsToTop);
	
	self.didStartAutoScrollingToTop = scrollView.scrollsToTop;
	
	return scrollView.scrollsToTop;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {	//FXDLog_DEFAULT;
	
	self.didStartAutoScrollingToTop = NO;
}


#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(FXDFetchedResultsController*)controller {	FXDLog_OVERRIDE;
	
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {	FXDLog_OVERRIDE;
	
}

- (void)controller:(FXDFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {	FXDLog_OVERRIDE;
	
}

- (void)controllerDidChangeContent:(FXDFetchedResultsController*)controller {	FXDLog_OVERRIDE;
	
}


@end
