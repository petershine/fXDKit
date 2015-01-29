

#import "FXDsceneTable.h"


@implementation FXDsceneTable	

#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Autorotating

#pragma mark - View Appearing
- (void)willMoveToParentViewController:(UIViewController *)parent {

	if (parent == nil) {
		self.mainTableview.delegate = nil;
		self.mainTableview.dataSource = nil;
	}

	[super willMoveToParentViewController:parent];
}


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
- (void)registerMainCellNib {
	
	if ((self.mainCellNib == nil && self.mainCellIdentifier == nil)
		|| self.mainTableview == nil) {
		[super registerMainCellNib];
		return;
	}


	FXDLog_DEFAULT;
	FXDLogObject(self.mainCellNib);
	FXDLogObject(self.mainCellIdentifier);

	FXDLogObject(self.mainTableview);
	[self.mainTableview registerNib:self.mainCellNib forCellReuseIdentifier:self.mainCellIdentifier];
}


#pragma mark - IBActions

#pragma mark - Public
- (void)initializeTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
	//NOTE: for newly initialized cell.
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

	return mainImage;
}

- (UIImage*)highlightedMainImageForTableCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *highlightedMainImage = nil;

	return highlightedMainImage;
}

- (UIView*)accessoryViewForTableCellAtIndexPath:(NSIndexPath*)indexPath {
	id accessoryView = nil;

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

#pragma mark - Observer

#pragma mark - Delegate
//NOTE: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger numberOfSections = [self numberOfSectionsForScrollView:tableView];
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = [self numberOfItemsForScrollView:tableView atSection:section];
	
	return numberOfRows;
}

#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.mainCellIdentifier];

	if (cell == nil) {
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.mainCellIdentifier];

		[self initializeTableCell:cell forIndexPath:indexPath];
	}

	[self configureTableCell:cell forIndexPath:indexPath];
	
	
	return cell;
}


//NOTE: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	
	BOOL didCancel = [self.cellOperationQueue
					  cancelOperationForKey:indexPath
					  withDictionary:self.cellOperationDictionary];

	if (didCancel) {
		//FXDLog(@"%@ %@", _BOOL(didCancel), _Object(indexPath));
	}
}

@end
