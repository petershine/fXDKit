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
	_registeredNibIdentifier = nil;
	
	_rowCounts = nil;
	_cellTexts = nil;
	_defaultDatasource = nil;
	
	_cellConfigurationQueue = nil;
	_operationDictionary = nil;
	_operationArray = nil;
	
	_defaultResultsController = nil;
	
	// IBOutlets
}


#pragma mark - Accessor overriding
- (NSString*)registeredNibIdentifier {
	if (_registeredNibIdentifier == nil) {	FXDLog_OVERRIDE;
		//
	}
	
	return _registeredNibIdentifier;
}

#pragma mark -
- (NSArray*)rowCounts {
	
	if (_rowCounts == nil) {	//FXDLog_OVERRIDE;
		//
	}
	
	return _rowCounts;
}

- (NSDictionary*)cellTexts {
	
	if (_cellTexts == nil) {	FXDLog_OVERRIDE;
		//
	}
	
	return _cellTexts;
}

- (NSMutableArray*)defaultDatasource {
	
	if (_defaultDatasource == nil) {	FXDLog_OVERRIDE;
		//
	}
	
	return _defaultDatasource;
}

#pragma mark -
- (NSOperationQueue*)cellConfigurationQueue {
	
	if (_cellConfigurationQueue == nil) {
		_cellConfigurationQueue = [[NSOperationQueue alloc] init];
	}
	
	return _cellConfigurationQueue;
}

- (NSMutableDictionary*)operationDictionary {
	
	if (_operationDictionary == nil) {
		_operationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
	}
	
	return _operationDictionary;
}

- (NSMutableArray*)operationArray {
	
	if (_operationArray == nil) {
		_operationArray = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	return _operationArray;
}


#pragma mark - at loadView


#pragma mark - at autoRotate


#pragma mark - at viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (self.defaultTableview) {
		if (self.defaultTableview.dataSource == nil) {
			[self.defaultTableview setDataSource:self];
		}
		
		if (self.defaultTableview.delegate == nil) {
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
	
	if (self.rowCounts) {
		numberOfSections = [self.rowCounts count];
	}
	
	return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	//FXDLog_OVERRIDE;
	NSInteger numberOfRows = 0;

	if (self.rowCounts) {
		numberOfRows = [[self.rowCounts objectAtIndex:section] integerValue];
	}
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	FXDLog_OVERRIDE;
	
	static NSString *identifier = @"cellIdentifier";
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	}
	
	[self configureCell:cell forIndexPath:indexPath];
	
	return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	//FXDLog_OVERRIDE;
	
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {	//FXDLog_OVERRIDE;
	
}

#pragma mark -
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
