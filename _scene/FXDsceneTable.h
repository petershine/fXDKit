//
//  FXDsceneTable.h
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


#import "FXDsceneScroll.h"
@interface FXDsceneTable : FXDsceneScroll <UITableViewDataSource, UITableViewDelegate>

// IBOutlets
@property (strong, nonatomic) IBOutlet UITableView *mainTableview;


#pragma mark - IBActions

#pragma mark - Public
- (void)initializeTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;
- (void)configureTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (void)configureSectionPostionTypeForTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)mainImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForTableCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end