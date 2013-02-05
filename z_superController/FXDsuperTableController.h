//
//  FXDsuperTableController.h
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDsuperScrollController.h"

@interface FXDsuperTableController : FXDsuperScrollController <UITableViewDataSource, UITableViewDelegate> {
    // Primitives

	// Instance variables
	NSDictionary *_cellTexts;
	NSArray *_rowCounts;
}

// Properties
@property (strong, nonatomic) NSDictionary *cellTexts;
@property (strong, nonatomic) NSArray *rowCounts;

// IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *mainTableview;


#pragma mark - IBActions


#pragma mark - Public
- (void)initializeCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;
- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (void)configureSectionPostionTypeForCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
