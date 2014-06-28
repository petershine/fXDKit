//
//  FXDTableViewCell.h
//
//
//  Created by petershine on 10/19/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

typedef NS_ENUM(NSInteger, SECTION_POSITION_TYPE) {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom
};


@interface FXDTableViewCell : UITableViewCell
@property (nonatomic) SECTION_POSITION_TYPE sectionPositionType;

@property (strong, nonatomic) id addedObj;

@property (strong, nonatomic) NSIndexPath *linkedIndexPath;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageview;


#pragma mark - IBActions


#pragma mark - Public
- (void)customizeBackgroundWithImage:(UIImage*)image withHighlightedImage:(UIImage*)highlightedImage;


//MARK: - Observer implementation

//MARK: - Delegate implementation


@end


#pragma mark -  Category
@interface UITableViewCell (Added)
- (void)customizeWithMainImage:(UIImage*)mainImage withHighlightedMainImage:(UIImage*)highlightedMainImage;

- (void)modifySizeOfCellSubview:(UIView*)cellSubview;
- (void)modifyOriginXofCellSubview:(UIView*)cellSubview;
- (void)modifyOriginYofCellSubview:(UIView*)cellSubview;

@end