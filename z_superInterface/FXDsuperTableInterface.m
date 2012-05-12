//
//  FXDsuperTableInterface.m
//
//
//  Created by Anonymous on 1/20/12.
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
@synthesize rowTexts = _rowTexts;

@synthesize defaultDatasource = _defaultDatasource;

// IBOutlets
@synthesize defaultTableview;


#pragma mark - Memory management
- (void)didReceiveMemoryWarning {	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc that aren't in use.
	
	// Properties
}

- (void)viewDidUnload {	// Release any retained subviews of the main view.	
	// IBOutlets
	
	[super viewDidUnload];
}

- (void)dealloc {	
	// Instance variables
	
	// Properties
	[_rowCounts release];
	[_rowTexts  release];
	
	[_defaultDatasource release];
	
	// IBOutlets
	
	[super dealloc];
}

#pragma mark -
- (void)nilifyIBOutlets {	
	// IBOutlets
	self.defaultTableview = nil;
	
	[super nilifyIBOutlets];
}


#pragma mark - Initialization
- (void)configureForAllInitializers {
    [super configureForAllInitializers];
	
    // Primitives
	
	// Instance variables
	
	// Properties
	_rowCounts = nil;
	_rowTexts = nil;
	
	_defaultDatasource = nil;
	
	// IBOutlets
}


#pragma mark - Accessor overriding


#pragma mark - at loadView
- (void)loadView {
	[super loadView];
	
	// Implement loadView to create a view hierarchy programmatically, without using a nib.
}


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
- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {	//FXDLog_DEFAULT;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
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
	
	cell.textLabel.text = [self textForCellAtIndexPath:indexPath];
	
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

- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *backgroundImage = nil;
	
	return backgroundImage;
}

- (NSString*)textForCellAtIndexPath:(NSIndexPath*)indexPath {
	NSString *textForCell = nil;
	
	if (self.rowTexts) {				
		NSString *keyForObj = [NSString stringWithFormat:@"%d%d", indexPath.section, indexPath.row];
		
		textForCell = [self.rowTexts objectForKey:keyForObj];
	}
	
	return textForCell;
}

- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *mainImage = nil;
	
#ifdef imagenameformatCellMain	
	NSString *imageName = [NSString stringWithFormat:imagenameformatCellMain, indexPath.section, indexPath.row];
	
	mainImage = [FXDImage bundledImageForName:imageName];
#endif
	
	return mainImage;
}

- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath {
	UIImage *highlightedMainImage = nil;
	
#ifdef imagenameformatCellMainOn	
	NSString *imageName = [NSString stringWithFormat:imagenameformatCellMainOn, indexPath.section, indexPath.row];
	
	highlightedMainImage = [FXDImage bundledImageForName:imageName];
#endif
	
	return highlightedMainImage;
}

- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath {	//FXDLog_OVERRIDE;
	id accessoryView = nil;
	
#ifdef imagenameCellArrow
	accessoryView = [[UIImageView alloc] initWithImage:imagenameCellArrow];
	[accessoryView autorelease];
	
#ifdef imagenameCellArrowOn
	[(UIImageView*)accessoryView setHighlightedImage:imagenameCellArrowOn];
#endif
#endif
	
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
	
	static NSString *identifier = @"TableViewCellIdentifier";
	
	FXDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if (cell == nil) {
		cell = [[FXDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = tableView.rowHeight;
	
	UIImage *backgroundImage = [self backgroundImageForCellAtIndexPath:indexPath];
	
	if (backgroundImage) {
		height = backgroundImage.size.height;

		FXDLog(@"section: %d, row: %d height: %f", indexPath.section, indexPath.row, height);
	}

	return height;
}


@end
