//
//  FXDsuperTableController.m
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperTableController.h"


#pragma mark - Public implementation
@implementation FXDsuperTableController	


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

	// Properties
}


#pragma mark - Initialization
- (void)awakeFromNib {
	[super awakeFromNib];

	// Primitives

    // Instance variables

    // Properties

    // IBOutlets
	
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Primitives

	// Instance variables

	// Properties

	// IBOutlets
	if (self.mainTableview) {
		if (self.mainTableview.dataSource == nil) {
			[self.mainTableview setDataSource:self];
		}

		if (self.mainTableview.delegate == nil) {
			[self.mainTableview setDelegate:self];
		}

		if (self.mainCellIdentifier || self.mainCellNib) {
			[self.mainTableview registerNib:self.mainCellNib forCellReuseIdentifier:self.mainCellIdentifier];
		}
	}
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

#pragma mark -
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


#pragma mark - IBActions


#pragma mark - Public
- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex {

	BOOL didCancel = NO;

	id operationObjKey = nil;

	if (indexPath) {
		operationObjKey = [indexPath stringValue];
	}
	else if (rowIndex != integerNotDefined) {
		operationObjKey = [[NSIndexPath indexPathForRow:rowIndex inSection:0] stringValue];
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
- (void)initializeCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
	//MARK: for newly initialized cell.
}

- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {

	[self configureSectionPostionTypeForCell:cell forIndexPath:indexPath];
	
	UIImage *backgroundImage = [self backgroundImageForCellAtIndexPath:indexPath];
	UIImage *highlightedImage = [self selectedBackgroundImageForCellAtIndexPath:indexPath];
	[cell customizeBackgroundWithImage:backgroundImage withHighlightedImage:highlightedImage];
	
	cell.textLabel.text = [self cellTextAtIndexPath:indexPath];
	
	UIImage *mainImage = [self mainImageForCellAtIndexPath:indexPath];
	UIImage *highlightedMainImage = [self highlightedMainImageForCellAtIndexPath:indexPath];
	[cell customizeWithMainImage:mainImage withHighlightedMainImage:highlightedMainImage];
	
	cell.accessoryView = [self accessoryViewForCellAtIndexPath:indexPath];
}

- (void)configureSectionPostionTypeForCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {	//FXDLog_DEFAULT;

	NSInteger rowCount = [(self.rowCounts)[indexPath.section] integerValue];

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
}

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
		NSString *objKey = [indexPath stringValue];

		if (objKey) {
			cellText = (self.cellTexts)[objKey];
		}
	}
	
	return cellText;
}

- (NSString*)segueNameAtIndexPath:(NSIndexPath*)indexPath {
	NSString *segueName = nil;

	if (self.segueNames) {
		NSString *objKey = [indexPath stringValue];

		if (objKey) {
			segueName = (self.segueNames)[objKey];
		}
	}

	return segueName;
}

#pragma mark -
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

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height {
	CGRect dividerFrame = CGRectMake(0.0, 0.0, width, height);
	
	UIView *sectionDividingView = [[UIView alloc] initWithFrame:dividerFrame];
	sectionDividingView.backgroundColor = [UIColor clearColor];
	
	return sectionDividingView;
}

- (void)processWithDisappearedRowAndDirectionForIndexPath:(NSIndexPath*)indexPath didFinishBlock:(void(^)(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward))didFinishBlock {

	BOOL shouldContinue = NO;

	// Get valid index row for disappeared cell
	NSArray *visibleIndexPaths = [self.mainTableview indexPathsForVisibleRows];
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
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {	//FXDLog_OVERRIDE;
	NSInteger numberOfSections = 1;
	
	if (self.mainResultsController) {
		numberOfSections = [[self.mainResultsController sections] count];
	}
	else if (self.mainDataSource) {
		//MARK: Assume it's just one array
	}
	else if (self.rowCounts) {	//FXDLog_OVERRIDE;
		numberOfSections = [self.rowCounts count];
	}
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	//FXDLog_OVERRIDE;
	NSInteger numberOfRows = 0;
	
	if (self.mainResultsController) {
		NSInteger fetchedObjectsCount = [self.mainResultsController.fetchedObjects count];
		
#if ForDEVELOPER
		NSArray *sections = self.mainResultsController.sections;

		if (section < [sections count]) {
			id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];

			numberOfRows = [sectionInfo numberOfObjects];
		}
		
		if (numberOfRows != fetchedObjectsCount) {
			numberOfRows = fetchedObjectsCount;
		}
#else
		numberOfRows = fetchedObjectsCount;
#endif
		FXDLog(@"section: %d numberOfRows: %d == fetchedObjectsCount: %d", section, numberOfRows, fetchedObjectsCount);
	}
	else if (self.mainDataSource) {
		numberOfRows = [self.mainDataSource count];
	}
	else if (self.rowCounts) {	//FXDLog_OVERRIDE;
		numberOfRows = [(self.rowCounts)[section] integerValue];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.mainCellIdentifier];

	//MARK: If cell Nib is registered, this will never be nil
	if (cell == nil) {	//FXDLog_OVERRIDE;
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.mainCellIdentifier];

		[self initializeCell:cell forIndexPath:indexPath];
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
	
	if ([tableView isScrollingCurrently] == NO) {
		return;
	}
	

#warning "//TODO: Only use this when supporting for iOS version previous to 6
	[self
	 processWithDisappearedRowAndDirectionForIndexPath:indexPath
	 didFinishBlock:^(BOOL shouldContinue, NSInteger disappearedRow, BOOL shouldEvaluateBackward) {

		 if (shouldContinue == NO) {
			 return;
		 }


		 NSInteger canceledCount = 0;

		 if (shouldEvaluateBackward) {
			 for (NSInteger evaluatedRow = disappearedRow; evaluatedRow >= 0; evaluatedRow--) {
				 BOOL didCancel = [self cancelQueuedCellOperationAtIndexPath:nil orRowIndex:evaluatedRow];

				 if (didCancel) {
					 canceledCount++;
				 }
			 }
		 }
		 else {
			 for (NSInteger evaluatedRow = disappearedRow; evaluatedRow < [self.mainDataSource count]; evaluatedRow++) {
				 BOOL didCancel = [self cancelQueuedCellOperationAtIndexPath:nil orRowIndex:evaluatedRow];

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
	 }];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	
	BOOL didCancel = [self cancelQueuedCellOperationAtIndexPath:indexPath orRowIndex:integerNotDefined];

	if (didCancel) {
		FXDLog(@"didCancel: %d %@", didCancel, indexPath);
	}
}

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
