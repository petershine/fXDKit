//
//  FXDsuperTableScene.m
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperTableScene.h"


#pragma mark - Public implementation
@implementation FXDsuperTableScene	


#pragma mark - Memory management
- (void)dealloc {
	[_mainTableview setDelegate:nil];
	[_mainTableview setDataSource:nil];
}


#pragma mark - Initialization

#pragma mark - Autorotating

#pragma mark - View Appearing

#pragma mark - Property overriding
- (UIScrollView*)mainScrollview {
	if (_mainScrollview == nil) {
		
		if (self.mainTableview) {
			_mainScrollview = self.mainTableview;
		}
		else {
			_mainScrollview = [super mainScrollview];
		}
	}
	
	return _mainScrollview;
}


#pragma mark - Method overriding
- (void)willMoveToParentViewController:(UIViewController *)parent {
	
	if (parent == nil) {
		[self.mainTableview setDataSource:nil];
	}
	
	[super willMoveToParentViewController:parent];
}

#pragma mark -
- (void)registerMainCellNib {
	
	if (self.mainCellNib == nil && self.mainCellIdentifier == nil) {
		[super registerMainCellNib];
		return;
	}
	
	
	FXDLog_DEFAULT;
	
	[self.mainTableview registerNib:self.mainCellNib forCellReuseIdentifier:self.mainCellIdentifier];
}


#pragma mark - IBActions

#pragma mark - Public
- (void)initializeTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
	//MARK: for newly initialized cell.
}

- (void)configureTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
#if ForDEVELOPER
	if (self.mainCellNib) {
		FXDLog(@"WARNING: %@", @"Make sure to configure properly");
	}
#endif

	[self configureSectionPostionTypeForTableCell:cell forIndexPath:indexPath];
	
	UIImage *backgroundImage = [self backgroundImageForTableCellAtIndexPath:indexPath];
	UIImage *highlightedImage = [self selectedBackgroundImageForTableCellAtIndexPath:indexPath];
	[cell customizeBackgroundWithImage:backgroundImage withHighlightedImage:highlightedImage];
	
	cell.textLabel.text = (self.cellTitleDictionary)[indexPath];
	cell.detailTextLabel.text = (self.cellSubTitleDictionary)[indexPath];
	
	UIImage *mainImage = [self mainImageForTableCellAtIndexPath:indexPath];
	UIImage *highlightedMainImage = [self highlightedMainImageForTableCellAtIndexPath:indexPath];
	[cell customizeWithMainImage:mainImage withHighlightedMainImage:highlightedMainImage];
	
	cell.accessoryView = [self accessoryViewForTableCellAtIndexPath:indexPath];
}

- (void)configureSectionPostionTypeForTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {

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

- (UIImage*)backgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

- (UIImage*)selectedBackgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath {
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

	if (cell == nil) {
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.mainCellIdentifier];

		[self initializeTableCell:cell forIndexPath:indexPath];
	}

	[self configureTableCell:cell forIndexPath:indexPath];
	
	
	return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	
	BOOL didCancel = [self cancelQueuedCellOperationAtIndexPath:indexPath orRowIndex:integerNotDefined];

	if (didCancel) {
		FXDLog(@"%@ %@", _BOOL(didCancel), _Object(indexPath));
	}
}

@end