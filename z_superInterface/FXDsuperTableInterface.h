//
//  FXDsuperTableInterface.h
//
//
//  Created by petershine on 1/20/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

#import "FXDViewController.h"
#import "FXDTableViewCell.h"


@interface FXDsuperTableInterface : FXDViewController <UITableViewDataSource, UITableViewDelegate> {
    // Primitives
	
	// Instance variables
	
	// Properties : For subclass to be able to reference
	NSArray *_rowCounts;
	NSDictionary *_rowTexts;
	
	NSArray *_defaultDatasource;
}

// Properties
@property (retain, nonatomic) NSArray *rowCounts;
@property (retain, nonatomic) NSDictionary *rowTexts;

@property (retain, nonatomic) NSArray *defaultDatasource;

// IBOutlets
@property (retain, nonatomic) IBOutlet UITableView *defaultTableview;


#pragma mark - Memory management

#pragma mark - Initialization

#pragma mark - Accessor overriding


#pragma mark - at loadView

#pragma mark - at autoRotate

#pragma mark - at viewDidLoad


#pragma mark - Private : if declared here, it's for subclass to be able to use these


#pragma mark - Overriding


#pragma mark - IBActions


#pragma mark - Public
- (void)configureCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*)textForCellAtIndexPath:(NSIndexPath*)indexPathgi;
- (UIImage*)mainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;


//MARK: - Observer implementation

//MARK: - Delegate implementation
#pragma mark - UITableViewDataSource
#pragma mark - UITableViewDelegate


@end
