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

	// IBOutlets
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
- (UIScrollView*)mainScrollView {
	if (_mainScrollView == nil) {
		
		if (self.mainTableview) {
			_mainScrollView = self.mainTableview;
		}
	}
	
	return _mainScrollView;
}


#pragma mark - Method overriding


#pragma mark - IBActions


#pragma mark - Public
- (void)initializeTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
	//MARK: for newly initialized cell.
}

- (void)configureTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {

	[self configureSectionPostionTypeForTableCell:cell forIndexPath:indexPath];
	
	UIImage *backgroundImage = [self backgroundImageForTableCellAtIndexPath:indexPath];
	UIImage *highlightedImage = [self selectedBackgroundImageForTableCellAtIndexPath:indexPath];
	[cell customizeBackgroundWithImage:backgroundImage withHighlightedImage:highlightedImage];
	
	cell.textLabel.text = (self.cellTexts)[[indexPath stringValue]];
	
	UIImage *mainImage = [self mainImageForTableCellAtIndexPath:indexPath];
	UIImage *highlightedMainImage = [self highlightedMainImageForTableCellAtIndexPath:indexPath];
	[cell customizeWithMainImage:mainImage withHighlightedMainImage:highlightedMainImage];
	
	cell.accessoryView = [self accessoryViewForTableCellAtIndexPath:indexPath];
}

- (void)configureSectionPostionTypeForTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {	//FXDLog_DEFAULT;

	NSInteger rowCount = [(self.itemCounts)[indexPath.section] integerValue];

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

- (UIImage*)backgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath {	//FXDLog_OVERRIDE;
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

- (UIImage*)selectedBackgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath {	//FXDLog_OVERRIDE;
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

#pragma mark -
- (UIImage*)mainImageForTableCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *mainImage = nil;
	
#if imagenameformatSettingsCellMainOff
	NSString *imageName = [NSString stringWithFormat:imagenameformatSettingsCellMainOff, indexPath.section, indexPath.row];
	
	mainImage = [UIImage bundledImageForName:imageName];
#endif
		
	return mainImage;
}

- (UIImage*)highlightedMainImageForTableCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *highlightedMainImage = nil;
	
#if imagenameformatSettingsCellMainOn	
	NSString *imageName = [NSString stringWithFormat:imagenameformatSettingsCellMainOn, indexPath.section, indexPath.row];
	
	highlightedMainImage = [UIImage bundledImageForName:imageName];
#endif
		
	return highlightedMainImage;
}

- (UIView*)accessoryViewForTableCellAtIndexPath:(NSIndexPath*)indexPath {
	id accessoryView = nil;
	
#if imagenameSettingsCellArrowOff
	accessoryView = [[UIImageView alloc] initWithImage:imagenameSettingsCellArrowOff];
	
	#if imagenameSettingsCellArrowOn
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


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger numberOfSections = [self numberOfSectionsForScrollView:tableView];
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = [self numberOfItemsForScrollView:tableView atSection:section];
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.mainCellIdentifier];

	//MARK: If cell Nib is registered, this will never be nil
	if (cell == nil) {	//FXDLog_OVERRIDE;
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.mainCellIdentifier];

		[self initializeTableCell:cell forIndexPath:indexPath];
	}

	[self configureTableCell:cell forIndexPath:indexPath];
	
	
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

@end
