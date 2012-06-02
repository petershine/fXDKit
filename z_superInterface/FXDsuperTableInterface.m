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
@synthesize rowCounts = _rowCounts;
@synthesize cellTexts = _cellTexts;

@synthesize defaultDatasource = _defaultDatasource;

// IBOutlets
@synthesize defaultTableview;


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
}

- (void)viewDidUnload {
	// IBOutlets
	self.defaultTableview = nil;
	
	[super viewDidUnload];
}

- (void)dealloc {	
	// Instance variables
	
	// Properties
	[_rowCounts release];
	[_cellTexts  release];
	
	[_defaultDatasource release];
	
	// IBOutlets
	
	[super dealloc];
}


#pragma mark - Initialization
- (void)awakeFromNib {
    [super awakeFromNib];
	
    // Primitives
	
	// Instance variables
	
	// Properties
	_rowCounts = nil;
	_cellTexts = nil;
	
	_defaultDatasource = nil;
	
	// IBOutlets
}


#pragma mark - Accessor overriding
- (NSArray*)rowCounts {
	
	if (_rowCounts == nil) {	FXDLog_OVERRIDE;
		//
	}
	
	return _rowCounts;
}

- (NSDictionary*)rowTexts {
	
	if (_cellTexts == nil) {	FXDLog_OVERRIDE;
		//
	}
	
	return _cellTexts;
}

#pragma mark -
- (NSArray*)defaultDatasource {
	
	if (_defaultDatasource == nil) {	FXDLog_OVERRIDE;
		//
	}
	
	return _defaultDatasource;
}


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.defaultTableview setDataSource:self];
	[self.defaultTableview setDelegate:self];
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
	
	mainImage = [FXDImage bundledImageForName:imageName];
#endif
		
	return mainImage;
}

- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *highlightedMainImage = nil;
	
#ifdef imagenameformatSettingsCellMainOn	
	NSString *imageName = [NSString stringWithFormat:imagenameformatSettingsCellMainOn, indexPath.section, indexPath.row];
	
	highlightedMainImage = [FXDImage bundledImageForName:imageName];
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
			[accessoryView release];
			accessoryView = nil;
		}
		else {
			[accessoryView autorelease];
		}
	}
	
	return (UIView*)accessoryView;
}

#pragma mark -
- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height {
	CGRect dividerFrame = CGRectMake(0.0, 0.0, width, height);
	
	UIView *sectionDividingView = [[UIView alloc] initWithFrame:dividerFrame];
	[sectionDividingView autorelease];
	
	sectionDividingView.backgroundColor = [UIColor clearColor];
	
	return sectionDividingView;
}


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger numberOfSections = 0;
	
	if (self.rowCounts) {
		numberOfSections = [self.rowCounts count];
	}
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = 0;

	if (self.rowCounts) {
		numberOfRows = [[self.rowCounts objectAtIndex:section] integerValue];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"cellIdentifier";
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	[self configureCell:cell forIndexPath:indexPath];
	
	return cell;
}


#pragma mark - UITableViewDelegate


@end
