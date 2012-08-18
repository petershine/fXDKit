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
	self.defaultTableview = nil;
}


#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
	
    // Primitives
	
	// Instance variables
	
	// Properties	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= latestSupportedSystemVersion) {
		_isSystemVersionLatest = YES;
	}
	
	// IBOutlets
}


#pragma mark - Accessor overriding
- (NSString*)registeredNibIdentifier {
	if (!_registeredNibIdentifier) {	FXDLog_OVERRIDE;
		//
	}
	
	return _registeredNibIdentifier;
}

- (UINib*)defaultCellNib {
	if (!_defaultCellNib) {
		if (self.registeredNibIdentifier) {
			_defaultCellNib = [UINib nibWithNibName:self.registeredNibIdentifier bundle:nil];
		}
	}
	
	return _defaultCellNib;
}

#pragma mark -
- (NSArray*)rowCounts {
	
	if (!_rowCounts) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _rowCounts;
}

- (NSDictionary*)cellTexts {
	
	if (!_cellTexts) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _cellTexts;
}

- (NSMutableArray*)defaultDatasource {
	
	if (!_defaultDatasource) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _defaultDatasource;
}

#pragma mark -
- (FXDFetchedResultsController*)defaultResultsController {
	
	if (!_defaultResultsController) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _defaultResultsController;
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

- (NSMutableArray*)queuedOperationArray {
	
	if (_queuedOperationArray == nil) {
		_queuedOperationArray = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	return _queuedOperationArray;
}


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.defaultTableview) {
		if (!self.defaultTableview.dataSource) {
			[self.defaultTableview setDataSource:self];
		}
		
		if (!self.defaultTableview.delegate) {
			[self.defaultTableview setDelegate:self];
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
- (BOOL)shouldSkipQueuedCellOperationsForTableView:(UITableView*)tableView forAutoScrollingToTop:(BOOL)didStartAutoScrollingToTop forOperationObjKey:(NSString*)operationObjKey atIndexPath:(NSIndexPath*)indexPath {
	
	BOOL shouldSkip = NO;
	
	if (didStartAutoScrollingToTop == NO) {
		return shouldSkip;
	}
	
	if (indexPath.row > [[tableView indexPathsForVisibleRows] count]) {
		shouldSkip = YES;
		
		NSBlockOperation *cellOperation = [self.queuedOperationDictionary objectForKey:operationObjKey];
		
		if (cellOperation && cellOperation.isExecuting == NO) {
			[self.queuedOperationDictionary removeObjectForKey:operationObjKey];
			
			[cellOperation cancel];
			
			FXDLog(@"shouldSkip: %d, operationObjKey: %@", shouldSkip, operationObjKey);
		}
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
- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath {	FXDLog_OVERRIDE;
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath {	FXDLog_OVERRIDE;
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

- (NSString*)cellTextAtIndexPath:(NSIndexPath*)indexPath {
	NSString *cellText = nil;
	
	if (self.cellTexts) {				
		NSString *keyForObj = [NSString stringWithFormat:@"%d%d", indexPath.section, indexPath.row];
		
		cellText = [self.cellTexts objectForKey:keyForObj];
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
		if (![(UIImageView*)accessoryView image]) {
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
	
	if (self.defaultResultsController) {
		//SKIP
	}
	else if (self.defaultDatasource) {
		//SKIP
	}
	else if (self.rowCounts) {	FXDLog_OVERRIDE;
		numberOfSections = [self.rowCounts count];
	}
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	//FXDLog_OVERRIDE;
	NSInteger numberOfRows = 0;
	
	if (self.defaultResultsController) {
		NSArray *sections = self.defaultResultsController.sections;
		
		id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
		
		numberOfRows = [sectionInfo numberOfObjects];
	}
	else if (self.defaultDatasource) {
		numberOfRows = [self.defaultDatasource count];
	}
	else if (self.rowCounts) {	FXDLog_OVERRIDE;
		numberOfRows = [[self.rowCounts objectAtIndex:section] integerValue];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	//FXDLog_OVERRIDE;
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.registeredNibIdentifier];
	
	if (!cell) {
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.registeredNibIdentifier];
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
	
	
	if (!tableView.isTracking && !tableView.isDragging && !tableView.isDecelerating && !self.didStartAutoScrollingToTop) {
		return;
	}
	
	
	NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
	NSInteger visibleCount = [visibleIndexPaths count];
	
	NSInteger disappearedRow = integerNotDefined;
	NSInteger finalRow = integerNotDefined;
	
	NSInteger firstVisibleRow = [[visibleIndexPaths objectAtIndex:0] row];
	NSInteger lastVisibleRow = [[visibleIndexPaths lastObject] row];
	
	if (indexPath.row == lastVisibleRow) {
		disappearedRow = lastVisibleRow -visibleCount;
		finalRow = 0;
	}
	else if (indexPath.row == firstVisibleRow) {
		disappearedRow = firstVisibleRow +visibleCount;
		finalRow = [self.defaultDatasource count] -1;
	}
	
	if (disappearedRow >= 0 && finalRow >= 0) {
		NSInteger startIndex = (disappearedRow > finalRow) ? finalRow:disappearedRow;
		NSInteger endIndex = (disappearedRow > finalRow) ? (disappearedRow+1):(finalRow+1);
#if ForDEVELOPER
		NSInteger canceledCount = 0;
#endif
		for (NSInteger canceledRow = startIndex; canceledRow < endIndex; canceledRow++) {
			NSString *operationObjKey = [NSString stringWithFormat:@"%d%d", indexPath.section, canceledRow];
			
			NSBlockOperation *cellOperation = [self.queuedOperationDictionary objectForKey:operationObjKey];
			
			if (cellOperation && cellOperation.isExecuting == NO) {
				[self.queuedOperationDictionary removeObjectForKey:operationObjKey];
				
				[cellOperation cancel];
#if ForDEVELOPER
				canceledCount++;
#endif
			}
		}
#if ForDEVELOPER
		if (canceledCount > 0) {
			//FXDLog(@"CANCELED: %d rows queuedOperation.count: %d disappearedRow: %d", canceledCount, [self.queuedOperationDictionary count], disappearedRow);
		}
#endif
	}
}

//MARK: Usable in iOS 6
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	NSString *operationObjKey = [NSString stringWithFormat:@"%d%d", indexPath.section, indexPath.row];
	
	NSOperation *cellOperation = [self.queuedOperationDictionary objectForKey:operationObjKey];
	
	if (cellOperation && cellOperation.isExecuting == NO) {
		[self.queuedOperationDictionary removeObjectForKey:operationObjKey];
		
		[cellOperation cancel];
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

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {	FXDLog_DEFAULT;
	
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
